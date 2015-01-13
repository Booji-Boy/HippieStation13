#define MINIMUM_SPEED 0.5

/mob/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0) return 1

	if(istype(mover) && mover.checkpass(PASSMOB))
		return 1
	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return 1
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)
	return


/client/Northeast()
	swap_hand()
	return


/client/Southeast()
	attack_self()
	return


/client/Southwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_throw_mode()
	else
		usr << "<span class='danger'>This mob type cannot throw items.</span>"
	return


/client/Northwest()
	if(!usr.get_active_hand())
		usr << "<span class='warning'>You have nothing to drop in your hand!</span>"
		return
	usr.drop_item()

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		usr << "<span class='notice'>You are not pulling anything.</span>"
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set category = "IC"
	set name = "Swap hands"

	if(mob)
		mob.swap_hand()

/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob))
		mob.drop_item_v()
	return


/client/Center()
	if (isobj(mob.loc))
		var/obj/O = mob.loc
		if (mob.canmove)
			return O.relaymove(mob, 16)
	return


/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.loc = get_step(mob.control_object,direct)
	return


/client/Move(n, direct)
	if(!mob)
		return 0
	if(mob.notransform)
		return 0	//This is sota the goto stop mobs from moving var
	if(mob.control_object)
		return Move_object(direct)
	if(world.time < move_delay)
		return 0
	if(!isliving(mob))
		return mob.Move(n,direct)
	if(mob.stat == DEAD)
		mob.ghostize()
		return 0
	if(isAI(mob))
		return AIMove(n,direct,mob)
	if(moving)
		return 0
	if(isliving(mob))
		var/mob/living/L = mob
		if(L.incorporeal_move)	//Move though walls
			Process_Incorpmove(direct)
			return 0

	if(Process_Grab())	return

	if(mob.buckled)							//if we're buckled to something, tell it we moved.
		return mob.buckled.relaymove(mob, direct)

	if(!mob.canmove)
		return 0

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)


	if(isobj(mob.loc) || ismob(mob.loc))	//Inside an object, tell it we moved
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)

	if(!mob.Process_Spacemove(direct))
		return 0

	if(isturf(mob.loc))

		if(mob.restrained())	//Why being pulled while cuffed prevents you from moving
			for(var/mob/M in range(mob, 1))
				if(M.pulling == mob)
					if(!M.restrained() && M.stat == 0 && M.canmove && mob.Adjacent(M))
						src << "<span class='notice'>You're restrained! You can't move!</span>"
						return 0
					else
						M.stop_pulling()

		var/inc = 0
		move_delay = world.time//set move delay

		switch(mob.m_intent)
			if("run")
				if(mob.drowsyness > 0)
					inc += 6
				inc += config.run_speed
			if("walk")
				inc += config.walk_speed
		inc += mob.movement_delay()

		src << inc

		if(inc > MINIMUM_SPEED)
			/*// Force increment to be a power of two
			--inc
			inc |= inc >> 1
			inc |= inc >> 2
			inc |= inc >> 4
			inc |= inc >> 8
			inc |= inc >> 16
			++inc*/
		else
			// Enforce a minimum speed rather than relying on tickrate with negative speeds
			// This won't be as smooth
			inc = MINIMUM_SPEED

		mob.glide_size = 32 * world.tick_lag / inc

		src << "for [inc] @ [mob.glide_size]/t"

		if(mob.pulling)
			mob.pulling.glide_size = mob.glide_size

		if(mob.m_intent == "walk")
			inc += 1

		move_delay += inc

		//We are now going to move
		moving = 1
		//Something with pulling things
		if(locate(/obj/item/weapon/grab, mob))
			move_delay = max(move_delay, world.time + 7)
			var/list/L = mob.ret_grab()
			if(istype(L, /list))
				if(L.len == 2)
					L -= mob
					var/mob/M = L[1]
					if(M)
						if ((get_dist(mob, M) <= 1 || M.loc == mob.loc))
							var/turf/T = mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(mob, M) > 1 || diag))
									M.glide_size = mob.glide_size
									step(M, get_dir(M.loc, T))
				else
					for(var/mob/M in L)
						M.other_mobs = 1
						if(mob != M)
							M.animate_movement = 3
					for(var/mob/M in L)
						spawn( 0 )
							M.glide_size = mob.glide_size
							step(M, direct)
							return
						spawn( 1 )
							M.other_mobs = null
							M.animate_movement = 2
							return

		if(mob.confused && IsEven(world.time))
			step(mob, pick(cardinal))
		else
			. = ..()

		moving = 0
		if(mob && .)
			mob.throwing = 0

		return .


