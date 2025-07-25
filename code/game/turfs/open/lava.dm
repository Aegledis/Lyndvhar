///LAVA

/turf/open/lava
	name = "lava"
	icon_state = "lava"
	icon = 'icons/turf/roguefloor.dmi'
	gender = PLURAL //"That's some lava."
	baseturfs = /turf/open/lava //lava all the way down
	slowdown = 2

	light_outer_range =  4
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA
	bullet_bounce_sound = 'sound/blank.ogg'

	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/closed, /turf/open/floor/rogue/volcanic, /turf/open/floor/rogue/dirt, /turf/open/floor/rogue/dirt/road,/turf/open/floor/rogue/naturalstone)
	neighborlay_override = "lavedge"
	turf_flags = NONE

/turf/open/lava/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/lava/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/lava/can_traverse_safely(atom/movable/traveler)
	return FALSE

/turf/open/lava/ex_act(severity, target)
	contents_explosion(severity, target)

/turf/open/lava/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/lava/Melt()
	to_be_destroyed = FALSE
	return src

/turf/open/lava/acid_act(acidpwr, acid_volume)
	return

/turf/open/lava/MakeDry(wet_setting = TURF_WET_WATER)
	return

/turf/open/lava/Entered(atom/movable/AM)
	if(!AM.throwing)
		if(burn_stuff(AM))
			START_PROCESSING(SSobj, src)
		if(ishuman(AM))
			playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)
//			addomen("lava")

/turf/open/lava/Exited(atom/movable/Obj, atom/newloc)
	. = ..()
	if(!Obj.throwing)
		if(isliving(Obj))
			var/mob/living/L = Obj
			if(!islava(newloc) && !L.on_fire)
				L.update_fire()

/turf/open/lava/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)
		playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)

/turf/open/lava/process()
	if(!burn_stuff())
		STOP_PROCESSING(SSobj, src)

/turf/open/lava/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/lava/proc/is_safe()
	//if anything matching this typecache is found in the lava, we don't burn things
	var/static/list/lava_safeties_typecache = typecacheof(list(/obj/structure/stone_tile))
	var/list/found_safeties = typecache_filter_list(contents, lava_safeties_typecache)
	for(var/obj/structure/stone_tile/S in found_safeties)
		if(S.fallen)
			LAZYREMOVE(found_safeties, S)
	return LAZYLEN(found_safeties)


