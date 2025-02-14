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

/obj/structure/hamsterwheel/LateInitialize()
	. = ..()
	/*
	var/turf/open/water/river/water = get_turf(src)
	if(!istype(water))
		return
	if(water.water_volume)
		set_rotational_direction_and_speed(water.dir, 8)
		set_stress_generation(1024)
	*/

/obj/structure/hamsterwheel/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(!in_range(user, src) || user.stat != CONSCIOUS || !iscarbon(M))
		return FALSE
	M.visible_message(span_danger("[user] attempts to shove [M] into \the [src]!"))
	if(do_after(user, (user == M ? 0 : 5 SECONDS), M))
		if(buckle_mob(M))
			if(user == M)
				to_chat(M, span_notice("I climb into \the [src]."))
			else
				to_chat(M, span_userdanger("[user] shoves me into \the [src]!"))
			playsound(user.loc, 'sound/foley/industrial/loadin.ogg', 50, 1, -1)
			return TRUE
	if (user != M)
		user.visible_message(span_danger("[user] fails to shove [M] into \the [src]!</span>"))
	else
		to_chat(user, span_notice("I fail to climb into \the [src]."))
	return FALSE

/obj/structure/hamsterwheel/relaymove(mob/user, direct/runDir)
	to_chat(user, span_warning("I'm moving [runDir]."))

/obj/structure/hamsterwheel/post_buckle_mob(mob/living/M)
	if(has_buckled_mobs())
		START_PROCESSING(SSobj, src)
		M.set_mob_offsets("bed_buckle", _x = 0, _y = 10)

/obj/structure/hamsterwheel/post_unbuckle_mob(mob/living/M)
	STOP_PROCESSING(SSobj, src)
	M.reset_offsets("bed_buckle")

/*
/obj/structure/hamsterwheel/update_animation_effect()
	if(!rotation_network || rotation_network?.overstressed || !rotations_per_minute)
		animate(src, icon_state = "1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 4)
	if(rotation_direction == WEST)
		animate(src, icon_state = "1", time = frame_stage, loop=-1)
		animate(icon_state = "2", time = frame_stage)
		animate(icon_state = "3", time = frame_stage)
		animate(icon_state = "4", time = frame_stage)
	else
		animate(src, icon_state = "4", time = frame_stage, loop=-1)
		animate(icon_state = "3", time = frame_stage)
		animate(icon_state = "2", time = frame_stage)
		animate(icon_state = "1", time = frame_stage)

/obj/structure/hamsterwheel/set_rotations_per_minute(speed)
	. = ..()
*/
