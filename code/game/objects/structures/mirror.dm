//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	max_integrity = 200
	integrity_failure = 0.9
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	pixel_y = 32

/obj/structure/mirror/fancy
	icon_state = "fancymirror"
	pixel_y = 32

/obj/structure/mirror/Initialize(mapload)
	. = ..()
	if(icon_state == "mirror_broke" && !broken)
		obj_break(null, mapload)

/obj/structure/mirror/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(broken || !Adjacent(user))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mob_timers["mirrortime"])
			if(world.time < H.mob_timers["mirrortime"] + 6 MINUTES)
				var/list/options = list("hairstyle", "facial hairstyle", "hair color", "skin", "detail", "eye color")
				var/chosen = input(user, "Change what?", "ROGUETOWN")  as null|anything in options
				var/should_update
				switch(chosen)
					if("skin")
						var/listy = H.dna.species.get_skin_list()
						var/new_s_tone = input(user, "Choose your character's skin tone:", "Sun")  as null|anything in listy
						if(new_s_tone)
							H.skin_tone = listy[new_s_tone]
							should_update = TRUE
					if("eye color")
						var/new_eyes = input(user, "Choose your character's eye color:", "Character Preference","#"+H.eye_color) as color|null
						if(new_eyes)
							H.eye_color = sanitize_hexcolor(new_eyes)
							should_update = TRUE
				if(should_update)
					H.update_body()
					H.update_hair()
					H.update_body_parts()
/*
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		//see code/modules/mob/dead/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		//handle facial hair (if necessary)
		if(H.gender != FEMALE)
			var/new_style = input(user, "Select a facial hairstyle", "Grooming")  as null|anything in GLOB.facial_hairstyles_list
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return	//no tele-grooming
			if(new_style)
				H.facial_hairstyle = new_style
		else
			H.facial_hairstyle = "Shaved"

		//handle normal hair
		var/new_style = input(user, "Select a hairstyle", "Grooming")  as null|anything in GLOB.hairstyles_list
		if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
			return	//no tele-grooming
		if(new_style)
			H.hairstyle = new_style

		H.update_hair()*/

/obj/structure/mirror/examine_status(mob/user)
	if(broken)
		return list()// no message spam
	return ..()

/obj/structure/mirror/obj_break(damage_flag, mapload)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		icon_state = "[icon_state]1"
		if(!mapload)
			new /obj/item/natural/glass/shard (get_turf(src))
		broken = TRUE
	..()

/obj/structure/mirror/deconstruct(disassembled = TRUE)
//	if(!(flags_1 & NODECONSTRUCT_1))
//		if(!disassembled)
//			new /obj/item/shard( src.loc )
	..()

/obj/structure/mirror/welder_act(mob/living/user, obj/item/I)
	..()
	if(user.used_intent.type == INTENT_HARM)
		return FALSE

	if(!broken)
		return TRUE

	if(!I.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, span_notice("I begin repairing [src]..."))
	if(I.use_tool(src, user, 10, volume=50))
		to_chat(user, span_notice("I repair [src]."))
		broken = 0
		icon_state = initial(icon_state)
		desc = initial(desc)

	return TRUE


/obj/structure/mirror/magic
	name = "magic mirror"
	desc = ""
	icon_state = "magic_mirror"
	var/list/choosable_races = list()

/obj/structure/mirror/magic/New()
	if(!choosable_races.len)
		for(var/speciestype in subtypesof(/datum/species))
			var/datum/species/S = speciestype
			if(initial(S.changesource_flags) & MIRROR_MAGIC)
				choosable_races += initial(S.id)
		choosable_races = sortList(choosable_races)
	..()

/obj/structure/mirror/magic/lesser/New()
	var/list/selectable_species = get_selectable_species()
	choosable_races = selectable_species.Copy()
	..()

/obj/structure/mirror/magic/badmin/New()
	for(var/speciestype in subtypesof(/datum/species))
		var/datum/species/S = speciestype
		if(initial(S.changesource_flags) & MIRROR_BADMIN)
			choosable_races += initial(S.id)
	..()

/obj/structure/mirror/magic/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	var/choice = input(user, "Something to change?", "Magical Grooming") as null|anything in list("name", "race", "gender", "hair", "eyes")

	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	switch(choice)
		if("name")
			var/newname = copytext(sanitize_name(input(H, "Who are we again?", "Name change", H.name) as null|text),1,MAX_NAME_LEN)

			if(!newname)
				return
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			H.real_name = newname
			H.name = newname
			if(H.dna)
				H.dna.real_name = newname
			if(H.mind)
				H.mind.name = newname

		if("race")
			var/newrace
			var/racechoice = input(H, "What are we again?", "Race change") as null|anything in choosable_races
			newrace = GLOB.species_list[racechoice]

			if(!newrace)
				return
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			H.set_species(newrace, icon_update=0)

			if(H.dna.species.use_skintones)
				var/new_s_tone = input(user, "Choose your skin tone:", "Race change")  as null|anything in GLOB.skin_tones
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return

				if(new_s_tone)
					H.skin_tone = new_s_tone
					H.dna.update_ui_block(DNA_SKIN_TONE_BLOCK)

			if(MUTCOLORS in H.dna.species.species_traits)
				var/new_mutantcolor = input(user, "Choose your skin color:", "Race change","#"+H.dna.features["mcolor"]) as color|null
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return
				if(new_mutantcolor)
					var/temp_hsv = RGBtoHSV(new_mutantcolor)

					if(ReadHSV(temp_hsv)[3] >= ReadHSV("#7F7F7F")[3]) // mutantcolors must be bright
						H.dna.features["mcolor"] = sanitize_hexcolor(new_mutantcolor)

					else
						to_chat(H, span_notice("Invalid color. Your color is not bright enough."))

			H.update_body()
			H.update_hair()
			H.update_body_parts()

		if("gender")
			if(!(H.gender in list("male", "female"))) //blame the patriarchy
				return
			if(H.gender == "male")
				if(alert(H, "Become a Witch?", "Confirmation", "Yes", "No") == "Yes")
					if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
						return
					H.gender = "female"
					to_chat(H, span_notice("Man, you feel like a woman!"))
				else
					return

			else
				if(alert(H, "Become a Warlock?", "Confirmation", "Yes", "No") == "Yes")
					if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
						return
					H.gender = "male"
					to_chat(H, span_notice("Whoa man, you feel like a man!"))
				else
					return
			H.dna.update_ui_block(DNA_GENDER_BLOCK)
			H.update_body()

		if("hair")
			var/hairchoice = alert(H, "Hairstyle or hair color?", "Change Hair", "Style", "Color")
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			if(hairchoice == "Style") //So you just want to use a mirror then?
				..()
			else
				var/new_hair_color = input(H, "Choose your hair color", "Hair Color","#"+H.hair_color) as color|null
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return
				if(new_hair_color)
					H.hair_color = sanitize_hexcolor(new_hair_color)
					H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
				if(H.gender == "male")
					var/new_face_color = input(H, "Choose your facial hair color", "Hair Color","#"+H.facial_hair_color) as color|null
					if(new_face_color)
						H.facial_hair_color = sanitize_hexcolor(new_face_color)
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
				H.update_hair()

		if(BODY_ZONE_PRECISE_R_EYE)
			var/new_eye_color = input(H, "Choose your eye color", "Eye Color","#"+H.eye_color) as color|null
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			if(new_eye_color)
				H.eye_color = sanitize_hexcolor(new_eye_color)
				H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				H.update_body()
	if(choice)
		curse(user)

/obj/structure/mirror/magic/proc/curse(mob/living/user)
	return
