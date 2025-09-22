#define TALL_CANDLE 1
#define MID_CANDLE 2
#define SHORT_CANDLE 3

/obj/item/candle
	name = "candle"
	desc = "Небольшая белая свеча с хлопковым фитилём. Горит ровным мягким пламенем."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1_greyscale"
	item_state = "candle"
	w_class = WEIGHT_CLASS_TINY
	var/fuel = 200
	/// Index for the icon state
	var/fuel_index = TALL_CANDLE
	var/lit = FALSE
	var/infinite = FALSE
	var/start_lit = FALSE
	var/flickering = FALSE
	color = CANDLE_COLOR_DEFAULT
	light_color = CANDLE_LIGHT_COLOR_DEFAULT
	light_system = MOVABLE_LIGHT
	light_range = CANDLE_LUM
	light_on = FALSE

/obj/item/candle/get_ru_names()
	return list(
		NOMINATIVE = "белая свеча",
		GENITIVE = "белой свечи",
		DATIVE = "белой свече",
		ACCUSATIVE = "белую свечу",
		INSTRUMENTAL = "белой свечой",
		PREPOSITIONAL = "белой свече"
	)

/obj/item/candle/Initialize(mapload)
	. = ..()
	if(start_lit)
		// No visible message
		light(show_message = 0)


/obj/item/candle/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/candle/update_overlays()
	. = ..()
	if(flickering)
		. += mutable_appearance(icon, "flickering_light[fuel_index]")
	if(lit)
		. += mutable_appearance(icon, "light[fuel_index]")

/obj/item/candle/update_icon_state()
	icon_state = "candle[fuel_index]_greyscale"
	if(!lit)
		item_state = "candle"
	item_state = "candle_lit"

/obj/item/candle/can_enter_storage(obj/item/storage/S, mob/user)
	if(lit)
		user.balloon_alert(user, "потушите свечу!")
		return FALSE
	return TRUE

/obj/item/candle/get_heat()
	return lit * 1000

/obj/item/candle/attackby(obj/item/item, mob/user, params)
	if(item.get_heat() && light(span_notice("[user] зажига[pluralize_ru(user.gender, "ет", "ют")] [declent_ru(ACCUSATIVE)] [item.declent_ru(INSTRUMENTAL)].")))
		add_fingerprint(user)
		return ATTACK_CHAIN_PROCEED_SUCCESS
	return ..()


/obj/item/candle/welder_act(mob/user, obj/item/item)
	. = TRUE
	if(item.tool_use_check(user, 0)) //Don't need to flash eyes because you are a badass
		light(span_notice("[user] непринуждённо зажига[pluralize_ru(user, "ет", "ют")] [declent_ru(ACCUSATIVE)] с помощью [item.declent_ru(GENITIVE)]. Чёрт, как же он[genderize_ru(user.gender, "", "а", "о", "и")] крут[genderize_ru(user.gender, "", "а", "о", "ы")]!"))


/obj/item/candle/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	if(!lit)
		light() //honk
	return ..()


/obj/item/candle/proc/light(show_message)
	if(lit)
		return FALSE
	lit = TRUE
	if(show_message)
		usr?.visible_message(show_message)
	set_light_on(TRUE)
	START_PROCESSING(SSobj, src)
	update_icon(UPDATE_OVERLAYS)
	return TRUE

/obj/item/candle/proc/update_fuel_index()
	var/new_fuel_index
	if(fuel > 150)
		new_fuel_index = TALL_CANDLE
	else if(fuel > 80)
		new_fuel_index = MID_CANDLE
	else
		new_fuel_index = SHORT_CANDLE
	if(fuel_index != new_fuel_index)
		fuel_index = new_fuel_index
		return TRUE
	return FALSE


/obj/item/candle/proc/start_flickering()
	flickering = TRUE
	update_icon(UPDATE_OVERLAYS)
	addtimer(CALLBACK(src, PROC_REF(stop_flickering)), 4 SECONDS, TIMER_UNIQUE)


/obj/item/candle/proc/stop_flickering()
	flickering = FALSE
	cut_overlays()


