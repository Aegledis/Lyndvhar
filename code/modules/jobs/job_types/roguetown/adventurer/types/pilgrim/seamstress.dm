/datum/advclass/seamstress
	name = "Seamster"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/seamstress
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER, CTAG_ADVENTURER)

/datum/outfit/job/roguetown/adventurer/seamstress/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/suit/roguetown/armor/armordress
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltl = /obj/item/needle
	beltr = /obj/item/rogueweapon/huntingknife/scissors
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/natural/cloth = 2,
						/obj/item/natural/bundle/fibers/full = 1,
						/obj/item/flashlight/flare/torch = 1,
						)
	H.change_stat("intelligence", 2)
	H.change_stat("speed", 2)
	H.change_stat("perception", 1)
	H.change_stat("strength", -1)
