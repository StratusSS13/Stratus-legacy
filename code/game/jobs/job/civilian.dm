/datum/job/visitor
	title = "Visitor"
	flag = VISITOR
	department_flag = SUPPORT
	total_positions = -1
	spawn_positions = -1
	supervisors = "the head of personnel"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/visitor/get_access()
	minimal_access = list()	//See /datum/job/visitor/get_access()

/datum/job/visitor/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	switch(H.backbag)
		if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack(H), slot_back)
		if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
		if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
	H.equip_or_collect(new /obj/item/clothing/under/color/random(H), slot_w_uniform)
	H.equip_or_collect(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_or_collect(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
	return 1

/datum/job/visitor/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	department_flag = KARMA
	total_positions = 2
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#fff5cc"
	idtype = /obj/item/weapon/card/id
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_mechanic, access_external_airlocks, access_mineral_storeroom)
	minimal_access = list(access_maint_tunnels, access_emergency_storage, access_mechanic, access_external_airlocks, access_mineral_storeroom, access_eva, access_gateway)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/rank/mechanic(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_or_collect(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		H.equip_or_collect(new /obj/item/clothing/head/hardhat(H), slot_head)
		H.equip_or_collect(new /obj/item/device/t_scanner(H), slot_r_store)
		H.equip_or_collect(new /obj/item/device/pda(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/weapon/storage/box/engineer(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/pod_paint_bucket(H), slot_in_backpack)
		return 1
