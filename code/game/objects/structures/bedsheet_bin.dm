/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/bedsheet_righthand.dmi'
	mob_overlay_icon = 'icons/mob/clothing/neck/sheets.dmi'
	icon_state = "sheetwhite"
	item_state = "sheetwhite"
	slot_flags = ITEM_SLOT_NECK
	layer = MOB_LAYER
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET
	var/newbedpath = null

	dog_fashion = /datum/dog_fashion/head/ghost
	var/list/dream_messages = list("white")

/obj/item/bedsheet/attack(mob/living/M, mob/user)
	if(!attempt_initiate_surgery(src, M, user))
		..()

/obj/item/bedsheet/attack_self(mob/user)
	if(newbedpath)
		var/obj/item/bedsheet/sheet = new newbedpath(drop_location())
		if(sheet)
			sheet.name = name
			sheet.icon_state = icon_state
			sheet.item_state = item_state
			sheet.dream_messages = dream_messages
			qdel(src)
			user.put_in_active_hand(sheet)
			to_chat(user, span_notice("You adjust the bedsheet to be worn on your head!"))
	else
		to_chat(user, span_notice("You cannot adjust this bedsheet!"))

/obj/item/bedsheet/AltClick(mob/user)
	if(!user.CanReach(src))		//No telekenetic grabbing.
		return
	if(!user.dropItemToGround(src))
		return
	if(layer == initial(layer))
		layer = ABOVE_MOB_LAYER
		to_chat(user, span_notice("You cover yourself with [src]."))
	else
		layer = initial(layer)
		to_chat(user, span_notice("You smooth [src] out beneath you."))
	add_fingerprint(user)
	return

/obj/item/bedsheet/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.is_sharp())
		// yogs start - disable infinite holocloth
		to_chat(user, span_notice("You tear [src] up."))
		if(flags_1 & HOLOGRAM_1)
			qdel(src)
			return
		var/obj/item/stack/sheet/cloth/C = new (get_turf(src), 3)
		transfer_fingerprints_to(C)
		C.add_fingerprint(user)
		qdel(src)
		// yogs end
	else
		return ..()

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	item_state = "sheetblue"
	dream_messages = list("blue")
	newbedpath = /obj/item/bedsheet/adjusted/blue

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	item_state = "sheetgreen"
	dream_messages = list("green")
	newbedpath = /obj/item/bedsheet/adjusted/green

/obj/item/bedsheet/grey
	icon_state = "sheetgrey"
	item_state = "sheetgrey"
	dream_messages = list("grey")

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	item_state = "sheetorange"
	dream_messages = list("orange")
	newbedpath = /obj/item/bedsheet/adjusted/orange

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	item_state = "sheetpurple"
	dream_messages = list("purple")
	newbedpath = /obj/item/bedsheet/adjusted/purple

/obj/item/bedsheet/patriot
	name = "patriotic bedsheet"
	desc = "You've never felt more free than when sleeping on this."
	icon_state = "sheetUSA"
	item_state = "sheetUSA"
	dream_messages = list("America", "freedom", "fireworks", "bald eagles")

/obj/item/bedsheet/rainbow
	name = "rainbow bedsheet"
	desc = "A multicolored blanket. It's actually several different sheets cut up and sewn together."
	icon_state = "sheetrainbow"
	item_state = "sheetrainbow"
	dream_messages = list("red", "orange", "yellow", "green", "blue", "purple", "a rainbow")
	newbedpath = /obj/item/bedsheet/adjusted/rainbow

/obj/item/bedsheet/red
	icon_state = "sheetred"
	item_state = "sheetred"
	dream_messages = list("red")
	newbedpath = /obj/item/bedsheet/adjusted/red

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	item_state = "sheetyellow"
	dream_messages = list("yellow")
	newbedpath = /obj/item/bedsheet/adjusted/yellow

/obj/item/bedsheet/mime
	name = "mime's blanket"
	desc = "A very soothing striped blanket.  All the noise just seems to fade out when you're under the covers in this."
	icon_state = "sheetmime"
	item_state = "sheetmime"
	dream_messages = list("silence", "gestures", "a pale face", "a gaping mouth", "the mime")
	newbedpath = /obj/item/bedsheet/adjusted/mime

/obj/item/bedsheet/clown
	name = "clown's blanket"
	desc = "A rainbow blanket with a clown mask woven in. It smells faintly of bananas."
	icon_state = "sheetclown"
	item_state = "sheetrainbow"
	dream_messages = list("honk", "laughter", "a prank", "a joke", "a smiling face", "the clown")
	newbedpath = /obj/item/bedsheet/adjusted/clown

