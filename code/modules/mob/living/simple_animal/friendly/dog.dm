//Dogs.

/mob/living/simple_animal/pet/dog
	name = "dog"
	ru_names = list(
		NOMINATIVE = "собака",
		GENITIVE = "собаки",
		DATIVE = "собаке",
		ACCUSATIVE = "собаку",
		INSTRUMENTAL = "собакой",
		PREPOSITIONAL = "собаке"
	)
	icon_state = "blackdog"
	icon_living = "blackdog"
	icon_dead = "blackdog_dead"
	var/icon_sit = "blackdog_sit"
	icon_resting = "blackdog_rest"
	response_help  = "гладит"
	response_disarm = "толкает"
	response_harm   = "пинает"
	speak = list("ТЯФ!", "Гав!", "Гаф!", "Ааууууу!")
	speak_emote = list("лает", "гавкает")
	emote_hear = list("лает!", "гавкает!", "тяфкает.", "дышит, высунув язык.")
	emote_see = list("трясёт головой.", "гоняется за своим хвостом.", "дрожит.")
	tts_seed = "Stetmann"
	faction = list("neutral")
	maxHealth = 50
	health = 50
	melee_damage_type = STAMINA
	melee_damage_lower = 6
	melee_damage_upper = 10
	attacktext = "кусает"
	nightvision = 5
	speak_chance = 1
	turns_per_move = 10
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	mob_size = MOB_SIZE_SMALL
	gold_core_spawnable = FRIENDLY_SPAWN
	hud_type = /datum/hud/corgi
	var/bark_sound = list('sound/creatures/dog_bark1.ogg','sound/creatures/dog_bark2.ogg') //Used in emote.
	var/bark_emote = list("ла%(ет,ют)%.", "гавка%(ет,ют)%.")	// used in emote.
	var/growl_sound = list('sound/creatures/dog_grawl1.ogg','sound/creatures/dog_grawl2.ogg') //Used in emote.
	var/yelp_sound = 'sound/creatures/dog_yelp.ogg' //Used on death.
	var/last_eaten = 0
	var/had_fashion
	///Currently worn item on the head slot
	var/obj/item/inventory_head = null
	///Currently worn item on the back slot
	var/obj/item/inventory_back = null
	///Currently wotn item oh the mask slot
	var/obj/item/inventory_mask = null
	///Item slots that are available for this dog to equip stuff into
	var/list/strippable_inventory_slots = list()
	footstep_type = FOOTSTEP_MOB_CLAW
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/dog = 4)
	collar_type = "dog"
	ai_controller = /datum/ai_controller/dog
	var/sitting = FALSE

/mob/living/simple_animal/pet/dog/verb/sit()
	set name = "Сесть"
	set category = "IC"

	if(resting)
		set_resting(FALSE)
		return

	sitting = TRUE
	set_resting(TRUE)

/mob/living/simple_animal/pet/dog/on_standing_up()
	sitting = FALSE
	. = ..()

/mob/living/simple_animal/pet/dog/update_icons()
	if(stat == DEAD)
		icon_state = icon_dead
		regenerate_icons()
		return
	if(sitting)
		icon_state = icon_sit
		if(collar_type)
			collar_type = "[initial(collar_type)]_[icon_sit]"
	else if(resting || body_position == LYING_DOWN)
		icon_state = icon_resting
		if(collar_type)
			collar_type = "[initial(collar_type)]_rest"
	else
		icon_state = icon_living
	regenerate_icons()

/mob/living/simple_animal/pet/dog/verb/chasetail()
	set name = "Погоняться за хвостом"
	set desc = "Какая милота!"
	set category = "Dog"

	visible_message("[src] [pick("крутится", "гоня%(ет,ют)%ся за своим хвостом")].", "[pick("Вы крутитесь", "Вы гоняетесь за своим хвостом")].")
	spin(20, 1)

//Start of Dog Emotions!!!

/mob/living/simple_animal/pet/dog/verb/growl()
	set name = "Рычать"
	set category = "Эмоции"

	playsound(src, pick(growl_sound), 30)
	visible_message("[src] рыч%(ит,ат)%.", "Вы рычите.")

/mob/living/simple_animal/pet/dog/verb/bark()
	set name = "Лаять"
	set category = "Эмоции"

	playsound(src, bark_sound, 30)
	visible_message("[src] [pick(bark_emote)].", "[pick("Вы лаете", "Вы гавкаете")].")

/mob/living/simple_animal/pet/dog/verb/head_shake()
	set name = "Трясти головой"
	set category = "Эмоции"

	visible_message("[src] [pick("тряс%(ёт,ут)% головой", "встряхивает голову")].", "[pick("Вы трясёте головой", "Вы встряхиваете голову")].")

/mob/living/simple_animal/pet/dog/verb/itch()
	set name = "Гонять блох"
	set category = "Эмоции"

	visible_message("[src] [pick("чешется", "гоняет блох")]!", "[pick("Вы чешетесь", "Вы гоняете блох")]!")

// End of dog emotions!!!

/mob/living/simple_animal/pet/dog/death(gibbed)
	// Only execute the below if we successfully died
	. = ..(gibbed)
	if(!.)
		return
	playsound(src, yelp_sound, 75, TRUE)

/mob/living/simple_animal/pet/dog/click_alt(mob/user)
	. = ..()
	return CLICK_ACTION_SUCCESS

