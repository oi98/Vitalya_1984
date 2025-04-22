/mob/living/simple_animal/pet/dog/security
	name = "Muhtar"
	real_name = "Мухтар"
	desc = "Верный служебный пес. Он гордо несёт бремя хорошего мальчика."
	ru_names = list(
		NOMINATIVE = "Мухтар",
		GENITIVE = "Мухтара",
		DATIVE = "Мухтару",
		ACCUSATIVE = "Мухтара",
		INSTRUMENTAL = "Мухтаром",
		PREPOSITIONAL = "Мухтаре"
	)
	icon_state = "german_shep"
	icon_living = "german_shep"
	icon_resting = "german_shep_rest"
	icon_sit = "german_shep_sit"
	icon_dead = "german_shep_dead"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	health = 35
	maxHealth = 35
	melee_damage_type = STAMINA
	melee_damage_lower = 8
	melee_damage_upper = 10
	attacktext = "кусает"
	footstep_type = FOOTSTEP_MOB_CLAW
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/security = 3)
	tts_seed = "Furion"

/mob/living/simple_animal/pet/dog/security/ranger
	name = "Ranger"
	real_name = "Рейнджер"
	desc = "Это Рейнджер, дружелюбный полицейский пёс. Он вызывал ужас у ксеноморфов, так что лучше будь с ним поласковее. <b>РЕЙНДЖЕР ВПЕРЁД</b>!"
	ru_names = list(
		NOMINATIVE = "Рейнджер",
		GENITIVE = "Рейнджера",
		DATIVE = "Рейнджеру",
		ACCUSATIVE = "Рейнджера",
		INSTRUMENTAL = "Рейнджером",
		PREPOSITIONAL = "Рейнджере"
	)
	icon_state = "ranger"
	icon_living = "ranger"
	icon_resting = "ranger_rest"
	icon_sit = "ranger_sit"
	icon_dead = "ranger_dead"
	tts_seed = "Pudge"

/mob/living/simple_animal/pet/dog/security/warden
	name = "Джульбарс"
	real_name = "Джульбарс"
	desc = "Мудрый служебный пес, названный в честь единственной собаки удостоившийся боевой награды."
	ru_names = list(
		NOMINATIVE = "Джульбарс",
		GENITIVE = "Джульбарса",
		DATIVE = "Джульбарсу",
		ACCUSATIVE = "Джульбарса",
		INSTRUMENTAL = "Джульбарсом",
		PREPOSITIONAL = "Джульбарсе"
	)
	icon_state = "german_shep2"
	icon_living = "german_shep2"
	icon_resting = "german_shep2_rest"
	icon_dead = "german_shep2_dead"
	tts_seed = "pantheon"



/mob/living/simple_animal/pet/dog/security/Initialize(mapload)
	. = ..()
	regenerate_icons()

/mob/living/simple_animal/pet/dog/security/add_strippable_element()
	AddElement(/datum/element/strippable, length(strippable_inventory_slots) ? create_strippable_list(strippable_inventory_slots) : GLOB.strippable_muhtar_items)

/mob/living/simple_animal/pet/dog/security/Destroy()
	QDEL_NULL(inventory_head)
	QDEL_NULL(inventory_mask)
	return ..()

/mob/living/simple_animal/pet/dog/security/handle_atom_del(atom/A)
	if(A == inventory_head)
		inventory_head = null
		regenerate_icons()
	if(A == inventory_mask)
		inventory_mask = null
		regenerate_icons()
	return ..()

/mob/living/simple_animal/pet/dog/security/Life(seconds, times_fired)
	. = ..()
	regenerate_icons()

/mob/living/simple_animal/pet/dog/security/death(gibbed)
	..(gibbed)
	regenerate_icons()


