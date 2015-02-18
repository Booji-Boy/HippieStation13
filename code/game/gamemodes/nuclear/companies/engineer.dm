/mob/living/silicon/robot/syndicate/special
	icon = 'icons/mob/human.dmi'
	icon_state = "IPC_m_s"

	New()
		..()
		icon = 'icons/mob/human.dmi'
		icon_state = "IPC_m_s"

	Life()
		if(linkedmob.stat)
			linkedmob.client = src
			stunned = 10000
			explosion(src, -1, 0, 2, 3, 0)	//This might be a bit much, dono will have to see.
		..()
/mob/living/silicon/robot/syndicate/special/verb/Return(mob/living/carbon/human/user as mob)
	src.stat = 2

/mob/living/
	var/mob/living/linkedmob


/obj/item/device/pocketcontrol
	name = "Bot Control"
	desc = "Lets you create and control bots."
	var/botsleft = 2
	var/botmade = 0
	var/mob/living/silicon/robot/syndicate/special/currentbot = null

	New()
		icon = loc.icon
		icon_state = loc.icon_state

	attack_self(mob/living/carbon/human/user as mob)
		if(botmade)
			if(currentbot)
				usr << "\blue You take control of the IPC. Ending control will destroy it."
				currentbot.client = user.client
			else
				botmade = 0
				user << "Connection to the IPC has been lost."
		else
			if(botsleft)
				var/mob/living/silicon/robot/syndicate/special/bot = new/mob/living/silicon/robot/syndicate/special
				user << "\blue You create an IPC. Click again to take it over."
				user.linkedmob = bot
				bot.linkedmob = user
				bot.loc = user.loc
				currentbot = bot
				botmade = 1
				botsleft--
			else
				user << "You have run out of bots to create!"