/mob/living/simple_animal/pet/dog/attack_hand(mob/living/carbon/human/M)
	. = ..()
	switch(M.a_intent)
		if(INTENT_HELP)
			wuv(1, M)
		if(INTENT_HARM)
			wuv(-1, M)

/mob/living/simple_animal/pet/dog/proc/wuv(change, mob/M)
	if(change)
		if(change > 0)
			if(M && stat != DEAD) // Added check to see if this mob (the corgi) is dead to fix issue 2454
				new /obj/effect/temp_visual/heart(loc)
				custom_emote(EMOTE_VISIBLE, "радостно тявка%(ет,ют)%!")
		else
			if(M && stat != DEAD) // Same check here, even though emote checks it as well (poor form to check it only in the help case)
				custom_emote(EMOTE_VISIBLE, "рыч%(ит,ат)%!")

/mob/living/simple_animal/pet/dog/proc/place_on_head(obj/item/item_to_add, mob/user)
	return

/mob/living/simple_animal/pet/dog/proc/update_dog_fluff()
	return

///Pugs

/mob/living/simple_animal/pet/dog/pug
	name = "\improper pug"
	real_name = "мопс"
	desc = "Это мопс, маленька собачка с тупой мордой, буквально и фигурально."
	ru_names = list(
		NOMINATIVE = "мопс",
		GENITIVE = "мопса",
		DATIVE = "мопсу",
		ACCUSATIVE = "мопса",
		INSTRUMENTAL = "мопсом",
		PREPOSITIONAL = "мопсе"
	)
	icon = 'icons/mob/pets.dmi'
	icon_state = "pug"
	icon_living = "pug"
	icon_dead = "pug_dead"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/pug = 3)
	collar_type = "pug"
	tts_seed = "Kleiner"
	holder_type = /obj/item/holder/pug
	maxHealth = 30
	health = 30

/mob/living/simple_animal/pet/dog/pug/handle_automated_movement()
	. = ..()
	if(!resting && !buckled)
		if(prob(1))
			custom_emote(EMOTE_VISIBLE, pick("гоня%(ет,ют)%ся за своим хвостом."))
			spawn(0)
				for(var/i in list(1, 2, 4, 8, 4, 2, 1, 2, 4, 8, 4, 2, 1, 2, 4, 8, 4, 2))
					dir = i
					sleep(1)

/mob/living/simple_animal/pet/dog/bullterrier
	name = "\improper bullterrier"
	real_name = "бультерьер"
	desc = "Кого-то его мордочка напоминает..."
	ru_names = list(
		NOMINATIVE = "бультерьер",
		GENITIVE = "бультерьера",
		DATIVE = "бультерьеру",
		ACCUSATIVE = "бультерьера",
		INSTRUMENTAL = "бультерьером",
		PREPOSITIONAL = "бультерьере"
	)
	icon = 'icons/mob/pets.dmi'
	icon_state = "bullterrier"
	icon_living = "bullterrier"
	icon_resting = "bullterrier"
	icon_sit = "bullterrier"
	icon_dead = "bullterrier_dead"
	//tts_seed = "Kleiner"
	holder_type = /obj/item/holder/bullterrier

/mob/living/simple_animal/pet/dog/tamaskan
	name = "\improper tamaskan"
	real_name = "тамаскан"
	desc = "Хорошая семейная собака. Уживается с другими собаками и ассистентами."
	ru_names = list(
		NOMINATIVE = "тамаскан",
		GENITIVE = "тамаскана",
		DATIVE = "тамаскану",
		ACCUSATIVE = "тамаскана",
		INSTRUMENTAL = "тамасканом",
		PREPOSITIONAL = "тамаскане"
	)
	icon = 'icons/mob/pets.dmi'
	icon_state = "tamaskan"
	icon_living = "tamaskan"
	icon_dead = "tamaskan_dead"
	//tts_seed = "Kleiner"
	holder_type = /obj/item/holder/bullterrier

/mob/living/simple_animal/pet/dog/german
	name = "\improper german"
	real_name = "немецкая овчарка"
	desc = "Немецкая овчарка с помесью двортерьера. Судя по крупу - явно не породистый."
	ru_names = list(
		NOMINATIVE = "немецкая овчарка",
		GENITIVE = "немецкой овчаркой",
		DATIVE = "немецкой овчарке",
		ACCUSATIVE = "немецкую овчарку",
		INSTRUMENTAL = "немецкой овчаркой",
		PREPOSITIONAL = "немецкой овчарке"
	)
	icon = 'icons/mob/pets.dmi'
	icon_state = "german"
	icon_living = "german"
	icon_dead = "german_dead"
	//tts_seed = "Kleiner"

/mob/living/simple_animal/pet/dog/brittany
	name = "\improper brittany"
	real_name = "бретонский эпаньоль"
	desc = "Старая порода, которую любят аристократы."
	ru_names = list(
		NOMINATIVE = "бретонский эпаньоль",
		GENITIVE = "бретонского эпаньола",
		DATIVE = "бретонскому эпаньолу",
		ACCUSATIVE = "бретонского эпаньола",
		INSTRUMENTAL = "бретонским эпаньолом",
		PREPOSITIONAL = "бретонском эпаньоле"
	)
	icon = 'icons/mob/pets.dmi'
	icon_state = "brittany"
	icon_living = "brittany"
	icon_dead = "brittany_dead"
