//Cat
/mob/living/simple_animal/pet/cat
	name = "cat"
	desc = "КОТЕНЬКА!!"
	ru_names = list(
		NOMINATIVE = "кот",
		GENITIVE = "кота",
		DATIVE = "коту",
		ACCUSATIVE = "кота",
		INSTRUMENTAL = "котом",
		PREPOSITIONAL = "коте"
	)
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	icon_resting = "cat2_rest"
	var/icon_sit = "sit"
	gender = MALE
	speak = list("Мяу!", "Мрау!", "Мурр!", "Шшшш!")
	speak_emote = list("мурчит", "мяукает")
	emote_hear = list("мурлычет", "мяукает")
	emote_see = list("трясёт головой", "вздрагивает")
	var/meow_sound = 'sound/creatures/cat_meow.ogg'	//Used in emote.
	speak_chance = 1
	turns_per_move = 5
	nightvision = 6
	mob_size = MOB_SIZE_SMALL
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat = 3)
	response_help  = "гладит"
	response_disarm = "аккуратно отодвигает в сторону"
	response_harm   = "пинает"
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_type = "cat"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	var/eats_mice = TRUE
	footstep_type = FOOTSTEP_MOB_CLAW
	tts_seed = "Valerian"
	holder_type = /obj/item/holder/cat2
	var/sitting = FALSE

/mob/living/simple_animal/pet/cat/floppa
	name = "Big Floppa"
	desc = "Похоже он собирается совершить очередное военное преступление..."
	ru_names = list(
		NOMINATIVE = "большой Шлёпа",
		GENITIVE = "большого Шлёпы",
		DATIVE = "Большому Шлёпе",
		ACCUSATIVE = "Большого Шлёпу",
		INSTRUMENTAL = "Большим Шлёпой",
		PREPOSITIONAL = "Большом Шлёпе"
	)
	icon_state = "floppa"
	icon_living = "floppa"
	icon_dead = "floppa_dead"
	icon_resting = "floppa_rest"
	unique_pet = TRUE
	tts_seed = "Uther"
	holder_type = null

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/Runtime
	name = "Runtime"
	desc = "Кошка Главврача станции. За ней нужен глаз да глаз, всё наровит сбежать!"
	ru_names = list(
		NOMINATIVE = "Рантайм",
		GENITIVE = "Рантайма",
		DATIVE = "Рантайму",
		ACCUSATIVE = "Рантайма",
		INSTRUMENTAL = "Рантаймом",
		PREPOSITIONAL = "Рантайме"
	)
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	icon_resting = "cat_rest"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/list/family = list()
	var/list/children = list() //Actual mob instances of children
	holder_type = /obj/item/holder/cat

/mob/living/simple_animal/pet/cat/Runtime/New()
	SSpersistent_data.register(src)
	..()

/mob/living/simple_animal/pet/cat/Runtime/persistent_load()
	read_memory()
	deploy_the_cats()

/mob/living/simple_animal/pet/cat/Runtime/persistent_save()
	write_memory(FALSE)

/mob/living/simple_animal/pet/cat/Runtime/make_babies()
	var/mob/baby = ..()
	if(baby)
		children += baby
		return baby

/mob/living/simple_animal/pet/cat/Runtime/death(gibbed)
	if(can_die())
		write_memory(TRUE)
		SSpersistent_data.registered_atoms -= src // We just saved. Dont save at round end
	return ..()

/mob/living/simple_animal/pet/cat/Runtime/proc/read_memory()
	var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
	S["family"] 			>> family

	if(isnull(family))
		family = list()
	log_debug("Persistent data for [src] loaded (family: [family ? list2params(family) : "None"])")

/mob/living/simple_animal/pet/cat/Runtime/proc/write_memory(dead)
	var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
	family = list()
	if(!dead)
		for(var/mob/living/simple_animal/pet/cat/kitten/C in children)
			if(istype(C,type) || C.stat || !C.z || !C.butcher_results)
				continue
			if(C.type in family)
				family[C.type] += 1
			else
				family[C.type] = 1
	S["family"]				<< family
	log_debug("Persistent data for [src] saved (family: [family ? list2params(family) : "None"])")

