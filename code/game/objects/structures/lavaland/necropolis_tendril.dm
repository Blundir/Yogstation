//Necropolis Tendrils, which spawn lavaland monsters and break into a chasm when killed
/obj/structure/spawner/lavaland
	name = "necropolis tendril"
	desc = "A vile tendril of corruption, originating deep underground. Terrible monsters are pouring out of it."

	icon = 'icons/mob/nest.dmi'
	icon_state = "tendril"

	faction = list("mining")
	max_mobs = 3
	max_integrity = 250
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/tendril)

	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	anchored = TRUE
	resistance_flags = FIRE_PROOF | LAVA_PROOF

	//var/gps = null - yogs - removed tendril gps
	var/obj/effect/light_emitter/tendril/emitted_light


/obj/structure/spawner/lavaland/goliath
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast/tendril)

/obj/structure/spawner/lavaland/legion
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/hivelord/legion/tendril)

/obj/structure/spawner/lavaland/magmawing
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/magmawing/tendril)

/obj/structure/spawner/lavaland/icewatcher
	mob_types = list(/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/icewing)

GLOBAL_LIST_INIT(tendrils, list())
/obj/structure/spawner/lavaland/Initialize()
	. = ..()
	emitted_light = new(loc)
	for(var/F in RANGE_TURFS(1, src))
		if(ismineralturf(F))
			var/turf/closed/mineral/M = F
			M.ScrapeAway(null, CHANGETURF_IGNORE_AIR)
	//gps = new /obj/item/gps/internal(src) //yogs - lol
	GLOB.tendrils += src

/obj/structure/spawner/lavaland/deconstruct(disassembled)
	new /obj/effect/collapse(loc)
	new /obj/structure/closet/crate/necropolis/tendril(loc)
	return ..()


/obj/structure/spawner/lavaland/Destroy()
	GLOB.tendrils -= src
	QDEL_NULL(emitted_light)
	//QDEL_NULL(gps) //yogs - lol
	return ..()

/obj/effect/light_emitter/tendril
	set_luminosity = 4
	set_cap = 2.5
	light_color = LIGHT_COLOR_LAVA

/obj/effect/collapse
	name = "collapsing necropolis tendril"
	desc = "Get clear!"
	layer = TABLE_LAYER
	icon = 'icons/mob/nest.dmi'
	icon_state = "tendril"
	anchored = TRUE
	density = TRUE
	var/obj/effect/light_emitter/tendril/emitted_light

/obj/effect/collapse/Initialize()
	. = ..()
	emitted_light = new(loc)
	visible_message(span_boldannounce("The tendril writhes in fury as the earth around it begins to crack and break apart! Get back!"))
	visible_message(span_warning("Something falls free of the tendril!"))
	playsound(loc,'sound/effects/tendril_destroyed.ogg', 200, 0, 50, 1, 1)
	addtimer(CALLBACK(src, PROC_REF(collapse)), 50)

/obj/effect/collapse/Destroy()
	QDEL_NULL(emitted_light)
	return ..()

/obj/effect/collapse/proc/collapse()
	for(var/mob/M in range(7,src))
		shake_camera(M, 15, 1)
	playsound(get_turf(src),'sound/effects/explosionfar.ogg', 200, 1)
	visible_message(span_boldannounce("The tendril falls inward, the ground around it widening into a yawning chasm!"))
	for(var/turf/T in range(2,src))
		if(!T.density)
			T.TerraformTurf(/turf/open/chasm/lavaland, /turf/open/chasm/lavaland, flags = CHANGETURF_INHERIT_AIR)
	qdel(src)
