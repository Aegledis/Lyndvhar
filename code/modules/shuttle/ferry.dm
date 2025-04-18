/obj/machinery/computer/shuttle/ferry
	name = "transport ferry console"
	desc = ""
	shuttleId = "ferry"
	possible_destinations = "ferry_home;ferry_away"
	req_access = list(ACCESS_CENT_GENERAL)

	var/allow_silicons = FALSE
	var/allow_emag = FALSE

/obj/machinery/computer/shuttle/ferry/emag_act(mob/user)
	if(!allow_emag)
		to_chat(user, span_warning("[src]'s security firewall is far too powerful for you to bypass."))
		return FALSE
	return ..()

/obj/machinery/computer/shuttle/ferry/request
	name = "ferry console"
	var/last_request //prevents spamming admins
	var/cooldown = 600
	possible_destinations = "ferry_home;ferry_away"
	req_access = list(ACCESS_CENT_GENERAL)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/machinery/computer/shuttle/ferry/request/Topic(href, href_list)
	..()
	if(href_list["request"])
		if(last_request && (last_request + cooldown > world.time))
			return
		last_request = world.time
		to_chat(usr, span_notice("My request has been received by CentCom."))
		to_chat(GLOB.admins, "<b>FERRY: <font color='#3d5bc3'>[ADMIN_LOOKUPFLW(usr)] (<A HREF='?_src_=holder;[HrefToken()];secrets=moveferry'>Move Ferry</a>)</b> is requesting to move the transport ferry to CentCom.</font>")
