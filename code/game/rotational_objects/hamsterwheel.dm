/obj/structure/hamsterwheel
	name = "hamster wheel"

	icon = 'icons/roguetown/misc/waterwheel.dmi'
	icon_state = "1"
	desc = "A wheel used to harness the rotational energy of running."

	layer = 5
	stress_generator = TRUE
	rotation_structure = TRUE
	buckle_lying = FALSE
	can_buckle = TRUE
	appearance_flags = PIXEL_SCALE

/obj/structure/hamsterwheel/LateInitialize()
	. = ..()
	set_stress_generation(612)
	//START_PROCESSING(SSobj, src)

/obj/structure/fluff/millstone/Destroy()
	//STOP_PROCESSING(SSobj, src)
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.visible_message(span_danger("[buckled_mob] is thrown from \the [src]!"))
			to_chat(buckled_mob, span_userdanger("You are thrown from \the [src]!"))
			buckled_mob.Knockdown(60)
	. = ..()

/obj/structure/hamsterwheel/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(!in_range(user, src) || user.stat != CONSCIOUS || !iscarbon(M))
		return FALSE
	if (user != M)
		M.visible_message(span_danger("[user] attempts to shove [M] into \the [src]!"))
	if(do_after(user, (user == M ? 0 : 5 SECONDS), M))
		if(buckle_mob(M))
			if(user == M)
				to_chat(M, span_notice("I climb into \the [src]."))
			else
				to_chat(M, span_userdanger("[user] shoves me into \the [src]!"))
			playsound(user.loc, 'sound/foley/industrial/loadin.ogg', 50, 1, -1)
			if (rotation_direction)
				user.setDir(rotation_direction)
			return TRUE
	if (user != M)
		user.visible_message(span_danger("[user] fails to shove [M] into \the [src]!</span>"))
	else
		to_chat(user, span_notice("I fail to climb into \the [src]."))
	return FALSE


/obj/structure/hamsterwheel/relaymove(mob/user, direction)
	to_chat(user, span_warning("I'm moving [direction]."))
	if(direction == EAST||direction == WEST)
		if (direction != rotation_direction)
			to_chat(user, span_warning("Changing rotation direction to [direction]."))
			user.setDir(direction)
			set_rotational_direction_and_speed(direction, (user.m_intent == MOVE_INTENT_RUN ? 12 : 8))

/obj/structure/hamsterwheel/post_buckle_mob(mob/living/M)
	if(has_buckled_mobs())
		M.set_mob_offsets("bed_buckle", _x = 0, _y = 0)

/obj/structure/hamsterwheel/post_unbuckle_mob(mob/living/M)
	M.reset_offsets("bed_buckle")
	set_rotations_per_minute(0)

/obj/structure/hamsterwheel/proc/calculate_next_frame(var/westing)
	if (westing)
		return (icon_state == "4" ? "1" : num2text(text2num(icon_state)+1))
	else
		return (icon_state == "1" ? "4" : num2text(text2num(icon_state)-1))

/obj/structure/hamsterwheel/update_animation_effect()
	visible_message("Animation update is called")
	if(!rotation_network || rotation_network?.overstressed || !rotations_per_minute)
		visible_message("Animation update fails")
		animate(src, icon_state = "1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 4)
	if(rotation_direction == WEST)
		visible_message("Rotating west update is called by [src].")
		animate(src, icon_state = calculate_next_frame(1), time = frame_stage, loop=-1)
		animate(icon_state = calculate_next_frame(1), time = frame_stage)
		animate(icon_state = calculate_next_frame(1), time = frame_stage)
		animate(icon_state = calculate_next_frame(1), time = frame_stage)
		//src.icon_state = (icon_state == "4" ? "1" : num2text(text2num(icon_state)+1))
		//animate(src, icon_state = (icon_state == "4" ? "1" : num2text(text2num(icon_state)+1)))
	else if (rotation_direction == EAST)
		visible_message("Rotating east update is called by [src].")
		animate(src, icon_state = calculate_next_frame(0), time = frame_stage, loop=-1)
		animate(icon_state = calculate_next_frame(0), time = frame_stage)
		animate(icon_state = calculate_next_frame(0), time = frame_stage)
		animate(icon_state = calculate_next_frame(0), time = frame_stage)
		//icon_state = (icon_state == "1" ? "4" : num2text(text2num(icon_state)-1))
		//animate(src, icon_state = (icon_state == "1" ? "4" : num2text(text2num(icon_state)-1)))
	else
		visible_message("Fuck oh, should never return this.")
		//visible_message("On cooldown: [world.time<turn_cooldown]. Rotation direction was [rotation_direction], East=4, West=8. Iconstate is [icon_state], West is increasing, East is decreasing. Speed was [turn_delay]. ")

/obj/structure/hamsterwheel/set_rotations_per_minute (speed)
	. = ..()
	/*
	if (!rotations_per_minute)
		update_animation_effect()
	*/

/obj/structure/hamsterwheel/process()
	if(rotations_per_minute && !rotation_network.overstressed)
		visible_message("Processing")
	else
	 visible_message("Not processing")
