#define TALL_CANDLE 1
#define MID_CANDLE 2
#define SHORT_CANDLE 3

/obj/item/candle
	name = "candle"
	desc = "In Greek myth, Prometheus stole fire from the Gods and gave it to humankind. The jewelry he kept for himself."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1_greyscale"
	item_state = "candle1"
	w_class = WEIGHT_CLASS_TINY
	var/wax = 200
	/// Index for the icon state
	var/wax_index = TALL_CANDLE
	var/lit = FALSE
	var/infinite = FALSE
	var/start_lit = FALSE
	var/flickering = FALSE
	color = COLOR_BEIGE
	light_color = COLOR_LIGHT_ORANGE
	light_system = MOVABLE_LIGHT
	light_range = CANDLE_LUM
	light_on = FALSE
	/// flame overlay
	var/mutable_appearance/overlay


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
		. += mutable_appearance(icon, "flickering_light[wax_index]")
	if(lit)
		. += mutable_appearance(icon, "light[wax_index]")

/obj/item/candle/update_icon_state()
	icon_state = "candle[wax_index]_greyscale"

/obj/item/candle/can_enter_storage(obj/item/storage/S, mob/user)
	if(lit)
		to_chat(user, "<span class='warning'>[S] can't hold [src] while it's lit!</span>")
		return FALSE
	return TRUE

/obj/item/candle/get_heat()
	return lit * 1000

/obj/item/candle/attackby(obj/item/I, mob/user, params)
	if(I.get_heat() && light(span_notice("[user] lights [src] with [I].")))
		add_fingerprint(user)
		return ATTACK_CHAIN_PROCEED_SUCCESS
	return ..()


/obj/item/candle/welder_act(mob/user, obj/item/I)
	. = TRUE
	if(I.tool_use_check(user, 0)) //Don't need to flash eyes because you are a badass
		light("<span class='notice'>[user] casually lights the [name] with [I], what a badass.</span>")


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
	update_overlays()
	return TRUE


/obj/item/candle/proc/update_wax_index()
	var/new_wax_index
	if(wax > 150)
		new_wax_index = TALL_CANDLE
	else if(wax > 80)
		new_wax_index = MID_CANDLE
	else
		new_wax_index = SHORT_CANDLE
	if(wax_index != new_wax_index)
		wax_index = new_wax_index
		return TRUE
	return FALSE


/obj/item/candle/proc/start_flickering()
	flickering = TRUE
	update_icon(UPDATE_ICON_STATE)
	addtimer(CALLBACK(src, PROC_REF(stop_flickering)), 4 SECONDS, TIMER_UNIQUE)


/obj/item/candle/proc/stop_flickering()
	flickering = FALSE
	update_icon(UPDATE_ICON_STATE)


/obj/item/candle/process()
	if(!lit)
		return
	if(!infinite)
		wax--
		if(wax_index != SHORT_CANDLE) // It's not at its shortest
			if(update_wax_index())
				update_overlays()
				update_icon(UPDATE_ICON_STATE)
	if(!wax)
		new/obj/item/trash/candle(loc).color = color
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
		cut_overlay()
		set_light_on(FALSE)


/obj/item/candle/attack_self(mob/user)
	if(lit)
		user.visible_message("<span class='notice'>[user] snuffs out [src].</span>")
		unlight()



/obj/item/candle/get_spooked()
	if(lit)
		start_flickering()
		playsound(src, 'sound/effects/candle_flicker.ogg', 15, TRUE)
		return TRUE
	return FALSE


/obj/item/candle/eternal
	desc = "A candle. This one seems to have an odd quality about the wax."
	infinite = TRUE


/obj/item/candle/eternal/wizard
	desc = "A candle. It smells like magic, so that would explain why it burns brighter."
	start_lit = TRUE


/obj/item/candle/extinguish_light(force = FALSE)
	if(!force)
		return
	infinite = FALSE
	wax = 1 // next process will burn it out

/obj/item/candle/blue
	name = "blue candle"
	color = COLOR_BLUE_GRAY
	light_color = COLOR_BLUE_LIGHT

/obj/item/candle/green
	name = "green candle"
	color = COLOR_GREEN_GRAY
	light_color = COLOR_GREEN

/obj/item/candle/purple
	name = "purple candle"
	color = COLOR_PURPLE_GRAY
	light_color = COLOR_BLUE_LIGHT

/obj/item/candle/red
	name = "red candle"
	color = COLOR_RED_LIGHT
	light_color = COLOR_RED_LIGHT
