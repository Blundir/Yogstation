/obj/vehicle/sealed/car/clowncar
	name = "clown car"
	desc = "How someone could even fit in there is beyond me."
	icon_state = "clowncar"
	max_integrity = 150
	armor = list(MELEE = 70, BULLET = 40, LASER = 40, ENERGY = 0, BOMB = 30, BIO = 0, RAD = 0, FIRE = 80, ACID = 80)
	enter_delay = 20
	max_occupants = 50
	movedelay = 0.6
	car_traits = CAN_KIDNAP
	key_type = /obj/item/bikehorn
	key_type_exact = FALSE
	var/droppingoil = FALSE
	var/RTDcooldown = 150
	var/lastRTDtime = 0
	var/thankscount
	var/cannonmode = FALSE
	var/cannonbusy = FALSE

/obj/vehicle/sealed/car/clowncar/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/sealed/horn/clowncar, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/Thank, VEHICLE_CONTROL_KIDNAPPED)

/obj/vehicle/sealed/car/clowncar/auto_assign_occupant_flags(mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.mind && H.mind.assigned_role == "Clown") //Ensures only clowns can drive the car. (Including more at once)
			add_control_flags(H, VEHICLE_CONTROL_DRIVE|VEHICLE_CONTROL_PERMISSION)
			RegisterSignal(H, COMSIG_MOB_CLICKON, PROC_REF(FireCannon))
			return
	add_control_flags(M, VEHICLE_CONTROL_KIDNAPPED)

/obj/vehicle/sealed/car/clowncar/mob_forced_enter(mob/M, silent = FALSE)
	. = ..()
	playsound(src, pick('sound/vehicles/clowncar_load1.ogg', 'sound/vehicles/clowncar_load2.ogg'), 75)

/obj/vehicle/sealed/car/clowncar/attack_animal(mob/living/simple_animal/M)
	if((M.loc != src) || M.environment_smash & (ENVIRONMENT_SMASH_WALLS|ENVIRONMENT_SMASH_RWALLS))
		return ..()

/obj/vehicle/sealed/car/clowncar/mob_exit(mob/M, silent = FALSE, randomstep = FALSE)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_CLICKON)

/obj/vehicle/sealed/car/clowncar/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(prob(33))
		visible_message(span_danger("[src] spews out a ton of space lube!"))
		var/datum/effect_system/fluid_spread/foam/foam = new
		var/datum/reagents/foamreagent = new /datum/reagents(25)
		foamreagent.add_reagent(/datum/reagent/lube, 25)
		foam.set_up(4, holder = src, location = loc, carry = foamreagent)
		foam.start()

/obj/vehicle/sealed/car/clowncar/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/banana))
		var/obj/item/reagent_containers/food/snacks/grown/banana/banana = I
		obj_integrity += min(banana.seed.potency, max_integrity-obj_integrity)
		to_chat(user, span_danger("You use the [banana] to repair the [src]!"))
		qdel(banana)

/obj/vehicle/sealed/car/clowncar/Bump(atom/A)
	. = ..()
	if(isliving(A))
		if(ismegafauna(A))
			return
		var/mob/living/L = A
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			C.Paralyze(40) //I play to make sprites go horizontal
		L.visible_message(span_warning("[src] rams into [L] and sucks him up!")) //fuck off shezza this isn't ERP.
		mob_forced_enter(L)
		playsound(src, pick('sound/vehicles/clowncar_ram1.ogg', 'sound/vehicles/clowncar_ram2.ogg', 'sound/vehicles/clowncar_ram3.ogg'), 75)
		log_combat(src, A, "sucked up")
	else if(istype(A, /turf/closed))
		visible_message(span_warning("[src] rams into [A] and crashes!"))
		playsound(src, pick('sound/vehicles/clowncar_crash1.ogg', 'sound/vehicles/clowncar_crash2.ogg'), 75)
		playsound(src, 'sound/vehicles/clowncar_crashpins.ogg', 75)
		DumpMobs(TRUE)
		log_combat(src, A, "crashed into", null, "dumping all passengers")

