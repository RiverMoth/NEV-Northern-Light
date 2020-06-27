/obj/structure/dispenser
	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten phoron tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	w_class = ITEM_SIZE_HUGE
	layer = BELOW_OBJ_LAYER
	var/oxygentanks = 10
	var/phorontanks = 10
	var/list/oxytanks = list()	//sorry for the similar var names
	var/list/platanks = list()


/obj/structure/dispenser/oxygen
	phorontanks = 0

/obj/structure/dispenser/phoron
	oxygentanks = 0


/obj/structure/dispenser/Initialize()
	. = ..()
	update_icon()


/obj/structure/dispenser/update_icon()
	overlays.Cut()
	switch(oxygentanks)
		if(1 to 3)	overlays += "oxygen-[oxygentanks]"
		if(4 to INFINITY) overlays += "oxygen-4"
	switch(phorontanks)
		if(1 to 4)	overlays += "phoron-[phorontanks]"
		if(5 to INFINITY) overlays += "phoron-5"

/obj/structure/dispenser/attack_ai(mob/user)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = "[src]<br><br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Phoron tanks: [phorontanks] - [phorontanks ? "<A href='?src=\ref[src];phoron=1'>Dispense</A>" : "empty"]"
	user << browse(dat, "window=dispenser")
	onclose(user, "dispenser")


/obj/structure/dispenser/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/tank/oxygen) || istype(I, /obj/item/weapon/tank/air) || istype(I, /obj/item/weapon/tank/anesthetic))
		if(oxygentanks < 10)
			user.drop_item()
			I.forceMove(src)
			oxytanks.Add(I)
			oxygentanks++
			to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
			if(oxygentanks < 5)
				update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] is full."))
		updateUsrDialog()
		return
	if(istype(I, /obj/item/weapon/tank/phoron))
		if(phorontanks < 10)
			user.drop_item()
			I.forceMove(src)
			platanks.Add(I)
			phorontanks++
			to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
			if(phorontanks < 6)
				update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] is full."))
		updateUsrDialog()
		return
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
			if(anchored)
				to_chat(user, SPAN_NOTICE("You lean down and unwrench [src]."))
				anchored = FALSE
			else
				to_chat(user, SPAN_NOTICE("You wrench [src] into place."))
				anchored = TRUE
			return

/obj/structure/dispenser/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)

	var/obj/item/weapon/tank/tank
	if(href_list["oxygen"] && oxygentanks > 0)
		if(oxytanks.len)
			tank = oxytanks[oxytanks.len]	// Last stored tank is always the first one to be dispensed
			oxytanks.Remove(tank)
		else
			tank = new /obj/item/weapon/tank/oxygen(loc)
		oxygentanks--
	if(href_list["phoron"] && phorontanks > 0)
		if(platanks.len)
			tank = platanks[platanks.len]
			platanks.Remove(tank)
		else
			tank = new /obj/item/weapon/tank/phoron(loc)
		phorontanks--

	if(tank)
		tank.forceMove(drop_location())
		to_chat(usr, SPAN_NOTICE("You take [tank] out of [src]."))
		update_icon()

	playsound(usr.loc, 'sound/machines/Custom_extout.ogg', 100, 1)
	updateUsrDialog()