/mob/living/simple_animal/pet/dog/security/place_on_head(obj/item/item_to_add, mob/user)

	if(istype(item_to_add, /obj/item/grenade/plastic/c4)) // last thing he ever wears, I guess
		item_to_add.afterattack(src, user, TRUE)
		return

	if(inventory_head)
		if(user)
			balloon_alert(user, "Шляпа уже надета!")
		return
	if(!item_to_add)
		user.visible_message("<span class='notice'>[user] гладит [src.declent_ru(ACCUSATIVE)].</span>", "<span class='notice'>Вы кладёте руку на голову [src.declent_ru(GENITIVE)].</span>")
		if(flags & HOLOGRAM)
			return
		return

	if(user && !user.drop_item_ground(item_to_add))
		to_chat(user, "<span class='warning'> [item_to_add] застрял в ваших руках, вы не можете надеть её на голову [src.declent_ru(DATIVE)]!</span>")
		return 0

	var/valid = FALSE
	if(ispath(item_to_add.muhtar_fashion, /datum/muhtar_fashion/head))
		valid = TRUE

	//Various hats and items (worn on his head) change muhtar's behaviour. His attributes are reset when a hat is removed.

	if(valid)
		if(health <= 0)
			to_chat(user, "<span class='notice'>Когда вы надеваете [item_to_add.declent_ru(GENITIVE)] на голову [src.declent_ru(DATIVE)], вы видите тусклый, бесжизненный взгляд у [genderize_ru(src.gender,"него","неё","него","них")] в глазах.</span>")
		else if(user)
			user.visible_message("<span class='notice'>[user] надевает [item_to_add] на голову [src.declent_ru(GENITIVE)]. [src] смотрит на [genderize_ru(user.gender,"него","неё","него","них")] и тяфкает.</span>",
				"<span class='notice'>Вы надеваете [item_to_add.declent_ru(GENITIVE)] на голову [src.declent_ru(DATIVE)]. [src] бросает на вас необычный взгляд, затем, вильнув хвостом, довольно тяфкнул.</span>",
				"<span class='italics'>Вы слышите дружелюбное тяфканье.</span>")
		item_to_add.forceMove(src)
		inventory_head = item_to_add
		update_dog_fluff()
		regenerate_icons()
	else
		to_chat(user, "<span class='warning'>Вы надеваете [item_to_add.declent_ru(GENITIVE)] на голову [src.declent_ru(GENITIVE)], но [item_to_add] тут же сваливается!</span>")
		item_to_add.forceMove(drop_location())
		if(prob(25))
			step_rand(item_to_add)
		for(var/i in list(1,2,4,8,4,8,4,dir))
			setDir(i)
			sleep(1)

	return valid

/mob/living/simple_animal/pet/dog/security/update_dog_fluff()
	// First, change back to defaults
	name = real_name
	desc = initial(desc)
	// BYOND/DM doesn't support the use of initial on lists.
	speak = list("ТЯФ!", "Гав!", "Гаф!", "Ааууууу!")
	speak_emote = list("лает", "гавкает")
	emote_hear = list("лает!", "гафкает!", "тяфкает.", "дышит с высунутым языком.")
	emote_see = list("трясёт головой.", "гоняется за своим хвостом.", "дрожит.")
	desc = initial(desc)

	if(inventory_head && inventory_head.muhtar_fashion)
		var/datum/muhtar_fashion/DF = new inventory_head.muhtar_fashion(src)
		DF.apply(src)

	if(inventory_mask && inventory_mask.muhtar_fashion)
		var/datum/muhtar_fashion/DF = new inventory_mask.muhtar_fashion(src)
		DF.apply(src)

/mob/living/simple_animal/pet/dog/security/regenerate_icons()
	..()
	if(inventory_head)
		var/image/head_icon
		var/datum/muhtar_fashion/DF = new inventory_head.muhtar_fashion(src)

		if(!DF.obj_icon_state)
			DF.obj_icon_state = inventory_head.icon_state
		if(!DF.obj_alpha)
			DF.obj_alpha = inventory_head.alpha
		if(!DF.obj_color)
			DF.obj_color = inventory_head.color


		if (icon_state == icon_resting)
			head_icon = DF.get_overlay()
			head_icon.pixel_y = -2
		else
			head_icon = DF.get_overlay()

		if(health <= 0)
			head_icon = DF.get_overlay(dir = EAST)
			head_icon.pixel_y = -8
			head_icon.transform = turn(head_icon.transform, 180)

		add_overlay(head_icon)

	if(inventory_mask)
		var/image/mask_icon
		var/datum/muhtar_fashion/DF = new inventory_mask.muhtar_fashion(src)

		if(!DF.obj_icon_state)
			DF.obj_icon_state = inventory_mask.icon_state
		if(!DF.obj_alpha)
			DF.obj_alpha = inventory_mask.alpha
		if(!DF.obj_color)
			DF.obj_color = inventory_mask.color

		if(icon_state == icon_resting)
			mask_icon = DF.get_overlay()
			mask_icon.pixel_y = -2
		else
			mask_icon = DF.get_overlay()

		if(health <= 0)
			mask_icon = DF.get_overlay(dir = EAST)
			mask_icon.pixel_y = -11
			mask_icon.transform = turn(mask_icon.transform, 180)

		add_overlay(mask_icon)

/mob/living/simple_animal/pet/dog/security/detective
	name = "Гав-Гавыч"
	desc = "Старый служебный пёс. Он давно потерял нюх, однако детектив по-прежнему содержит и заботится о нём."
	ru_names = list(
		NOMINATIVE = "Гав-Гавыч",
		GENITIVE = "Гав-Гавыча",
		DATIVE = "Гав-Гавычу",
		ACCUSATIVE = "Гав-Гавыча",
		INSTRUMENTAL = "Гав-Гавычом",
		PREPOSITIONAL = "Гав-Гавыче"
	)
	icon_state = "blackdog"
	icon_living = "blackdog"
	icon_sit = "blackdog"
	icon_resting = "blackdog"
	icon_dead = "blackdog_dead"
	icon_resting = "blackdog_rest"
	tts_seed = "Thrall"

/mob/living/simple_animal/pet/dog/security/detective/add_strippable_element()
	AddElement(/datum/element/strippable, create_strippable_list(list(/datum/strippable_item/pet_collar)))