/mob/living/simple_animal/pet/cat/Runtime/proc/deploy_the_cats()
	for(var/cat_type in family)
		if(family[cat_type] > 0)
			for(var/i in 1 to min(family[cat_type],100)) //Limits to about 500 cats, you wouldn't think this would be needed (BUT IT IS)
				new cat_type(loc)

/mob/living/simple_animal/pet/cat/Life()
	..()
	make_babies()


/mob/living/simple_animal/pet/cat/verb/sit()
	set name = "Сесть"
	set category = "IC"

	if(resting)
		set_resting(FALSE)
		return

	sitting = TRUE
	set_resting(TRUE)


/mob/living/simple_animal/pet/cat/post_lying_on_rest()
	if(sitting)
		custom_emote(EMOTE_VISIBLE, pick("сад%(ит,ят)%ся.", "приседа%(ет,ют)% на задних лапах.", "выгляд%(ит,ят)% настороженным%(*,и)%."))


/mob/living/simple_animal/pet/cat/on_standing_up()
	sitting = FALSE
	. = ..()


/mob/living/simple_animal/pet/cat/update_icons()
	if(stat == DEAD)
		icon_state = icon_dead
		regenerate_icons()
		return
	if(sitting)
		icon_state = "[icon_living]_[icon_sit]"
		if(collar_type)
			collar_type = "[initial(collar_type)]_[icon_sit]"
	else if(resting || body_position == LYING_DOWN)
		icon_state = icon_resting
		if(collar_type)
			collar_type = "[initial(collar_type)]_rest"
	else
		icon_state = icon_living
	regenerate_icons()


/mob/living/simple_animal/pet/cat/handle_automated_action()
	if(!stat && !buckled)
		if(prob(1))
			if(!resting)
				custom_emote(EMOTE_VISIBLE, pick("вал%(ит,ят)%ся на спинку, чтобы ему почесали живот", "виля%(ет,ют)% хвостом.", "лож%(ит,ат)%ся."))
				set_resting(TRUE, instant = TRUE)
		else if(prob(1))
			sit()
		else if(prob(1))
			if(resting)
				custom_emote(EMOTE_VISIBLE, pick("поднима%(ет,ют)%ся и мяука%(ет,ют)%.", "подскакива%(ет,ют)%.", "вста%(ет,ют)%."))
				set_resting(FALSE, instant = TRUE)
			else
				custom_emote(EMOTE_VISIBLE, pick("вылизыва%(ет,ют)% шерсть.", "подёргива%(ет,ют)% усами.", "отряхива%(ет,ют)% шерсть."))

	//MICE!
	if(eats_mice && isturf(loc) && !incapacitated())
		for(var/mob/living/simple_animal/mouse/mouse in view(1, src))
			if(!mouse.stat && Adjacent(mouse))
				custom_emote(EMOTE_VISIBLE, "броса%(ет,ют)%ся на мышь!")
				mouse.death()
				mouse.splat(user = src)
				movement_target = null
				stop_automated_movement = FALSE
				break
		for(var/obj/item/toy/cattoy/toy in view(1, src))
			if(toy.cooldown < world.time)
				custom_emote(EMOTE_VISIBLE, "подбрасыва%(ет,ют)% игрушечную мышь своей лапой!")
				toy.cooldown = world.time + 40 SECONDS


/mob/living/simple_animal/pet/cat/handle_automated_movement()
	. = ..()
	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			SSmove_manager.stop_looping(src)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				SSmove_manager.move_to(src, movement_target, 1, 4)


