/datum/emote/living/simple_animal
	mob_type_allowed_typecache = list(/mob/living/simple_animal)

/datum/emote/living/simple_animal/dog()
	mob_type_allowed_typecache = list(/mob/living/simple_animal/pet/dog)

/datum/emote/living/simple_animal/dog/bark
	key = "bark"
	key_third_person = "barks"
	message = "ла%(ет,ют)%"
	message_postfix = " на %t!"
	message_param = EMOTE_PARAM_USE_POSTFIX
	sound = list(
		'sound/creatures/dog_bark1.ogg',
		'sound/creatures/dog_bark2.ogg'
	)

/datum/emote/living/simple_animal/dog/growl
	key = "bark"
	key_third_person = "barks"
	message = "ла%(ет,ют)%"
	message_postfix = " на %t!"
	message_param = EMOTE_PARAM_USE_POSTFIX
	sound = list(
		'sound/creatures/dog_bark1.ogg',
		'sound/creatures/dog_bark2.ogg'
	)
