/obj/machinery/vending/security
	name = "\improper SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	icon_vend = "sec-vend"	
	req_access = list(ACCESS_SECURITY)
	products = list(/obj/item/clothing/head/helmet/plated = 6,
					/obj/item/clothing/suit/armor/plated = 6,
					/obj/item/restraints/handcuffs = 8,
					/obj/item/restraints/handcuffs/cable/zipties = 10,
					/obj/item/grenade/flashbang = 4,
					/obj/item/assembly/flash/handheld = 5,
					/obj/item/reagent_containers/food/snacks/donut = 12,
					/obj/item/storage/box/evidence = 6,
					/obj/item/flashlight/seclite = 4,
					/obj/item/restraints/legcuffs/bola/energy = 7)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,
					  /obj/item/storage/box/fancy/donut_box = 2)
	premium = list(/obj/item/storage/belt/security/webbing = 5,
				   /obj/item/coin/antagtoken = 1,
				   /obj/item/clothing/head/helmet/warhelmet = 5,
				   /obj/item/clothing/suit/armor/vest/rycliesarmour = 5,
				   /obj/item/clothing/head/helmet/blueshirt = 5,
				   /obj/item/clothing/suit/armor/vest/blueshirt = 5)
	refill_canister = /obj/item/vending_refill/security
	default_price = 100
	extra_price = 150
	payment_department = ACCOUNT_SEC
	light_mask = "sec-light-mask"	

/obj/machinery/vending/security/pre_throw(obj/item/I)
	if(istype(I, /obj/item/grenade))
		var/obj/item/grenade/G = I
		G.preprime()
	else if(istype(I, /obj/item/flashlight))
		var/obj/item/flashlight/F = I
		F.on = TRUE
		F.update_brightness()

/obj/item/vending_refill/security
	icon_state = "refill_sec"
