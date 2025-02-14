/obj/item/reagent_containers/dropper
	name = "dropper"
	desc = "A dropper. Holds up to 5 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1, 2, 3, 4, 5)
	volume = 5
	reagent_flags = TRANSPARENT
	drop_sound = 'dripstation/sound/drop/glass_small.ogg'
	pickup_sound = 'dripstation/sound/pickup/glass_small.ogg'	

/obj/item/reagent_containers/dropper/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(!target.reagents)
		return

	if(reagents.total_volume > 0)
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, span_notice("[target] is full."))
			return

		if(!target.is_injectable(user))
			to_chat(user, span_warning("You cannot transfer reagents to [target]!"))
			return

		var/trans = 0
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)

		if(ismob(target))
			if(ishuman(target))
				var/mob/living/carbon/human/victim = target

				var/obj/item/safe_thing = victim.is_eyes_covered()

				if(safe_thing)
					if(!safe_thing.reagents)
						safe_thing.create_reagents(100)

					reagents.reaction(safe_thing, TOUCH, fraction)
					trans = reagents.trans_to(safe_thing, amount_per_transfer_from_this, transfered_by = user)

					target.visible_message(span_danger("[user] tries to squirt something into [target]'s eyes, but fails!"), \
											span_userdanger("[user] tries to squirt something into [target]'s eyes, but fails!"))

					to_chat(user, span_notice("You transfer [trans] unit\s of the solution."))
					update_icon()
					return
			else if(isalien(target)) //hiss-hiss has no eyes!
				to_chat(target, span_danger("[target] does not seem to have any eyes!"))
				return

			target.visible_message(span_danger("[user] squirts something into [target]'s eyes!"), \
									span_userdanger("[user] squirts something into [target]'s eyes!"))

			reagents.reaction(target, TOUCH, fraction)
			var/mob/M = target
			var/R
			var/viruslist = "" // yogs - adds viruslist variable
			if(reagents)
				for(var/datum/reagent/A in src.reagents.reagent_list)
					R += "[A] ([num2text(A.volume)]),"
// yogs start - checks blood for disease
					if(istype(A, /datum/reagent/blood))
						var/datum/reagent/blood/RR = A
						for(var/datum/disease/D in RR.data["viruses"])
							viruslist += " [D.name]"
							if(istype(D, /datum/disease/advance))
								var/datum/disease/advance/DD = D
								viruslist += " \[ symptoms: "
								for(var/datum/symptom/S in DD.symptoms)
									viruslist += "[S.name] "
								viruslist += "\]"
// yogs end
			log_combat(user, M, "squirted", R)

// yogs start - Adds logs if it is viruslist
			if(viruslist)
				investigate_log("[user.real_name] ([user.ckey]) injected [M.real_name] ([M.ckey]) using a projectile with [viruslist]", INVESTIGATE_VIROLOGY)
				log_game("[user.real_name] ([user.ckey]) injected [M.real_name] ([M.ckey]) with [viruslist]")
// yogs end

		trans = src.reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("You transfer [trans] unit\s of the solution."))
		update_icon()

	else

		if(!target.is_drawable(user, FALSE)) //No drawing from mobs here
			to_chat(user, span_notice("You cannot directly remove reagents from [target]."))
			return

		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] is empty!"))
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)

		to_chat(user, span_notice("You fill [src] with [trans] unit\s of the solution."))

		update_icon()

/obj/item/reagent_containers/dropper/update_icon()
	cut_overlays()
	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "dropper")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		add_overlay(filling)
