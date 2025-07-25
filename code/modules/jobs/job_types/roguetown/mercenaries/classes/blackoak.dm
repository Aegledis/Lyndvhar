// Eleven unique mercenary type; should be scary in a way solo but easy to kill with a group or bow.
/datum/advclass/mercenary/blackoak
	name = "Black Oak's Guardian"
	tutorial = "A mercenary of the Black Oaks. Half mercenary band, half irregular militia fighting for control against the orc hordes in the name of Greencrest nobility. You are one of the few not doing so- on mercenary employ in Lyndvhar. Your only worry is if the civil war will find its way to the city gates with you in it."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
	)
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_OUTLANDER)

/datum/outfit/job/roguetown/mercenary/blackoak/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	cloak = /obj/item/clothing/cloak/half/red
	head = /obj/item/clothing/head/roguetown/helmet/sallet/elven
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/black
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/elven
	backl = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/halberd/bardiche
	beltl = /obj/item/rogueweapon/huntingknife/idagger
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/tights/random
	neck = /obj/item/clothing/neck/roguetown/gorget
	backr = /obj/item/gwstrap
	backpack_contents = list(/obj/item/roguekey/mercenary, /obj/item/storage/belt/rogue/pouch/coins/poor, /obj/item/clothing/neck/roguetown/mercmedal/blackoak)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
		H.change_stat("endurance", 2)
		H.change_stat("constitution", 2)
		H.change_stat("strength", 1)
		H.change_stat("speed", 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