/obj/vehicle/sealed/car/clowncar/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, span_danger("You scramble the clowncar child safety lock and a panel with 6 colorful buttons appears!"))
	initialize_controller_action_type(/datum/action/vehicle/sealed/RollTheDice, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/Cannon, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/sealed/car/clowncar/Destroy()
  playsound(src, 'sound/vehicles/clowncar_fart.ogg', 100)
  return ..()

/obj/vehicle/sealed/car/clowncar/after_move(direction)
	. = ..()
	if(droppingoil)
		new /obj/effect/decal/cleanable/oil/slippery(loc)

/obj/vehicle/sealed/car/clowncar/proc/RollTheDice(mob/user)
	if(world.time - lastRTDtime < RTDcooldown)
		to_chat(user, span_notice("The button panel is currently recharging."))
		return
	lastRTDtime = world.time
	var/randomnum = rand(1,6)
	switch(randomnum)
		if(1)
			visible_message(span_danger("[user] has pressed one of the colorful buttons on [src] and a special banana peel drops out of it."))
			new /obj/item/grown/bananapeel/specialpeel(loc)
		if(2)
			visible_message(span_danger("[user] has pressed one of the colorful buttons on [src] and unknown chemicals flood out of it."))
			var/datum/reagents/tmp_holder = new/datum/reagents(300)
			tmp_holder.my_atom = src
			tmp_holder.add_reagent(get_random_reagent_id(), 100)
			var/datum/effect_system/fluid_spread/foam/short/foam = new
			foam.set_up(4, location = loc, carry = tmp_holder)
			foam.start()
		if(3)
			visible_message(span_danger("[user] has pressed one of the colorful buttons on [src] and the clown car turns on its singularity disguise system."))
			icon = 'icons/obj/singularity.dmi'
			icon_state = "singularity_s1"
			addtimer(CALLBACK(src, PROC_REF(ResetIcon)), 100)
		if(4)
			visible_message(span_danger("[user] has pressed one of the colorful buttons on [src] and the clown car spews out a cloud of laughing gas."))
			var/datum/reagents/tmp_holder = new/datum/reagents(300)
			tmp_holder.my_atom = src
			tmp_holder.add_reagent(/datum/reagent/consumable/superlaughter, 50)
			var/datum/effect_system/fluid_spread/smoke/chem/smoke = new()
			smoke.set_up(4, location = loc, carry = tmp_holder)
			smoke.attach(src)
			smoke.start()
		if(5)
			visible_message(span_danger("[user] has pressed one of the colorful buttons on [src] and the clown car starts dropping an oil trail."))
			droppingoil = TRUE
			addtimer(CALLBACK(src, PROC_REF(StopDroppingOil)), 30)
		if(6)
			visible_message(span_danger("[user] has pressed one of the colorful buttons on [src] and the clown car lets out a comedic toot."))
			playsound(src, 'sound/vehicles/clowncar_fart.ogg', 100)
			for(var/mob/living/L in orange(loc, 6))
				L.emote("laughs")
			for(var/mob/living/L in occupants)
				L.emote("laughs")

/obj/vehicle/sealed/car/clowncar/proc/ResetIcon()
	icon = initial(icon)
	icon_state = initial(icon_state)

/obj/vehicle/sealed/car/clowncar/proc/StopDroppingOil()
	droppingoil = FALSE

/obj/vehicle/sealed/car/clowncar/proc/ToggleCannon()
	cannonbusy = TRUE
	if(cannonmode)
		cannonmode = FALSE
		flick("clowncar_fromfire", src)
		icon_state = "clowncar"
		addtimer(CALLBACK(src, PROC_REF(LeaveCannonMode)), 20)
		playsound(src, 'sound/vehicles/clowncar_cannonmode2.ogg', 75)
		visible_message(span_danger("The [src] starts going back into mobile mode."))
	else
		canmove = FALSE
		flick("clowncar_tofire", src)
		icon_state = "clowncar_fire"
		visible_message(span_danger("The [src] opens up and reveals a large cannon."))
		addtimer(CALLBACK(src, PROC_REF(EnterCannonMode)), 20)
		playsound(src, 'sound/vehicles/clowncar_cannonmode1.ogg', 75)


/obj/vehicle/sealed/car/clowncar/proc/EnterCannonMode()
	mouse_pointer = 'icons/mecha/mecha_mouse.dmi'
	cannonmode = TRUE
	cannonbusy = FALSE
	for(var/mob/living/L in return_controllers_with_flag(VEHICLE_CONTROL_DRIVE))
		L.update_mouse_pointer()

/obj/vehicle/sealed/car/clowncar/proc/LeaveCannonMode()
	canmove = TRUE
	cannonbusy = FALSE
	mouse_pointer = null
	for(var/mob/living/L in return_controllers_with_flag(VEHICLE_CONTROL_DRIVE))
		L.update_mouse_pointer()

/obj/vehicle/sealed/car/clowncar/proc/FireCannon(mob/user, atom/A, params)
	if(cannonmode && return_controllers_with_flag(VEHICLE_CONTROL_KIDNAPPED).len)
		var/mob/living/L = pick(return_controllers_with_flag(VEHICLE_CONTROL_KIDNAPPED))
		mob_exit(L, TRUE)
		flick("clowncar_recoil", src)
		playsound(src, pick('sound/vehicles/carcannon1.ogg', 'sound/vehicles/carcannon2.ogg', 'sound/vehicles/carcannon3.ogg'), 75)
		L.throw_at(A, 10, 2)
		return COMSIG_MOB_CANCEL_CLICKON