/mob/living/simple_animal/pet/cat/Proc
	name = "Proc"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/kitten
	name = "kitten"
	desc = "Какая милота!"
	ru_names = list(
		NOMINATIVE = "Котёнок",
		GENITIVE = "Котёнка",
		DATIVE = "Котёнку",
		ACCUSATIVE = "Котёнка",
		INSTRUMENTAL = "Котёнком",
		PREPOSITIONAL = "Котёнке"
	)
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	icon_resting = "kitten_sit"
	gender = NEUTER
	density = FALSE
	pass_flags = PASSMOB
	collar_type = "kitten"

/mob/living/simple_animal/pet/cat/Syndi
	name = "SyndiCat"
	desc = "Это дроид-СиндиКот."
	ru_names = list(
		NOMINATIVE = "СиндиКот",
		GENITIVE = "СиндиКота",
		DATIVE = "СиндиКоту",
		ACCUSATIVE = "СиндиКота",
		INSTRUMENTAL = "СиндиКотом",
		PREPOSITIONAL = "СиндиКоте"
	)
	icon_state = "Syndicat"
	icon_living = "Syndicat"
	icon_dead = "Syndicat_dead"
	icon_resting = "Syndicat_rest"
	meow_sound = 'sound/creatures/sindicat_meow.ogg'
	gender = FEMALE
	faction = list("syndicate")
	gold_core_spawnable = NO_SPAWN
	eats_mice = 0
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	melee_damage_lower = 5
	melee_damage_upper = 15


/mob/living/simple_animal/pet/cat/Syndi/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_GALACTIC_COMMON)
	ADD_TRAIT(src, TRAIT_NO_BREATH, INNATE_TRAIT)

/mob/living/simple_animal/pet/cat/Syndi/ComponentInitialize()
	AddComponent( \
		/datum/component/animal_temperature, \
		minbodytemp = 0, \
	)

/mob/living/simple_animal/pet/cat/cak
	name = "Keeki"
	desc = "Это кот, слепленный из торта."
	ru_names = list(
		NOMINATIVE = "котортик",
		GENITIVE = "котортика",
		DATIVE = "котортику",
		ACCUSATIVE = "котортика",
		INSTRUMENTAL = "котортиком",
		PREPOSITIONAL = "котортике"
	)
	icon_state = "cak"
	icon_living = "cak"
	icon_resting = "cak_rest"
	icon_dead = "cak_dead"
	health = 50
	maxHealth = 50
	harm_intent_damage = 10
	butcher_results = list(
		/obj/item/organ/internal/brain = 1,
		/obj/item/organ/internal/heart = 1,
		/obj/item/reagent_containers/food/snacks/birthdaycakeslice = 3,
		/obj/item/reagent_containers/food/snacks/meat/slab = 2
	)
	response_harm = "откусывает кусок от"
	attacked_sound = "sound/items/eatfood.ogg"
	deathmessage = "Теряет свою форму и рассыпается!"
	death_sound = "bodyfall"
	holder_type = /obj/item/holder/cak

/mob/living/simple_animal/pet/cat/cak/Life()
	..()
	if(stat)
		return
	if(health < maxHealth)
		adjustBruteLoss(-4)
	for(var/obj/item/reagent_containers/food/snacks/donut/D in range(1, src))
		if(D.icon_state != "donut2")
			D.name = "frosted donut"
			D.icon_state = "donut2"
			D.reagents.add_reagent("sprinkles", 2)
			D.filling_color = "#FF69B4"

/mob/living/simple_animal/pet/cat/cak/attack_hand(mob/living/L)
	..()
	if(L.a_intent == INTENT_HARM && L.reagents && !stat)
		L.reagents.add_reagent("nutriment", 0.4)
		L.reagents.add_reagent("vitamin", 0.4)

