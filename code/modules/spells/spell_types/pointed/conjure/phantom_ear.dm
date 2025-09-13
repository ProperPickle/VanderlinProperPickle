/datum/action/cooldown/spell/conjure/phantom_ear
	name = "Summon Phantom Ear"
	desc = "Creates a magical ear to listen in on distant sounds."
	button_icon_state = "phantomear"
	self_cast_possible = TRUE

	point_cost = 2

	sound = 'sound/magic/whiteflame.ogg'

	charge_required = FALSE
	cooldown_time = 2 MINUTES
	spell_cost = 60
	spell_flags = SPELL_RITUOS
	invocation = "Lend me thine ear."
	invocation_type = INVOCATION_WHISPER

	summon_type = list(/obj/item/phantom_ear)
	summon_radius = 0
	summon_lifespan = 0

/datum/action/cooldown/spell/conjure/phantom_ear/post_summon(atom/summoned_object)
	var first = TRUE
	for(var/obj/item/phantom_ear/E in world)
		if(E.linked_living?.resolve() == owner)
			to_chat(owner, span_notice("You close one ear to open another."))
			qdel(E)
			first = FALSE
			continue
	if(first)
		to_chat(owner, span_notice("You've conjured a phantom ear. You can hear through it as if you were there."))
	if(istype(summoned_object, /obj/item/phantom_ear))
		var/obj/item/phantom_ear/ear = summoned_object
		ear.setup(owner)
	return