/obj/item/bedsheet/captain
	name = "captain's bedsheet"
	desc = "It has a Nanotrasen symbol on it, and was woven with a revolutionary new kind of thread guaranteed to have 0.01% permeability for most non-chemical substances, popular among most modern captains."
	icon_state = "sheetcaptain"
	item_state = "sheetcaptain"
	dream_messages = list("authority", "a golden ID", "sunglasses", "a green disc", "an antique gun", "the captain")
	newbedpath = /obj/item/bedsheet/adjusted/captain

/obj/item/bedsheet/rd
	name = "research director's bedsheet"
	desc = "It appears to have a beaker emblem, and is made out of fire-resistant material, although it probably won't protect you in the event of fires you're familiar with every day."
	icon_state = "sheetrd"
	item_state = "sheetrd"
	dream_messages = list("authority", "a silvery ID", "a bomb", "a mech", "a facehugger", "maniacal laughter", "the research director")
	newbedpath = /obj/item/bedsheet/adjusted/rd

// for Free Golems.
/obj/item/bedsheet/rd/royal_cape
	name = "Royal Cape of the Liberator"
	desc = "Majestic."
	dream_messages = list("mining", "stone", "a golem", "freedom", "doing whatever")

/obj/item/bedsheet/medical
	name = "medical blanket"
	desc = "It's a sterilized* blanket commonly used in the Medbay.  *Sterilization is voided if a virologist is present onboard the station."
	icon_state = "sheetmedical"
	item_state = "sheetmedical"
	dream_messages = list("healing", "life", "surgery", "a doctor")
	newbedpath = /obj/item/bedsheet/adjusted/medical

/obj/item/bedsheet/cmo
	name = "chief medical officer's bedsheet"
	desc = "It's a sterilized blanket that has a cross emblem. There's some cat fur on it, likely from Runtime."
	icon_state = "sheetcmo"
	item_state = "sheetcmo"
	dream_messages = list("authority", "a silvery ID", "healing", "life", "surgery", "a cat", "the chief medical officer")

/obj/item/bedsheet/hos
	name = "head of security's bedsheet"
	desc = "It is decorated with a shield emblem. While crime doesn't sleep, you do, but you are still THE LAW!"
	icon_state = "sheethos"
	item_state = "sheethos"
	dream_messages = list("authority", "a silvery ID", "handcuffs", "a baton", "a flashbang", "sunglasses", "the head of security")
	newbedpath = /obj/item/bedsheet/adjusted/hos

/obj/item/bedsheet/hop
	name = "head of personnel's bedsheet"
	desc = "It is decorated with a key emblem. For those rare moments when you can rest and cuddle with Ian without someone screaming for you over the radio."
	icon_state = "sheethop"
	item_state = "sheethop"
	dream_messages = list("authority", "a silvery ID", "obligation", "a computer", "an ID", "a corgi", "the head of personnel")
	newbedpath = /obj/item/bedsheet/adjusted/hop

/obj/item/bedsheet/ce
	name = "chief engineer's bedsheet"
	desc = "It is decorated with a wrench emblem. It's highly reflective and stain resistant, so you don't need to worry about ruining it with oil."
	icon_state = "sheetce"
	item_state = "sheetce"
	dream_messages = list("authority", "a silvery ID", "the engine", "power tools", "an APC", "a parrot", "the chief engineer")
	newbedpath = /obj/item/bedsheet/adjusted/ce

/obj/item/bedsheet/qm
	name = "quartermaster's bedsheet"
	desc = "It is decorated with a crate emblem in silver lining.  It's rather tough, and just the thing to lie on after a hard day of pushing paper."
	icon_state = "sheetqm"
	item_state = "sheetqm"
	dream_messages = list("a brown card", "a shuttle", "a crate", "a sloth", "the quartermaster")

/obj/item/bedsheet/chap
	name = "chaplain's blanket"
	desc = "A blanket woven with the hearts of gods themselves... Wait, that's just linen."
	icon_state = "sheetchap"
	item_state = "sheetchap"
	dream_messages = list("a grey ID", "the gods", "a fulfilled prayer", "a cult", "the chaplain", "an inquisition", "a crusade", "xeno scum")

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	item_state = "sheetbrown"
	dream_messages = list("brown")
	newbedpath = /obj/item/bedsheet/adjusted/brown

