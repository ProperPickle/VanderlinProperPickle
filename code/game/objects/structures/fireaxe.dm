/obj/structure/fireaxecabinet
	name = "sword rack"
	desc = ""
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE
	armor = list("blunt" = 50, "slash" = 50, "stab" = 50,  "piercing" = 20, "fire" = 90, "acid" = 50)
	max_integrity = 150
	integrity_failure = 0.33
	var/locked = FALSE
	var/open = TRUE
	var/obj/item/weapon/sword/long/heirloom

/obj/structure/fireaxecabinet/Initialize()
	. = ..()
	heirloom = new /obj/item/weapon/sword/long/heirloom
	update_icon()

/obj/structure/fireaxecabinet/Destroy()
	if(heirloom)
		QDEL_NULL(heirloom)
	return ..()

/obj/structure/fireaxecabinet/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_MULTITOOL)
		toggle_lock(user)
	else if(I.tool_behaviour == TOOL_WELDER && user.used_intent.type == INTENT_HELP && !broken)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=2))
				return

	else if(open || broken)
		if(istype(I, /obj/item/weapon/sword/long/heirloom) && !heirloom)
			var/obj/item/weapon/sword/long/heirloom/F = I
			if(F.wielded)
				to_chat(user, "<span class='warning'>Unwield the [F.name] first.</span>")
				return
			if(!user.transferItemToLoc(F, src))
				return
			heirloom = F
			to_chat(user, "<span class='notice'>I place the [F.name] back in the [name].</span>")
			update_icon()
			return
		else if(!broken)
			toggle_open()
	else
		return ..()

/obj/structure/fireaxecabinet/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(broken)
				playsound(loc, 'sound/blank.ogg', 90, TRUE)
			else
				playsound(loc, 'sound/blank.ogg', 90, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/blank.ogg', 100, TRUE)

/obj/structure/fireaxecabinet/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	if(open)
		return
	. = ..()
	if(.)
		update_icon()

/obj/structure/fireaxecabinet/obj_break(damage_flag)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		update_icon()
		broken = TRUE
		playsound(src, 'sound/blank.ogg', 100, TRUE)
	..()

/obj/structure/fireaxecabinet/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(open || broken)
		if(heirloom)
			user.put_in_hands(heirloom)
			heirloom = null
			to_chat(user, "<span class='notice'>I take the sword from the [name].</span>")
			src.add_fingerprint(user)
			update_icon()
			return
	if(locked)
		to_chat(user, "<span class='warning'>The [name] won't budge!</span>")
		return
	else
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/fireaxecabinet/update_icon()
	cut_overlays()
	if(heirloom)
		add_overlay("axe")
	if(!open)

		if(locked)
			add_overlay("locked")
		else
			add_overlay("unlocked")
	else
		add_overlay("glass_raised")

/obj/structure/fireaxecabinet/proc/toggle_lock(mob/user)
	to_chat(user, "<span class='notice'>Resetting circuitry...</span>")
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	if(do_after(user, 2 SECONDS, src))
		to_chat(user, "<span class='notice'>I [locked ? "disable" : "re-enable"] the locking modules.</span>")
		locked = !locked
		update_icon()

/obj/structure/fireaxecabinet/verb/toggle_open()
	set name = "Open/Close"
	set hidden = 1
	set src in oview(1)

	if(locked)
		to_chat(usr, "<span class='warning'>The [name] won't budge!</span>")
		return
	else
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/south
	dir = SOUTH
	pixel_y = 32



/*	..................   The Drunken Saiga   ................... */
/obj/structure/innkeep_rack
	name = "the last word "
	desc = "Here, the Innkeeper keeps their final recourse to any disupte with drunken patrons."
	icon = 'icons/roguetown/misc/64x32.dmi'
	icon_state = "innrack"
	anchored = TRUE
	density = FALSE
	armor = list("blunt" = 50, "slash" = 50, "stab" = 50,  "piercing" = 20, "fire" = 90, "acid" = 50)
	max_integrity = 150
	integrity_failure = 0.33
	var/obj/item/weapon/mace/goden/shillelagh/heirloom

/obj/structure/innkeep_rack/Initialize()
	. = ..()
	heirloom = new /obj/item/weapon/mace/goden/shillelagh
	update_icon()

/obj/structure/innkeep_rack/Destroy()
	if(heirloom)
		QDEL_NULL(heirloom)
	return ..()

/obj/structure/innkeep_rack/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/mace/goden/shillelagh) && !heirloom)
		var/obj/item/weapon/mace/goden/shillelagh/F = I
		if(F.wielded)
			to_chat(user, "<span class='warning'>Unwield the [F.name] first.</span>")
			return
		if(!user.transferItemToLoc(F, src))
			return
		heirloom = F
		to_chat(user, "<span class='notice'>I place the [F.name] back in the [name].</span>")
		update_icon()
		return
	else
		return ..()

/obj/structure/innkeep_rack/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(loc, 'sound/blank.ogg', 90, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/blank.ogg', 100, TRUE)
/*
/obj/structure/innkeep_rack/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.)
		update_icon()

/obj/structure/innkeep_rack/obj_break(damage_flag)
	..()
*/
/obj/structure/innkeep_rack/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(heirloom)
		user.put_in_hands(heirloom)
		heirloom = null
		to_chat(user, "<span class='notice'>I take the club from the [name].</span>")
		src.add_fingerprint(user)
		update_icon()
		return

/obj/structure/innkeep_rack/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/innkeep_rack/update_icon()
	cut_overlays()
	if(heirloom)
		add_overlay("club")


