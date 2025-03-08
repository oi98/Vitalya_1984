//Foxxy
/mob/living/simple_animal/pet/dog/fox //
	name = "fox"
	desc = "Это лиса. Интересно, как она говорит?"
	ru_names = list(
		NOMINATIVE = "Лиса",
		GENITIVE = "Лисы",
		DATIVE = "Лисе",
		ACCUSATIVE = "Лису",
		INSTRUMENTAL = "Лисой",
		PREPOSITIONAL = "Лисе"
	)
	gender = FEMALE
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	icon_resting = "fox_rest"
	speak = list(" Тяф-тяф","Фыр-фыр-фр-фр-фыыр","ки-кихи-хихи!","А-у-у-у-у!","Фыр-рыр")
	speak_emote = list("фырчит", "тяфкает")
	emote_hear = list("воет","гавкает")
	emote_see = list("трясёт головой", "вздрагивает")
	tts_seed = "Barney"
	yelp_sound = 'sound/creatures/fox_yelp.ogg' //Used on death.
	speak_chance = 1
	turns_per_move = 5
	nightvision = 6
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat = 3)
	response_help = "гладит"
	response_disarm = "аккуратно отодвигает в сторону"
	response_harm = "пинает"
	holder_type = /obj/item/holder/fox

/mob/living/simple_animal/pet/dog/fox/forest
	name = "forest fox"
	desc = "Лесная дикая лисица. Может укусить."
	ru_names = list(
		NOMINATIVE = "Лесная лиса",
		GENITIVE = "Лесной лисы",
		DATIVE = "Лесной лисе",
		ACCUSATIVE = "Лесную лису",
		INSTRUMENTAL = "Лесной лисой",
		PREPOSITIONAL = "Лесной лисе"
	)
	icon_state = "fox_forest"
	icon_living = "fox_forest"
	icon_dead = "fox_forest_dead"
	icon_resting = "fox_forest_rest"
	melee_damage_type = BRUTE
	melee_damage_lower = 6
	melee_damage_upper = 12


/mob/living/simple_animal/pet/dog/fox/forest/winter
	weather_immunities = list(TRAIT_SNOWSTORM_IMMUNE)

/mob/living/simple_animal/pet/dog/fox/forest/winter/ComponentInitialize()
	AddComponent( \
		/datum/component/animal_temperature, \
		minbodytemp = 0, \
	)

//Captain fox
/mob/living/simple_animal/pet/dog/fox/Renault
	name = "Renault"
	desc = "Ренальд, верный лис капитана. Интересно, а он как говорит?"
	ru_names = list(
		NOMINATIVE = "Ренальд",
		GENITIVE = "Ренальда",
		DATIVE = "Ренальду",
		ACCUSATIVE = "Ренальда",
		INSTRUMENTAL = "Ренальдом",
		PREPOSITIONAL = "Ренальде"
	)
	gender = MALE
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN

//Syndi fox
/mob/living/simple_animal/pet/dog/fox/Syndifox
	name = "Syndifox"
	desc = "Синди-Лис, самый уважаемый маскот Синдиката. Интересно, как же он говорит?"
	ru_names = list(
		NOMINATIVE = "Синди-Лис",
		GENITIVE = "Синди-Лиса",
		DATIVE = "Синди-Лису",
		ACCUSATIVE = "Синди-Лиса",
		INSTRUMENTAL = "Синди-Лисом",
		PREPOSITIONAL = "Синди-Лисе"
	)
	gender = MALE
	icon_state = "Syndifox"
	icon_living = "Syndifox"
	icon_dead = "Syndifox_dead"
	icon_resting = "Syndifox_rest"
	faction = list("syndicate")
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	melee_damage_lower = 10
	melee_damage_upper = 20

/mob/living/simple_animal/pet/dog/fox/SyndiFox/ComponentInitialize()
	AddComponent( \
		/datum/component/animal_temperature, \
		minbodytemp = 0, \
	)

/mob/living/simple_animal/pet/dog/fox/Syndifox/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_GALACTIC_COMMON)
	ADD_TRAIT(src, TRAIT_NO_BREATH, INNATE_TRAIT)


//Central Command Fox
/mob/living/simple_animal/pet/dog/fox/alisa
	name = "alisa"
	desc = "Алиса, любимый питомец любого Офицера Специальных Операций. Интересно, что она говорит?"
	ru_names = list(
		NOMINATIVE = "Алиса",
		GENITIVE = "Алисы",
		DATIVE = "Алисе",
		ACCUSATIVE = "Алису",
		INSTRUMENTAL = "Алисой",
		PREPOSITIONAL = "Алисе"
	)
	gender = FEMALE
	icon_state = "alisa"
	icon_living = "alisa"
	icon_dead = "alisa_dead"
	icon_resting = "alisa_rest"
	faction = list("nanotrasen")
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	melee_damage_lower = 10
	melee_damage_upper = 20

/mob/living/simple_animal/pet/dog/fox/alisa/ComponentInitialize()
	AddComponent( \
		/datum/component/animal_temperature, \
		minbodytemp = 0, \
	)

/mob/living/simple_animal/pet/dog/fox/alisa/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_BREATH, INNATE_TRAIT)


/mob/living/simple_animal/pet/dog/fox/fennec
	name = "fennec"
	desc = "Миниатюрная лисичка с ооочень большими ушами. Фенек, фенек, зачем тебе такие большие уши? Чтобы избегать дормитория?"
	ru_names = list(
		NOMINATIVE = "Фенек",
		GENITIVE = "Фенека",
		DATIVE = "Фенеку",
		ACCUSATIVE = "Фенека",
		INSTRUMENTAL = "Фенеком",
		PREPOSITIONAL = "Фенеке"
	)
	icon_state = "fennec"
	icon_living = "fennec"
	icon_dead = "fennec_dead"
	icon_resting = "fennec_rest"
	nightvision = 10
	holder_type = /obj/item/holder/fennec
