
/*
//////////////////////////////////////
Narcolepsy
	Noticeable.
	Lowers resistance
	Decreases stage speed tremendously.
	Decreases transmittablity tremendously.

Bonus
	Causes drowsiness and sleep.

//////////////////////////////////////
*/
/datum/symptom/narcolepsy
	name = "Narcolepsy"
	desc = "The virus causes a hormone imbalance, making the host sleepy and narcoleptic."
	stealth = -1
	resistance = -2
	stage_speed = -3
	transmittable = -4
	level = 6
	symptom_delay_min = 15
	symptom_delay_max = 80
	severity = 4
	var/sleep_level = 0
	var/sleepy_ticks = 0
	var/stamina = FALSE
	threshold_descs = list(
		"Transmission 7" = "Also relaxes the muscles, weakening and slowing the host.",
		"Resistance 10" = "Causes narcolepsy more often, increasing the chance of the host falling asleep",
	)

/datum/symptom/narcolepsy/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalTransmittable() >= 7) //stamina damage
		stamina = TRUE
	if(A.totalResistance() >= 10) //act more often
		symptom_delay_min = 10
		symptom_delay_max = 60

/datum/symptom/narcolepsy/Activate(var/datum/disease/advance/A)
	var/mob/living/M = A.affected_mob
	//this ticks even when on cooldown
	switch(sleep_level) //Works sorta like morphine
		if(10 to 19)
			M.adjust_drowsiness(2 SECONDS)
		if(20 to INFINITY)
			M.Sleeping(30, 0)
			sleep_level = 0
			sleepy_ticks = 0

	if(sleepy_ticks && A.stage>=5)
		sleep_level++
		sleepy_ticks--
	else
		sleep_level = 0

	. = ..()
	if(!.)
		return

	switch(A.stage)
		if(1)
			if(prob(10))
				to_chat(M, span_warning("You feel tired."))
		if(2)
			if(prob(10))
				to_chat(M, span_warning("You feel very tired."))
				sleepy_ticks += rand(10,14)
				if(stamina)
					M.adjustStaminaLoss(10)
		if(3)
			if(prob(15))
				to_chat(M, span_warning("You try to focus on staying awake."))
				sleepy_ticks += rand(10,14)
				if(stamina)
					M.adjustStaminaLoss(15)
		if(4)
			if(prob(20))
				to_chat(M, span_warning("You nod off for a moment."))
				sleepy_ticks += rand(10,14)
				if(stamina)
					M.adjustStaminaLoss(20)
		if(5)
			if(prob(25))
				to_chat(M, span_warning("[pick("So tired...","You feel very sleepy.","You have a hard time keeping your eyes open.","You try to stay awake.")]"))
				M.adjust_drowsiness(rand(14, 7) SECONDS)
				sleepy_ticks += rand(10,14)
				if(stamina)
					M.adjustStaminaLoss(30)




