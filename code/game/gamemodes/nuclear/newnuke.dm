
var/global/list/corplist = list("Ten0", "BlastCo", "Engineering", "A.S.S.", "Syndicate")
/obj/machinery/equipmentpod
	name = "Auto-Equipper 5000"
	desc = "Get your fancy new equipment in here."
	var/mob/living/inuse = null
	var/locked = 0
/obj/machinery/equipmentpod/verb/enter(mob/user as mob)
	set category = "Object"
	set name = "Enter pod"
	set src in view(1)

	if(usr.stat || usr.restrained() || !usr.canmove)
		return

	if(inuse)
		user << "\red This pod is already in use!"
		return 0

	if(locked) return 0

	user.loc = src
	locked = 1
	inuse = user

	var/radio_freq = SYND_FREQ
	var/result = input(usr, "Please choose a corporation to join","Corporation") as null|anything in corplist
	switch(result)
		if("Ten0")
			user << "The Ten0 is a Corporation developed around stealth. By alt-clicking with your suit on, you will teleport!"
			var/mob/living/carbon/human/synd_mob = user
			var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt(synd_mob)
			R.set_frequency(radio_freq)
			synd_mob.equip_to_slot_or_del(R, slot_ears)

			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(synd_mob), slot_shoes)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(synd_mob), slot_gloves)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), slot_wear_id)
			if(synd_mob.backbag == 2) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), slot_back)
			if(synd_mob.backbag == 3) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(synd_mob), slot_back)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)

			var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(synd_mob)
			U.hidden_uplink.uplink_owner="[synd_mob.key]"
			U.hidden_uplink.uses = 20
			synd_mob.equip_to_slot_or_del(U, slot_in_backpack)

			var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(synd_mob)
			E.imp_in = synd_mob
			E.implanted = 1
			E.implanted(synd_mob)
			synd_mob.faction |= "syndicate"
			synd_mob.update_icons()


		if("BlastCo")
			user << "From the makers BlastCo comes Space Michael Bay. Rollerblade your way with explosives and a suit mounted grenade launcher!"
			var/mob/living/carbon/human/synd_mob = user
			var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt(synd_mob)
			R.set_frequency(radio_freq)
			synd_mob.equip_to_slot_or_del(R, slot_ears)

			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(synd_mob), slot_shoes)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(synd_mob), slot_gloves)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), slot_wear_id)
			if(synd_mob.backbag == 2) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), slot_back)
			if(synd_mob.backbag == 3) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(synd_mob), slot_back)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol(synd_mob), slot_belt)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/melee/combatknife(synd_mob), slot_r_store)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)

			var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(synd_mob)
			U.hidden_uplink.uplink_owner="[synd_mob.key]"
			U.hidden_uplink.uses = 20
			synd_mob.equip_to_slot_or_del(U, slot_in_backpack)

			var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(synd_mob)
			E.imp_in = synd_mob
			E.implanted = 1
			E.implanted(synd_mob)
			synd_mob.faction |= "syndicate"
			synd_mob.update_icons()

		if("Engineering")
			user << "Engineers"
			var/mob/living/carbon/human/synd_mob = user
			var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt(synd_mob)
			R.set_frequency(radio_freq)
			synd_mob.equip_to_slot_or_del(R, slot_ears)

			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(synd_mob), slot_shoes)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(synd_mob), slot_gloves)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), slot_wear_id)
			if(synd_mob.backbag == 2) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), slot_back)
			if(synd_mob.backbag == 3) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(synd_mob), slot_back)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol(synd_mob), slot_belt)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/melee/combatknife(synd_mob), slot_r_store)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)

			var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(synd_mob)
			U.hidden_uplink.uplink_owner="[synd_mob.key]"
			U.hidden_uplink.uses = 20
			synd_mob.equip_to_slot_or_del(U, slot_in_backpack)

			var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(synd_mob)
			E.imp_in = synd_mob
			E.implanted = 1
			E.implanted(synd_mob)
			synd_mob.faction |= "syndicate"
			synd_mob.update_icons()


		if("A.S.S.")
			user << "Rip and tear the station a new one, what's subtlety when you go BANGPOWBOOM!"
			var/mob/living/carbon/human/synd_mob = user
			var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt(synd_mob)
			R.set_frequency(radio_freq)
			synd_mob.equip_to_slot_or_del(R, slot_ears)

			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(synd_mob), slot_shoes)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(synd_mob), slot_gloves)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), slot_wear_id)
			if(synd_mob.backbag == 2) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), slot_back)
			if(synd_mob.backbag == 3) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(synd_mob), slot_back)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol(synd_mob), slot_belt)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/melee/combatknife(synd_mob), slot_r_store)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)

			var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(synd_mob)
			U.hidden_uplink.uplink_owner="[synd_mob.key]"
			U.hidden_uplink.uses = 20
			synd_mob.equip_to_slot_or_del(U, slot_in_backpack)

			var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(synd_mob)
			E.imp_in = synd_mob
			E.implanted = 1
			E.implanted(synd_mob)
			synd_mob.faction |= "syndicate"
			synd_mob.update_icons()


		if("Syndicate")
			user << "You suck"
			var/mob/living/carbon/human/synd_mob = user
			var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt(synd_mob)
			R.set_frequency(radio_freq)
			synd_mob.equip_to_slot_or_del(R, slot_ears)

			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(synd_mob), slot_shoes)
			synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(synd_mob), slot_gloves)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), slot_wear_id)
			if(synd_mob.backbag == 2) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), slot_back)
			if(synd_mob.backbag == 3) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(synd_mob), slot_back)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol(synd_mob), slot_belt)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/melee/combatknife(synd_mob), slot_r_store)
			synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)

			var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(synd_mob)
			U.hidden_uplink.uplink_owner="[synd_mob.key]"
			U.hidden_uplink.uses = 20
			synd_mob.equip_to_slot_or_del(U, slot_in_backpack)

			var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(synd_mob)
			E.imp_in = synd_mob
			E.implanted = 1
			E.implanted(synd_mob)
			synd_mob.faction |= "syndicate"
			synd_mob.update_icons()


	inuse.loc = src.loc
	inuse = null
	locked = 0
