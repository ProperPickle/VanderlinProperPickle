/obj/item/phantom_ear
	name = "Phantom Ear"
	desc = "An invisible phantom ear that you should be able to see."
	var/chat_icon = 'icons/Phantom_Ear_Icon.dmi'
	//icon_state = "scomm1"
	density = FALSE
	var/mob/living/carbon/human/linked_human = null
	/*
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)
	anchored = TRUE
	var/next_decree = 0
	var/listening = TRUE
	var/speaking = TRUE
	var/dictating = FALSE
	*/

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
	return ..()

/obj/item/phantom_ear/attack_self(mob/user, params)
	user.visible_message("<span class='warning'>[user] crushed the [src] in [user.p_their()] hand!</span>")
	playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
	if(linked_human)
		to_chat(linked_human, span_boldwarning("I feel a splitting pain in the side of my head, my phantom ear has been crushed!"))
		linked_human.add_stress(/datum/stressevent/ear_crushed)
		linked_human.emote("painscream")
	linked_human = null
	qdel(src)

/obj/item/phantom_ear/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	if(speaker == src)
		return
	if(get_dist(speaker.loc, loc)>2)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	/*
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	*/
	if(message && linked_human)
		var/icon_html = icon2html(chat_icon, world, "default")
		to_chat(linked_human, "[icon_html] [message]")
		if(!H.stat && H.STAPER >= 13)
			if(prob(20))
				to_chat(H, span_warning("We're not alone, the walls have ears..."))
