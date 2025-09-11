#define VISIBLE 0
#define INVISIBLE 26 //Don't know why it's this number but through trial and error it is

/obj/item/phantom_ear
	name = "Phantom Ear"
	desc = "A spectral fascimile of an ear."
	var/chat_icon = 'icons/Phantom_Ear_Icon.dmi'
	icon = 'icons/roguetown/misc/phantomear.dmi'
	icon_state = "ear_ring"
	invisibility = INVISIBLE
	w_class = WEIGHT_CLASS_TINY
	var/hear_radius = 2
	var/mob/living/carbon/human/linked_human = null

/obj/item/phantom_ear/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_RUNECHAT_HIDDEN, TRAIT_GENERIC)
	become_hearing_sensitive()

/obj/item/phantom_ear/proc/setup(user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		linked_human = H

/obj/item/phantom_ear/Destroy()
	lose_hearing_sensitivity()
	if(linked_human)
		linked_human.add_stress(/datum/stressevent/ear_crushed)
		linked_human.emote("painscream")
		linked_human.Immobilize(10)
		linked_human.Knockdown(10)
		linked_human.apply_damage(15, BRUTE, "head")
	return ..()

/obj/item/phantom_ear/attack_hand(mob/user)
	.=..()
	user.visible_message(span_warning("[user] thrusts [user.p_their()] hand into the air and clenches tightly, as a pale ear materializes in its grasp!"))
	playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, FALSE, -1)
	name = "Phantom Ear"
	desc = "A spectral fascimile of an ear that squirms in your hand."
	icon_state = "round_round_ear"
	hear_radius = 0
	update_appearance()
	invisibility = VISIBLE
	if(linked_human)
		to_chat(linked_human, span_warning("I feel a strange tightness in the side of my head."))

/obj/item/phantom_ear/attack_self(mob/user, params)
	user.visible_message(span_boldwarning("[user] crushed the [src] in [user.p_their()] hand!"))
	playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
	if(linked_human)
		to_chat(linked_human, span_boldwarning("I feel a splitting pain in the side of my head, my phantom ear has been crushed!"))
	qdel(src)

/obj/item/phantom_ear/dropped(mob/user, silent, drop_source)
	if(QDELETED(src))
		return
	..()
	if(drop_source == "dropped")
		src.visible_message(span_warning("[user] drops the [src], and it shatters!"))
		playsound(src, 'sound/magic/glass.ogg', 100, FALSE, -1)
		if(linked_human)
			to_chat(linked_human, span_boldwarning("I feel a hundred needles pierce the side of my head, my phantom ear has been shattered!"))
		qdel(src)

/obj/item/phantom_ear/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	src.visible_message(span_warning("The [src] shatters against the [hit_atom]!"))
	playsound(src, 'sound/magic/glass.ogg', 100, FALSE, -1)
	if(linked_human)
		to_chat(linked_human, span_boldwarning("I feel a hundred needles pierce the side of my head, my phantom ear has been shattered!"))
	qdel(src)

/obj/item/phantom_ear/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	if(speaker == src)
		return
	if(get_dist(speaker.loc, src.loc)>hear_radius)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	if(message && linked_human)
		var/icon_html = icon2html(chat_icon, world, "sparkly_ear_icon")
		to_chat(linked_human, "[icon_html] [message]")
		if(!H.stat && H.STAPER >= 13 && H != linked_human)
			if(prob(20))
				to_chat(H, span_warning("We're [invisibility==VISIBLE ? "still" : ""] not alone, the walls [invisibility==VISIBLE ? "still" : ""] have ears..."))
				name="Ghostly Aura"
				desc="You feel a strange presence watching you..."
				update_appearance()
				invisibility = VISIBLE

#undef VISIBLE
#undef INVISIBLE
