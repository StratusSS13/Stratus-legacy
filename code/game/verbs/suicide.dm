/mob/var/suiciding = 0

/mob/living/carbon/human/proc/do_suicide(damagetype, byitem)
	var/threshold = (config.health_threshold_crit + config.health_threshold_dead) / 2
	var/dmgamt = maxHealth - threshold

	var/damage_mod = 1
	switch(damagetype) //Sorry about the magic numbers.
					   //brute = 1, burn = 2, tox = 4, oxy = 8
		if(15) //4 damage types
			damage_mod = 4

		if(6, 11, 13, 14) //3 damage types
			damage_mod = 3

		if(3, 5, 7, 9, 10, 12) //2 damage types
			damage_mod = 2

		if(1, 2, 4, 8) //1 damage type
			damage_mod = 1

		else //This should not happen, but if it does, everything should still work
			damage_mod = 1

	//Do dmgamt damage divided by the number of damage types applied.
	if(damagetype & BRUTELOSS)
		adjustBruteLoss(dmgamt / damage_mod)

	if(damagetype & FIRELOSS)
		adjustFireLoss(dmgamt / damage_mod)

	if(damagetype & TOXLOSS)
		adjustToxLoss(dmgamt / damage_mod)

	if(damagetype & OXYLOSS)
		adjustOxyLoss(dmgamt / damage_mod)

	// Failing that...
	if(!(damagetype & BRUTELOSS) && !(damagetype & FIRELOSS) && !(damagetype & TOXLOSS) && !(damagetype & OXYLOSS))
		if(species.flags & NO_BREATHE)
			// the ultimate fallback
			take_overall_damage(max(dmgamt - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0), 0)
		else
			adjustOxyLoss(max(dmgamt - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

	var/obj/item/organ/external/affected = get_organ("head")
	if(affected)
		affected.add_autopsy_data(byitem ? "Suicide by [byitem]" : "Suicide", dmgamt)

	updatehealth()

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1

	if(stat == 2)
		to_chat(src, "You're already dead!")
		return

	if(!ticker)
		to_chat(src, "You can't commit suicide before the game starts!")
		return

	if(suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		to_chat(viewers(loc), "<span class='danger'>[src]'s brain is growing dull and lifeless. It looks like it's lost the will to live.</span>")
		spawn(50)
			death(0)
			suiciding = 0


/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if(stat == 2)
		to_chat(src, "You're already dead!")
		return

	if(suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		to_chat(viewers(src), "<span class='danger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>")
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if(stat == 2)
		to_chat(src, "You're already dead!")
		return

	if(suiciding)
		to_chat(src, "You're already committing suicide! Be patient!")
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		to_chat(viewers(src), "<span class='danger'>[src] is powering down. It looks like \he's trying to commit suicide.</span>")
		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
	var/answer = input("REALLY kill yourself? This action can't be undone.", "Suicide", "No") in list ("Yes", "No")
	if(answer == "Yes")
		if(canmove || resting)
			close_up()
		var/obj/item/device/paicard/card = loc
		card.removePersonality()
		var/turf/T = get_turf_or_move(card.loc)
		for(var/mob/M in viewers(T))
			M.show_message("\blue [src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"", 3, "\blue [src] bleeps electronically.", 2)
		death(0, 1)
	else
		to_chat(src, "Aborting suicide attempt.")
