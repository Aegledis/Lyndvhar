/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*
 *		 (Meats)		*
 *						*
 * * * * * * * * * * * **/


/*	.............   Raw meat   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat
	eat_effect = /datum/status_effect/debuff/uncookedfood
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	name = "meat"
	icon_state = "meatslab"
	slice_batch = TRUE // so it takes more time, changed from FALSE
	filling_color = "#8f433a"
	rotprocess = SHELFLIFE_SHORT
	chopping_sound = TRUE
	foodtype = MEAT
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/obj/item/reagent_containers/food/snacks/rogue/meat/steak
	ingredient_size = 2
	name = "raw meat"
	icon_state = "meatcutlet"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	slice_bclass = BCLASS_CHOP


/*	.............   Minced meat & stuffing sausages   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/mince
	name = "mince"
	icon_state = "meatmince"
	ingredient_size = 2
	slice_path = null
	filling_color = "#8a0000"
	rotprocess = SHELFLIFE_TINY
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/mess(get_turf(src))
	playsound(get_turf(src), 'modular/Neu_Food/sound/meatslap.ogg', 100, TRUE, -1)
	..()
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(user.mind)
		short_cooktime = (6 SECONDS - (user.mind.get_skill_level(/datum/skill/craft/cooking) * 0.5 SECONDS))
		long_cooktime = (10 SECONDS - (user.mind.get_skill_level(/datum/skill/craft/cooking) * 1 SECONDS))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("Stuffing a wiener..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/fat))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("Stuffing a wiener..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	else
		return ..()


/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	name = "minced meat"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	name = "minced fish"
	icon_state = "fishmince"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit
	name = "minced cabbit"
	icon_state = "meatmince"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	name = "mince poultry"
	icon_state = "meatmince"


/*	.............   Pork, spidermeat, birdmeat   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/fatty //pork
	name = "raw pigflesh"
	icon_state = "meatcutlet"
	color = "#f093c3"
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/bacon
	name = "raw bacon"
	icon_state = "bacon"
	slice_path = null
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	filling_color = "#8a0000"


/obj/item/reagent_containers/food/snacks/rogue/meat/spider // Low-nutrient, kind of gross. Survival food.
	name = "spidermeat"
	icon_state = "spidermeat"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	slice_path = null
	slices_num = 0


/obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	name = "plucked bird"
	icon_state = "halfchicken"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	fried_type = null
	slices_num = 2
	slice_sound = TRUE
	ingredient_size = 4

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	name = "bird meat"
	icon_state = "chickencutlet"
	ingredient_size = 2
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	slices_num = 1
	slice_bclass = BCLASS_CHOP
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried

/obj/item/reagent_containers/food/snacks/rogue/meat/crab
	name = "crab meat"
	desc = "A chunk of raw crab meat, absolutely wonderful."
	icon_state = "crabmeatraw"
	slice_path = null
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	slices_num = null
	ingredient_size = 1


/*	..................   Sausage & Wiener   ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	name = "raw sausage"
	icon_state = "raw_wiener"
	ingredient_size = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked

/obj/item/reagent_containers/food/snacks/rogue/meat/wiener
	name = "raw wiener"
	icon_state = "raw_wiener"
	ingredient_size = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked/wiener
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked/wiener


/*	........   Fish sounds   ................ */
/obj/item/reagent_containers/food/snacks/fish
	chopping_sound = TRUE

/* ............. fisj chop ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/fish
	name = "fish filet"
	desc = "A filet of fish. All of them are the same inside."
	icon_state = "fish_filet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	slices_num = 1
	ingredient_size = 1

/* ............. Cabbit Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	name = "raw cabbit meat"
	icon_state = "cabbitcutlet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	slices_num = 1
	ingredient_size = 1

/* ............. Volf Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	name = "raw volf meat"
	icon_state = "volfstrip"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef		//Honestly, we don't need our own minced type on this one.
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