///Process_Grab()
///Called by client/Move()
///Checks to see if you are being grabbed and if so attemps to break it
/client/proc/Process_Grab()
	if(locate(/obj/item/weapon/grab, locate(/obj/item/weapon/grab, mob.grabbed_by.len)))
		var/list/grabbing = list()

		if(istype(mob.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = mob.l_hand
			grabbing += G.affecting

		if(istype(mob.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = mob.r_hand
			grabbing += G.affecting

		for(var/obj/item/weapon/grab/G in mob.grabbed_by)
			if(G.state == GRAB_PASSIVE && !grabbing.Find(G.assailant))
				qdel(G)

			if(G.state == GRAB_AGGRESSIVE)
				move_delay = world.time + 10
				if(!prob(25))
					return 1
				mob.visible_message("<span class='warning'>[mob] has broken free of [G.assailant]'s grip!</span>")
				qdel(G)

			if(G.state == GRAB_NECK)
				move_delay = world.time + 10
				if(!prob(5))
					return 1
				mob.visible_message("<span class='warning'>[mob] has broken free of [G.assailant]'s headlock!</span>")
				qdel(G)
	return 0


///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)
	if(!isliving(mob))
		return
	var/mob/living/L = mob
	switch(L.incorporeal_move)
		if(1)
			L.loc = get_step(L, direct)
			L.dir = direct
		if(2)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				L.loc = locate(locx,locy,mobloc.z)
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, L.loc))
						spawn(0)
							anim(T,L,'icons/mob/mob.dmi',,"shadow",,L.dir)
						limit--
						if(limit<=0)	break
			else
				spawn(0)
					anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,L.dir)
				L.loc = get_step(L, direct)
			L.dir = direct
	return 1


///Process_Spacemove
///Called by /client/Move()
///For moving in space
///Return 1 for movement 0 for none
/mob/Process_Spacemove(var/movement_dir = 0)

	if(..())
		return 1

	var/atom/movable/dense_object_backup
	for(var/atom/A in orange(1, get_turf(src)))
		if(isarea(A))
			continue

		else if(isturf(A))
			var/turf/turf = A
			if(istype(turf,/turf/space))
				continue

			if(!turf.density && !mob_negates_gravity())
				continue

			return 1

		else
			var/atom/movable/AM = A
			if(AM == buckled) //Kind of unnecessary but let's just be sure
				continue
			if(AM.density)
				if(AM.anchored)
					if(istype(AM, /obj/item/projectile)) //"You grab the bullet and push off of it!" No
						continue
					return 1
				if(pulling == AM)
					continue
				dense_object_backup = AM

	if(movement_dir && dense_object_backup)
		if(dense_object_backup.newtonian_move(turn(movement_dir, 180))) //You're pushing off something movable, so it moves
			src << "<span class='info'>You push off of [dense_object_backup] to propel yourself.</span>"


		return 1
	return 0

/mob/proc/mob_has_gravity(turf/T)
	return has_gravity(src, T)

/mob/proc/mob_negates_gravity()
	return 0

/mob/proc/Move_Pulled(var/atom/A)
	if (!canmove || restrained() || !pulling)
		return
	if (pulling.anchored)
		return
	if (!pulling.Adjacent(src))
		return
	if (A == loc && pulling.density)
		return
	if (!Process_Spacemove(get_dir(pulling.loc, A)))
		return
	if (ismob(pulling))
		var/mob/M = pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(pulling, get_dir(pulling.loc, A))
		if(M)
			M.start_pulling(t)
	else
		step(pulling, get_dir(pulling.loc, A))
	return

/mob/proc/slip(var/s_amount, var/w_amount, var/obj/O, var/lube)
	return

/mob/proc/update_gravity()
	return