/obj/item/candle/process()
	if(!lit)
		return
	if(!infinite)
		fuel--
		if(fuel_index != SHORT_CANDLE) // It's not at its shortest
			if(update_fuel_index())
				cut_overlays()
				update_icon(UPDATE_OVERLAYS)
				update_icon(UPDATE_ICON_STATE)
	if(!fuel)
		new/obj/item/trash/candle(loc)
		if(ismob(loc))
			var/mob/holder = loc
			holder.drop_item_ground(src, force = TRUE) //src is being deleted anyway
		qdel(src)
	if(isturf(loc)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)


/obj/item/candle/proc/unlight()
	if(lit)
		lit = FALSE
		cut_overlays()
		set_light_on(FALSE)


/obj/item/candle/attack_self(mob/user)
	if(lit)
		user.balloon_alert(user, "свеча потушена")
		unlight()


/obj/item/candle/get_spooked()
	if(lit)
		start_flickering()
		playsound(src, 'sound/effects/candle_flicker.ogg', 15, TRUE)
		return TRUE
	return FALSE


/obj/item/candle/extinguish_light(force = FALSE)
	if(!force)
		return
	infinite = FALSE
	fuel = 1 // next process will burn it out


/obj/item/candle/blue
	name = "blue candle"
	desc = "Небольшая синяя свеча с хлопковым фитилём. Горит ровным мягким пламенем."
	color = CANDLE_COLOR_BLUE
	light_color = CANDLE_LIGHT_COLOR_BLUE

/obj/item/candle/blue/get_ru_names()
	return list(
		NOMINATIVE = "синяя свеча",
		GENITIVE = "синей свечи",
		DATIVE = "синей свече",
		ACCUSATIVE = "синюю свечу",
		INSTRUMENTAL = "синей свечой",
		PREPOSITIONAL = "синей свече"
	)

/obj/item/candle/green
	name = "green candle"
	desc = "Небольшая зелёная свеча с хлопковым фитилём. Горит ровным мягким пламенем."
	color = CANDLE_COLOR_GREEN
	light_color = CANDLE_LIGHT_COLOR_GREEN

/obj/item/candle/green/get_ru_names()
	return list(
		NOMINATIVE = "зелёная свеча",
		GENITIVE = "зелёной свечи",
		DATIVE = "зелёной свече",
		ACCUSATIVE = "зелёную свечу",
		INSTRUMENTAL = "зелёной свечой",
		PREPOSITIONAL = "зелёной свече"
	)


/obj/item/candle/purple
	name = "purple candle"
	desc = "Небольшая фиолетовая свеча с хлопковым фитилём. Горит ровным мягким пламенем."
	color = CANDLE_COLOR_PURPLE
	light_color = CANDLE_LIGHT_COLOR_PURPLE

/obj/item/candle/purple/get_ru_names()
	return list(
		NOMINATIVE = "фиолетовая свеча",
		GENITIVE = "фиолетовой свечи",
		DATIVE = "фиолетовой свече",
		ACCUSATIVE = "фиолетовую свечу",
		INSTRUMENTAL = "фиолетовой свечой",
		PREPOSITIONAL = "фиолетовой свече"
	)


/obj/item/candle/red
	name = "red candle"
	desc = "Небольшая красная свеча с хлопковым фитилём. Горит ровным мягким пламенем."
	color = CANDLE_COLOR_RED
	light_color = CANDLE_LIGHT_COLOR_RED

/obj/item/candle/red/get_ru_names()
	return list(
		NOMINATIVE = "красная свеча",
		GENITIVE = "красной свечи",
		DATIVE = "красной свече",
		ACCUSATIVE = "красную свечу",
		INSTRUMENTAL = "красной свечой",
		PREPOSITIONAL = "красной свече"
	)

/obj/item/candle/red/church
	light_color = CANDLE_LIGHT_COLOR_DEFAULT


/obj/item/candle/red/church/eternal
	infinite = TRUE


/obj/item/candle/blue/wizard
	desc = "Синяя восковая свеча. От неё пахнет колдунством... Теперь ясно, почему она горит ярче остальных."
	infinite = TRUE
	start_lit = TRUE

#undef TALL_CANDLE
#undef MID_CANDLE
#undef SHORT_CANDLE
