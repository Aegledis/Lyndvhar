/turf/open
	plane = FLOOR_PLANE
	var/slowdown = 0 //negative for faster, positive for slower

	var/postdig_icon_change = FALSE
	var/postdig_icon
	var/wet
	var/footstep = null
	var/barefootstep = null
	var/clawfootstep = null
	var/heavyfootstep = null
	var/footstepstealth = FALSE
	baseturfs = /turf/open/transparent/openspace

	damage_deflection = INFINITY //TODO: Find a better method for breakable turf system

/turf/proc/get_slowdown(mob/user)
	return 0

/turf/open/get_slowdown(mob/user)
	return slowdown + snow?.get_slowdown()

/turf
	var/landsound = null

/turf/open/ComponentInitialize()
	. = ..()
	if(wet)
		AddComponent(/datum/component/wet_floor, wet, INFINITY, 0, INFINITY, TRUE)


//direction is direction of travel of A
/turf/open/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	return FALSE

//direction is direction of travel of A
/turf/open/zPassOut(atom/movable/A, direction, turf/destination)
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

//direction is direction of travel of air
/turf/open/zAirIn(direction, turf/source)
	return (direction == DOWN)

//direction is direction of travel of air
/turf/open/zAirOut(direction, turf/source)
	return (direction == UP)

/turf/open/proc/freon_gas_act()
	for(var/obj/I in contents)
		if(I.resistance_flags & FREEZE_PROOF)
			continue
		if(!(I.obj_flags & FROZEN))
			I.make_frozen_visual()
	for(var/mob/living/L in contents)
		if(L.bodytemperature <= 50)
			L.apply_status_effect(/datum/status_effect/freon)
	MakeSlippery(TURF_WET_PERMAFROST, 50)
	return TRUE

/turf/open/proc/water_vapor_gas_act()
	MakeSlippery(TURF_WET_WATER, min_wet_time = 100, wet_time_to_add = 50)

	SEND_SIGNAL(src, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
	return TRUE

/turf/open/handle_slip(mob/living/carbon/C, knockdown_amount, obj/O, lube, paralyze_amount, force_drop)
	if(C.movement_type & FLYING)
		return 0
	if(has_gravity(src))
		var/obj/buckled_obj
		if(C.buckled)
			buckled_obj = C.buckled
			if(!(lube&GALOSHES_DONT_HELP)) //can't slip while buckled unless it's lube.
				return 0
		else
			if(!(lube&SLIP_WHEN_CRAWLING) && (!(C.mobility_flags & MOBILITY_STAND) || !(C.status_flags & CANKNOCKDOWN))) // can't slip unbuckled mob if they're lying or can't fall.
				return 0
			if(C.m_intent == MOVE_INTENT_WALK && (lube&NO_SLIP_WHEN_WALKING))
				return 0
		if(!(lube&SLIDE_ICE))
			to_chat(C, "<span class='notice'>I slipped[ O ? " on the [O.name]" : ""]!</span>")
			playsound(C.loc, 'sound/blank.ogg', 50, TRUE, -3)

		SEND_SIGNAL(C, COMSIG_ADD_MOOD_EVENT, "slipped", /datum/mood_event/slipped)
		if(force_drop)
			for(var/obj/item/I in C.held_items)
				C.accident(I)

		var/olddir = C.dir
		C.moving_diagonally = 0 //If this was part of diagonal move slipping will stop it.
		if(!(lube & SLIDE_ICE))
			C.Knockdown(knockdown_amount)
			C.Paralyze(paralyze_amount)
			C.stop_pulling()
		else
			C.Knockdown(1)

		if(buckled_obj)
			buckled_obj.unbuckle_mob(C)
			lube |= SLIDE_ICE

		if(lube&SLIDE)
			new /datum/forced_movement(C, get_ranged_target_turf(C, olddir, 4), 1, FALSE, CALLBACK(C, TYPE_PROC_REF(/mob/living/carbon, spin), 1, 1))
		else if(lube&SLIDE_ICE)
			if(C.force_moving) //If we're already slipping extend it
				qdel(C.force_moving)
			new /datum/forced_movement(C, get_ranged_target_turf(C, olddir, 1), 1, FALSE)	//spinning would be bad for ice, fucks up the next dir
		return 1

/turf/open/proc/MakeSlippery(wet_setting = TURF_WET_WATER, min_wet_time = 0, wet_time_to_add = 0, max_wet_time = MAXIMUM_WET_TIME, permanent)
	AddComponent(/datum/component/wet_floor, wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)

/turf/open/proc/MakeDry(wet_setting = TURF_WET_WATER, immediate = FALSE, amount = INFINITY)
	SEND_SIGNAL(src, COMSIG_TURF_MAKE_DRY, wet_setting, immediate, amount)

/turf/proc/OnDry()
	return

/turf/open/get_dumping_location()
	return src

/turf/open/proc/ClearWet()//Nuclear option of immediately removing slipperyness from the tile instead of the natural drying over time
	qdel(GetComponent(/datum/component/wet_floor))
