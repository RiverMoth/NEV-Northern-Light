/obj/item/weapon/implant/uplink
	name = "uplink"
	desc = "Summon things."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_COVERT = 3)
	var/activation_emote

/obj/item/weapon/implant/uplink/New(var/loc, var/amount)
	amount = amount || IMPLANT_TELECRYSTAL_AMOUNT(DEFAULT_TELECRYSTAL_AMOUNT)
	hidden_uplink = new(src, telecrystals = amount)
	..()

/obj/item/weapon/implant/uplink/on_install(mob/source)
	var/emote_options = list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	activation_emote = source.client ? (input(source, "Choose activation emote:", "Uplink Implant Setup") in emote_options) : emote_options[1]
	source.mind.store_memory("Uplink implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted uplink implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	hidden_uplink.uplink_owner = source.mind
	hidden_uplink.trigger_code = activation_emote
	return TRUE

/obj/item/weapon/implant/uplink/trigger(emote, mob/source as mob)
	if(hidden_uplink && usr == source) // Let's not have another people activate our uplink
		hidden_uplink.check_trigger(source, emote)

/obj/item/weapon/implanter/uplink
	name = "implanter (Uplink)"
	implant = /obj/item/weapon/implant/uplink
<<<<<<< HEAD
	spawn_tags = null
=======
>>>>>>> 57c0f65... Merge pull request #196 from SyzygyStation/revert-193-beep_boop