/obj/item/bedsheet/black
	icon_state = "sheetblack"
	item_state = "sheetblack"
	dream_messages = list("black")

/obj/item/bedsheet/centcom
	name = "\improper CentCom bedsheet"
	desc = "Woven with advanced nanothread for warmth as well as being very decorated, essential for all officials."
	icon_state = "sheetcentcom"
	item_state = "sheetcentcom"
	dream_messages = list("a unique ID", "authority", "artillery", "an ending")

/obj/item/bedsheet/syndie
	name = "syndicate bedsheet"
	desc = "It has a syndicate emblem and it has an aura of evil."
	icon_state = "sheetsyndie"
	item_state = "sheetsyndie"
	dream_messages = list("a green disc", "a red crystal", "a glowing blade", "a wire-covered ID")

/obj/item/bedsheet/cult
	name = "cultist's bedsheet"
	desc = "You might dream of Nar'sie if you sleep with this. It seems rather tattered and glows of an eldritch presence."
	icon_state = "sheetcult"
	item_state = "sheetcult"
	dream_messages = list("a tome", "a floating red crystal", "a glowing sword", "a bloody symbol", "a massive humanoid figure")

/obj/item/bedsheet/wiz
	name = "wizard's bedsheet"
	desc = "A special fabric enchanted with magic so you can have an enchanted night. It even glows!"
	icon_state = "sheetwiz"
	item_state = "sheetwiz"
	dream_messages = list("a book", "an explosion", "lightning", "a staff", "a skeleton", "a robe", "magic")

/obj/item/bedsheet/nanotrasen
	name = "nanotrasen bedsheet"
	desc = "It has the Nanotrasen logo on it and has an aura of duty."
	icon_state = "sheetNT"
	item_state = "sheetNT"
	dream_messages = list("authority", "an ending")

/obj/item/bedsheet/ian
	icon_state = "sheetian"
	item_state = "sheetian"
	dream_messages = list("a dog", "a corgi", "woof", "bark", "arf")

/obj/item/bedsheet/cosmos
	name = "cosmic space bedsheet"
	desc = "Made from the dreams of those who wonder at the stars."
	icon_state = "sheetcosmos"
	item_state = "sheetcosmos"
	dream_messages = list("the infinite cosmos", "Hans Zimmer music", "a flight through space", "the galaxy", "being fabulous", "shooting stars")
	light_power = 2
	light_range = 1.4

/obj/item/bedsheet/random
	icon_state = "random_bedsheet"
	name = "random bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"

/obj/item/bedsheet/random/Initialize()
	..()
	var/type = pick(typesof(/obj/item/bedsheet) - /obj/item/bedsheet/random)
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/bedsheet/dorms
	icon_state = "random_bedsheet"
	name = "random dorms bedsheet"
	desc = "If you're reading this description ingame, something has gone wrong! Honk!"

/obj/item/bedsheet/dorms/Initialize()
	..()
	var/type = pickweight(list("Colors" = 80, "Special" = 20))
	switch(type)
		if("Colors")
			type = pick(list(/obj/item/bedsheet,
				/obj/item/bedsheet/blue,
				/obj/item/bedsheet/green,
				/obj/item/bedsheet/grey,
				/obj/item/bedsheet/orange,
				/obj/item/bedsheet/purple,
				/obj/item/bedsheet/red,
				/obj/item/bedsheet/yellow,
				/obj/item/bedsheet/brown,
				/obj/item/bedsheet/black))
		if("Special")
			type = pick(list(/obj/item/bedsheet/patriot,
				/obj/item/bedsheet/rainbow,
				/obj/item/bedsheet/ian,
				/obj/item/bedsheet/cosmos,
				/obj/item/bedsheet/nanotrasen))
	new type(loc)
	return INITIALIZE_HINT_QDEL

/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 70
	var/amount = 10
	var/list/sheets = list()
	var/obj/item/hidden = null

/obj/structure/bedsheetbin/empty
	amount = 0
	icon_state = "linenbin-empty"
	anchored = FALSE


/obj/structure/bedsheetbin/examine(mob/user)
	. = ..()
	if(amount < 1)
		. += "There are no bed sheets in the bin."
	else if(amount == 1)
		. += "There is one bed sheet in the bin."
	else
		. += "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon()
	switch(amount)
		if(0)
			icon_state = "linenbin-empty"
		if(1 to 5)
			icon_state = "linenbin-half"
		else
			icon_state = "linenbin-full"