/turf/open/lava/proc/burn_stuff(AM)
	. = 0

	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if (AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if((O.resistance_flags & (LAVA_PROOF|INDESTRUCTIBLE)) || O.throwing)
				continue
			. = 1
			if((O.resistance_flags & (ON_FIRE)))
				continue
			if(!(O.resistance_flags & FLAMMABLE))
				O.resistance_flags |= FLAMMABLE //Even fireproof things burn up in lava
			if(O.resistance_flags & FIRE_PROOF)
				O.resistance_flags &= ~FIRE_PROOF
			if(O.armor.fire > 50) //obj with 100% fire armor still get slowly burned away.
				O.armor = O.armor.setRating(fire = 50)
			qdel(O)

		else if (isliving(thing))
			. = 1
			var/mob/living/L = thing
			if(L.movement_type & FLYING)
				continue	//YOU'RE FLYING OVER IT
			var/buckle_check = L.buckling
			if(!buckle_check)
				buckle_check = L.buckled
			if(isobj(buckle_check))
				var/obj/O = buckle_check
				if(O.resistance_flags & LAVA_PROOF)
					continue
			else if(isliving(buckle_check))
				var/mob/living/live = buckle_check
				if("lava" in live.weather_immunities)
					continue

			if(!L.on_fire)
				L.update_fire()

			if(iscarbon(L))
				var/mob/living/carbon/C = L
				var/obj/item/clothing/S = C.get_item_by_slot(SLOT_ARMOR)
				var/obj/item/clothing/H = C.get_item_by_slot(SLOT_HEAD)

				if(S && H && S.clothing_flags & LAVAPROTECT && H.clothing_flags & LAVAPROTECT)
					return

				if(C.health <= 0)
					C.dust(drop_items = TRUE)

			if("lava" in L.weather_immunities)
				continue

//			L.adjustFireLoss(50)
			if(L) //mobs turning into object corpses could get deleted here.
				L.adjustFireLoss(10)
				L.adjust_fire_stacks(100)
				L.IgniteMob()
				if(L.health <= 0)
					L.dust(drop_items = TRUE)

/turf/open/lava/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		user.visible_message(span_info("[user] starts to drink from [src]."))
		if(do_after(L, 25, target = src))
			var/mob/living/carbon/C = user
			to_chat(C, span_userdanger("OH SWEET PSYDON, WHY DID I THINK THIS WAS A GOOD IDEA???"))
			C.flash_fullscreen("redflash3")
			C.emote("agony", forced = TRUE)
			C.adjust_fire_stacks(500) //you deserve this.
			C.IgniteMob()
			C.adjustFireLoss(1000) //you, literally, deserve this.

/turf/open/lava/smooth
	name = "lava"
	baseturfs = /turf/open/lava/smooth
	icon = 'icons/turf/floors/lava.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/lava/smooth)

/turf/open/lava/smooth/lava_land_surface

	baseturfs = /turf/open/lava/smooth/lava_land_surface

/turf/open/lava/smooth/airless

/turf/open/lava/acid
	name = "acid"
	icon_state = "acid"
	light_outer_range =  4
	light_power = 1
	light_color = "#56ff0d"

/turf/open/lava/acid/burn_stuff(AM)
	. = 0

	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if (AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if((O.resistance_flags & (ACID_PROOF|INDESTRUCTIBLE)) || O.throwing)
				continue
			. = 1
			qdel(O)

		else if (isliving(thing))
			. = 1
			var/mob/living/L = thing
			if(L.movement_type & FLYING)
				continue	//YOU'RE FLYING OVER IT
			var/buckle_check = L.buckling
			if(!buckle_check)
				buckle_check = L.buckled
			if(isobj(buckle_check))
				var/obj/O = buckle_check
				if(O.resistance_flags & ACID_PROOF)
					continue
			else if(isliving(buckle_check))
				var/mob/living/live = buckle_check
				if("lava" in live.weather_immunities)
					continue

			if(iscarbon(L))
				var/mob/living/carbon/C = L
//				var/obj/item/clothing/S = C.get_item_by_slot(SLOT_ARMOR)
//				var/obj/item/clothing/H = C.get_item_by_slot(SLOT_HEAD)

//				if(S && H && S.clothing_flags & LAVAPROTECT && H.clothing_flags & LAVAPROTECT)
//					return
				//make this acid
				var/shouldupdate = FALSE
				for(var/obj/item/bodypart/B in C.bodyparts)
					if(!B.skeletonized && B.is_organic_limb())
						B.skeletonize()
						shouldupdate = TRUE
				if(shouldupdate)
					if(ishuman(C))
						var/mob/living/carbon/human/H = C
						H.underwear = "Nude"
					C.unequip_everything()
					C.update_body()
//				C.dust(drop_items = TRUE)
				continue

//			if("lava" in L.weather_immunities)
//				continue

			L.dust(drop_items = TRUE)

/turf/open/lava/acid/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		user.visible_message(span_info("[user] starts to drink from [src]."))
		if(do_after(L, 25, target = src))
			var/mob/living/carbon/C = user
			to_chat(C, span_userdanger("OH SWEET PSYDON, WHY DID I THINK THIS WAS A GOOD IDEA???"))
			C.flash_fullscreen("redflash3")
			C.emote("agony", forced = TRUE)
			C.gib() //YOU. LITERALLY. DESERVE THIS.
