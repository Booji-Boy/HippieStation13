/*
				synd_mob.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/hardsuit/syndi/cardborg(synd_mob), slot_head)
				synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
				synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/skates(synd_mob), slot_shoes)
				synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(synd_mob), slot_gloves)
				synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), slot_wear_id)
				if(synd_mob.backbag == 2) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), slot_back)
				if(synd_mob.backbag == 3) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(synd_mob), slot_back)
				synd_mob.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol(synd_mob), slot_belt)
				synd_mob.equip_to_slot_or_del(new /obj/item/weapon/melee/combatknife(synd_mob), slot_r_store)
				synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)

*/



/obj/item/clothing/shoes/skates
	name = "Rollerskates"
	desc = "GOTTA GO FAST"

/obj/item/clothing/suit/space/hardsuit/syndi/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	item_state = "cardborg"
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/space/hardsuit/syndi/cardborg/ui_action_click()
	return


/obj/item/clothing/head/helmet/space/hardsuit/syndi/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	item_state = "cardborg"