/obj/structure/bedsheetbin/fire_act(exposed_temperature, exposed_volume)
	if(amount)
		amount = 0
		update_icon()
	..()

/obj/structure/bedsheetbin/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/bedsheet))
		if(!user.transferItemToLoc(I, src))
			return
		sheets.Add(I)
		amount++
		to_chat(user, span_notice("You put [I] in [src]."))
		update_icon()

	else if(default_unfasten_wrench(user, I, 5))
		return

	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(flags_1 & NODECONSTRUCT_1)
			return
		if(amount)
			to_chat(user, "<span clas='warn'>The [src] must be empty first!</span>")
			return
		if(I.use_tool(src, user, 5, volume=50))
			to_chat(user, "<span clas='notice'>You disassemble the [src].</span>")
			new /obj/item/stack/rods(loc, 2)
			qdel(src)

	else if(amount && !hidden && I.w_class < WEIGHT_CLASS_BULKY)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("\The [I] is stuck to your hand, you cannot hide it among the sheets!"))
			return
		hidden = I
		to_chat(user, span_notice("You hide [I] among the sheets."))


/obj/structure/bedsheetbin/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bedsheetbin/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(drop_location())
		user.put_in_hands(B)
		to_chat(user, span_notice("You take [B] out of [src]."))
		update_icon()

		if(hidden)
			hidden.forceMove(drop_location())
			to_chat(user, span_notice("[hidden] falls out of [B]!"))
			hidden = null


	add_fingerprint(user)
/obj/structure/bedsheetbin/attack_tk(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(drop_location())
		to_chat(user, span_notice("You telekinetically remove [B] from [src]."))
		update_icon()

		if(hidden)
			hidden.forceMove(drop_location())
			hidden = null


	add_fingerprint(user)

/obj/item/bedsheet/adjusted
	slot_flags = ITEM_SLOT_HEAD
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEGLOVES|HIDEJUMPSUIT|HIDENECK|HIDEFACIALHAIR|HIDESUITSTORAGE
	body_parts_covered = CHEST|LEGS|FEET|ARMS|HANDS|HEAD
	flags_cover = MASKCOVERSEYES|MASKCOVERSMOUTH|HEADCOVERSMOUTH
	var/oldbedpath = null

/obj/item/bedsheet/adjusted/attack_self(mob/user)
	if(oldbedpath)
		var/obj/item/bedsheet/sheet = new oldbedpath(drop_location())
		if(sheet)
			qdel(src)
			user.put_in_active_hand(sheet)
			to_chat(user, span_notice("You adjust the bedsheet to be worn on your neck!"))
	else
		to_chat(user, span_notice("You cannot adjust this bedsheet!"))

/obj/item/bedsheet/adjusted/blue
	oldbedpath = /obj/item/bedsheet/blue

/obj/item/bedsheet/adjusted/green
	oldbedpath = /obj/item/bedsheet/green

/obj/item/bedsheet/adjusted/grey
	oldbedpath = /obj/item/bedsheet/grey

/obj/item/bedsheet/adjusted/orange
	oldbedpath = /obj/item/bedsheet/orange

/obj/item/bedsheet/adjusted/purple
	oldbedpath = /obj/item/bedsheet/purple

/obj/item/bedsheet/adjusted/rainbow
	oldbedpath = /obj/item/bedsheet/rainbow

/obj/item/bedsheet/adjusted/red
	oldbedpath = /obj/item/bedsheet/red

/obj/item/bedsheet/adjusted/yellow
	oldbedpath = /obj/item/bedsheet/yellow

/obj/item/bedsheet/adjusted/mime
	oldbedpath = /obj/item/bedsheet/mime

/obj/item/bedsheet/adjusted/clown
	oldbedpath = /obj/item/bedsheet/clown

/obj/item/bedsheet/adjusted/captain
	oldbedpath = /obj/item/bedsheet/captain

/obj/item/bedsheet/adjusted/rd
	oldbedpath = /obj/item/bedsheet/rd

/obj/item/bedsheet/adjusted/medical
	oldbedpath = /obj/item/bedsheet/medical

/obj/item/bedsheet/adjusted/hos
	oldbedpath = /obj/item/bedsheet/hos

/obj/item/bedsheet/adjusted/hop
	oldbedpath = /obj/item/bedsheet/hop

/obj/item/bedsheet/adjusted/ce
	oldbedpath = /obj/item/bedsheet/ce

/obj/item/bedsheet/adjusted/brown
	oldbedpath = /obj/item/bedsheet/brown