/mob/living/simple_animal/pet/cat/cak/CheckParts(list/parts)
	..()
	var/obj/item/organ/internal/brain/B = locate(/obj/item/organ/internal/brain) in contents
	if(!B || !B.brainmob || !B.brainmob.mind)
		return
	B.brainmob.mind.transfer_to(src)
	to_chat(src, "<span class='big bold'>Теперь вы Котортик!!</span><b> Вы безобидный гибрид кота и торта, вас все любят! Люди могут откусить от вас кусок, если проголодались, а вы можете восстанавливаете своё здоровье \
	настолько быстро, что это вас не беспокоит. Вы удивительно устойчивы к любому урону, тем более, вам вообще трудно умереть. You should go around and bring happiness and \ Теперь идите и несите радость \
	и тортик по станции!</b>")
	var/new_name = tgui_input_text(src, "Введите своё новое имя, или нажмите на \"Отмена\" чтобы оставить 'Котортик'.", "Поменять имя", name)
	if(!new_name)
		return
	to_chat(src, "<span class='notice'>Теперь вас зовут <b>\"[new_name]\"</b>!</span>")
	name = new_name

/mob/living/simple_animal/pet/cat/white
	name = "white"
	desc = "Белоснежная шерстка. Плохо различается на белой плитке, зато отлично виден в темноте!"
	ru_names = list(
		NOMINATIVE = "Беляш",
		GENITIVE = "Беляша",
		DATIVE = "Беляшу",
		ACCUSATIVE = "Беляша",
		INSTRUMENTAL = "Беляшом",
		PREPOSITIONAL = "Беляше"
	)
	icon_state = "penny"
	icon_living = "penny"
	icon_dead = "penny_dead"
	icon_resting = "penny_rest"
	icon_sit = "rest"
	gender = MALE
	holder_type = /obj/item/holder/cak

/mob/living/simple_animal/pet/cat/birman
	name = "birman"
	desc = "Кот священной породы Бирма"
	ru_names = list(
		NOMINATIVE = "Бирма",
		GENITIVE = "Бирмы",
		DATIVE = "Бирме",
		ACCUSATIVE = "Бирму",
		INSTRUMENTAL = "Бирмой",
		PREPOSITIONAL = "Бирме"
	)
	icon_state = "crusher"
	icon_living = "crusher"
	icon_dead = "crusher_dead"
	icon_resting = "crusher_rest"
	icon_sit = "rest"
	gender = MALE
	holder_type = /obj/item/holder/crusher

/mob/living/simple_animal/pet/cat/spacecat
	name = "spacecat"
	desc = "КОСМОКОТИК!!"
	ru_names = list(
		NOMINATIVE = "космокот",
		GENITIVE = "космокота",
		DATIVE = "космокоту",
		ACCUSATIVE = "космокота",
		INSTRUMENTAL = "космокотом",
		PREPOSITIONAL = "космокоте"
	)
	icon_state = "spacecat"
	icon_living = "spacecat"
	icon_dead = "spacecat_dead"
	icon_resting = "spacecat_rest"
	unsuitable_atmos_damage = 0
	holder_type = /obj/item/holder/spacecat

/mob/living/simple_animal/pet/cat/spacecat/ComponentInitialize()
	AddComponent( \
		/datum/component/animal_temperature, \
		maxbodytemp = T0C + 40, \
		minbodytemp = TCMB, \
	)

/mob/living/simple_animal/pet/cat/fat
	name = "FatCat"
	desc = "Упитана. Счастлива."
	ru_names = list(
		NOMINATIVE = "Ириска",
		GENITIVE = "Ириски",
		DATIVE = "Ириске",
		ACCUSATIVE = "Ириску",
		INSTRUMENTAL = "Ириской",
		PREPOSITIONAL = "Ирике"
	)
	icon = 'icons/mob/iriska.dmi'
	icon_state = "iriska"
	icon_living = "iriska"
	icon_dead = "iriska_dead"
	icon_resting = "iriska"
	gender = FEMALE
	mob_size = MOB_SIZE_LARGE	//THICK!!!
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat = 8)
	tts_seed = "Huntress"
	maxHealth = 40	//Sooooo faaaat...
	health = 40
	speed = 10		// TOO FAT
	wander = 0		// LAZY
	can_hide = 0
	resting = TRUE
	holder_type = /obj/item/holder/fatcat

/mob/living/simple_animal/pet/cat/fat/handle_automated_action()
	return
