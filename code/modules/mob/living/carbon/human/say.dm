/mob/living/carbon/human/say_mod(input, message_mode)
	var/rare_verb = LAZYLEN(dna.species.rare_say_mod) ? pick(dna.species.rare_say_mod) : null
	if (rare_verb && prob(dna.species.rare_say_mod[rare_verb]))
		verb_say = rare_verb
	else
		verb_say = dna.species.say_mod
	
	if(slurring)
		return "slurs"
	else
		. = ..()

/mob/living/carbon/human/GetVoice()
	if(istype(wear_mask, /obj/item/clothing/mask/chameleon))
		var/obj/item/clothing/mask/chameleon/V = wear_mask
		if(V.vchange && wear_id)
			var/obj/item/card/id/idcard = wear_id.GetID()
			if(istype(idcard))
				return idcard.registered_name
			else
				return real_name
		else
			return real_name
	if(istype(wear_mask, /obj/item/clothing/mask/gas/sechailer/swat/encrypted))
		return splittext(src.tag, "_")[2] // Voice name will show up as their tag numbers to match ID
	if(mind)
		var/datum/antagonist/changeling/changeling = mind.has_antag_datum(/datum/antagonist/changeling)
		if(changeling && changeling.mimicing )
			return changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/IsVocal()
	// how do species that don't breathe talk? magic, that's what.
	if(!HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT) && !getorganslot(ORGAN_SLOT_LUNGS))
		return FALSE
	if(mind)
		return !mind.miming
	return TRUE

/mob/living/carbon/human/proc/SetSpecialVoice(new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

/mob/living/carbon/human/binarycheck()
	. = FALSE
	var/obj/item/radio/headset/dongle
	if(istype(l_ear, /obj/item/radio/headset))
		dongle = l_ear
		if(dongle.translate_binary)
			. = TRUE

	if(istype(r_ear, /obj/item/radio/headset))
		dongle = r_ear
		if(dongle.translate_binary)
			. = TRUE

/mob/living/carbon/human/radio(message, list/message_mods = list(), list/spans, language) //Poly has a copy of this, lazy bastard
	. = ..()
	if(. != FALSE)
		return .

	if(message_mods[MODE_HEADSET])
		if(r_ear)
			r_ear.talk_into(src, message, , spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
		if(l_ear)
			l_ear.talk_into(src, message, , spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
	else if(message_mods[RADIO_EXTENSION] == MODE_DEPARTMENT)
		if(r_ear)
			r_ear.talk_into(src, message, message_mods[RADIO_EXTENSION], spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
		if(l_ear)
			l_ear.talk_into(src, message, message_mods[RADIO_EXTENSION], spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
	else if(GLOB.radiochannels[message_mods[RADIO_EXTENSION]])
		if(r_ear)
			r_ear.talk_into(src, message, message_mods[RADIO_EXTENSION], spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
		if(l_ear)
			l_ear.talk_into(src, message, message_mods[RADIO_EXTENSION], spans, language, message_mods)
			return ITALICS | REDUCE_RANGE
	return 0

/mob/living/carbon/human/get_alt_name()
	if(name != GetVoice())
		return " (as [get_id_name("Unknown")])"

/mob/living/carbon/human/proc/forcesay(list/append) //this proc is at the bottom of the file because quote fuckery makes notepad++ cri
	if(stat == CONSCIOUS)
		if(client)
			var/temp = winget(client, "input", "text")
			var/say_starter = "Say \"" //"
			if(findtextEx(temp, say_starter, 1, length(say_starter) + 1) && length(temp) > length(say_starter))	//case sensitive means

				temp = trim_left(copytext(temp, length(say_starter + 1)))
				temp = replacetext(temp, ";", "", 1, 2)	//general radio
				while(trim_left(temp)[1] == ":")	//dept radio again (necessary)
					temp = copytext_char(trim_left(temp), 3)

				if(temp[1] == "*")	//emotes
					return

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						trimmed += pick(append)

					say(trimmed)
				winset(client, "input", "text=[null]")
