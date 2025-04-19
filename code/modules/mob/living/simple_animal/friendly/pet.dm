/mob/living/simple_animal/pet
	icon = 'icons/mob/pets.dmi'
	mob_size = MOB_SIZE_SMALL
	blood_volume = BLOOD_VOLUME_NORMAL
	can_collar = TRUE
	attacktext = "кусает"
	attack_sound = 'sound/weapons/bite.ogg'


/mob/living/simple_animal/pet/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/newspaper))
		add_fingerprint(user)
		if(stat != CONSCIOUS)
			to_chat(user, span_warning("[src] плохо себя чувствует."))
			return ATTACK_CHAIN_PROCEED
		user.do_attack_animation(src)
		playsound(loc, 'sound/items/handling/paper_drop.ogg', 100, TRUE)
		user.visible_message(
			span_notice("[user] хлопа[pluralize_ru(user.gender,"ет", "ют")] [name] по носу свёрнутой газетой."),
			span_notice("Вы хлопаете [name] по носу свёрнутой газетой."),
		)
		spin(12, 1)
		return ATTACK_CHAIN_PROCEED

	return ..()

