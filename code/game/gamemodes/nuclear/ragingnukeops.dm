/datum/game_mode/nuclear/raginnukeops
	name = "Ragin' Nuke Ops"
	config_tag = "raginnukeops"
	required_players = 0
	var/max_ops = 20
	var/making_op = 0
	var/ops_made = 1
	var/time_checked = 0
	var/finished = 0
	required_enemies = 0
	var/wave = 0
/datum/game_mode/nuclear/raginnukeops/announce()
	world << "<B>The current game mode is - Ragin' Nuke Ops!</B>"
	world << "<B>The <span class='warning'>Swiggity Swoogity those nuke ops becoming for that disk booty!</B>"

/datum/game_mode/nuclear/raginnukeops/post_setup()
	var/playercount = 0
	..()
	if(!max_ops)
		for(var/mob/living/player in mob_list)
			if (player.client && player.stat != 2)
				playercount += 1
			max_ops = round(playercount / 2)

/datum/game_mode/nuclear/raginnukeops/greet_syndicate(var/datum/mind/nuke, var/you_are=1)
	if (you_are)
		nuke.current << "<B>You are a Nuclear Operative</B>"
	nuke.current << "<B>The Syndicate has given you the following tasks:</B>"

	var/obj_count = 1
	nuke.current << "<b>Objective Alpha</b>: Get dat fukken disk."
	for(var/datum/objective/objective in nuke.objectives)
		nuke.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/nuclear/raginnukeops/check_finished()
	var/ops_alive = 0
	for(var/datum/mind/nuke in syndicates)
		if(!istype(nuke.current,/mob/living/carbon))
			continue
		if(istype(nuke.current,/mob/living/carbon/brain))
			continue
		if(nuke.current.stat==2)
			continue
		if(nuke.current.stat==1)
			if(nuke.current.health < 0)
				nuke.current << "<font size='4'>The Syndicate is upset with your performance and have left you to the mercy of Nanotrasen.</font>"
				nuke.current.stat = 2
			continue
		ops_alive++

	if (ops_alive)
		if(!time_checked) time_checked = world.time
		if(world.time > time_checked + 500 && (ops_made < max_ops))
			time_checked = world.time
			make_more_mages()
	else
		make_more_mages()
	return ..()

/datum/game_mode/nuclear/raginnukeops/proc/make_more_mages()

	if(making_op)
		return 0
	if(ops_made >= max_ops)
		return 0
	making_op = 1
	ops_made++
	var/list/mob/dead/observer/candidates = list()
	var/mob/dead/observer/theghost = null
	spawn(rand(100, 200))
		message_admins("Syndicate is still pissed, sending another op - [max_ops - ops_made] left.")
		for(var/mob/dead/observer/G in player_list)
			if(G.client && !G.client.holder && !G.client.is_afk() && G.client.prefs.be_special & BE_WIZARD)
				if(!jobban_isbanned(G, "wizard") && !jobban_isbanned(G, "Syndicate"))
					candidates += G
		if(!candidates.len)
			message_admins("No applicable ghosts for the next ragin' nuke ops, asking ghosts instead.")
			var/time_passed = world.time
			for(var/mob/dead/observer/G in player_list)
				if(!jobban_isbanned(G, "Syndicate"))
					spawn(0)
						switch(alert(G, "Do you wish to be considered for the position of a nuclear strike team?","Please answer in 30 seconds!","Yes","No"))
							if("Yes")
								if((world.time-time_passed)>300)//If more than 30 game seconds passed.
									continue
								candidates += G
							if("No")
								continue

			sleep(300)
		if(!candidates.len)
			message_admins("This is awkward, sleeping until another op check...")
			making_op = 0
			ops_made--
			return
		else
			shuffle(candidates)
			for(var/mob/i in candidates)
				if(!i || !i.client) continue //Dont bother removing them from the list since we only grab one wizard

				theghost = i
				break

		if(theghost)
			var/mob/living/carbon/human/new_character= makeBody(theghost)
			forge_syndicate_objectives(new_character.mind)
			greet_syndicate(new_character.mind)
			equip_syndicate(new_character)
			making_op = 0
			return 1


/datum/game_mode/nuclear/raginnukeops/proc/makeBody(var/mob/dead/observer/G_found) // Uses stripped down and bastardized code from respawn character
	if(!G_found || !G_found.key)	return

	//First we spawn a dude.
	var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

	G_found.client.prefs.copy_to(new_character)
	ready_dna(new_character)
	new_character.key = G_found.key

	return new_character
