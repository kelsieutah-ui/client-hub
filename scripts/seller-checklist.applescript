-- seller-checklist.applescript
-- Client-facing seller journey list. Prompts for full name and first name,
-- creates a Reminders list "[Full Name], Seller" with all transaction tasks.
-- Client-facing tasks carry the matching stage snippet as their body, with
-- [First Name] replaced. Admin-only tasks stay note-less.
--
-- Snippets sourced from:
-- /Users/kelsiejimenez/Documents/Obsidian Vault/Business Brain/Systems & SOPs/Stage-Text-Snippets.md

on replaceText(theText, oldStr, newStr)
	set AppleScript's text item delimiters to oldStr
	set parts to text items of theText
	set AppleScript's text item delimiters to newStr
	set result to parts as text
	set AppleScript's text item delimiters to ""
	return result
end replaceText

set fullName to text returned of (display dialog "Client full name:" default answer "" with title "New Seller Checklist")
if fullName is "" then return

set AppleScript's text item delimiters to " "
set firstNameDefault to first text item of fullName
set AppleScript's text item delimiters to ""

set firstName to text returned of (display dialog "First name to use in text snippets:" default answer firstNameDefault with title "New Seller Checklist")
if firstName is "" then set firstName to firstNameDefault

set listName to fullName & ", Seller"

set snippet_01 to "Hi [First Name]! Here is where we start: getting your home ready to earn top dollar. This is my full prep playbook, the same one I use on every listing. Read the parts that apply and I will walk the house with you before we touch a thing: https://clients.kelsiejimenez.com/seller.html#pre-listing-prep"
set snippet_02 to "Hi [First Name]! Quick one. Here is your short list of action items before photos. Nothing overwhelming, just the handful of things that make the biggest difference on camera: https://clients.kelsiejimenez.com/seller.html#action-items. Text me if anything on the list feels like a project and we will figure it out together."
set snippet_03 to "Hi [First Name]! I am building your MLS listing this week. Here is what I need from you and why it matters for how buyers find your home: https://clients.kelsiejimenez.com/seller.html#mls-input-sheet. A few minutes now means your listing goes live clean and complete."
set snippet_04 to "Hi [First Name]! Photo day is coming up. Here is exactly how to have the house ready so it photographs like a magazine spread: https://clients.kelsiejimenez.com/seller.html#photo-day. Do not stress about perfect. I will do a walkthrough before the photographer starts."
set snippet_05 to "[First Name], we are LIVE! Here is what happens in the first 72 hours and what to expect with showings: https://clients.kelsiejimenez.com/seller.html#go-live. Keep your phone close, keep the house show-ready, and let me handle the rest."
set snippet_06 to "Hi [First Name]! Offer activity time. Here is how I evaluate offers with you, because price is only one piece of a strong offer: https://clients.kelsiejimenez.com/seller.html#offers. When one comes in, we will go through it line by line together."
set snippet_07 to "[First Name], we are under contract! Congratulations. Here is your map of what happens between now and closing so nothing catches you off guard: https://clients.kelsiejimenez.com/seller.html#under-contract. I will keep you posted at every checkpoint."
set snippet_08 to "Hi [First Name]! Closing paperwork is starting to move. Here is what you will be signing and what to double check before you do: https://clients.kelsiejimenez.com/seller.html#closing-disclosures. Any number that looks off, screenshot it and text me before signing."
set snippet_09 to "[First Name], closing day! Here is what to bring, how long it takes, and when the money actually lands: https://clients.kelsiejimenez.com/seller.html#closing-day. Almost there."
set snippet_10 to "Hi [First Name]! It is official. Here are the loose ends to tie up after closing, utilities, records, and a couple things people always forget: https://clients.kelsiejimenez.com/seller.html#after-close. It has been an honor. I am always one text away, for you and for anyone you love who needs a straight-shooting agent."

set s01 to my replaceText(snippet_01, "[First Name]", firstName)
set s02 to my replaceText(snippet_02, "[First Name]", firstName)
set s03 to my replaceText(snippet_03, "[First Name]", firstName)
set s04 to my replaceText(snippet_04, "[First Name]", firstName)
set s05 to my replaceText(snippet_05, "[First Name]", firstName)
set s06 to my replaceText(snippet_06, "[First Name]", firstName)
set s07 to my replaceText(snippet_07, "[First Name]", firstName)
set s08 to my replaceText(snippet_08, "[First Name]", firstName)
set s09 to my replaceText(snippet_09, "[First Name]", firstName)
set s10 to my replaceText(snippet_10, "[First Name]", firstName)

tell application "Reminders"
	repeat with l in lists
		if name of l is listName then
			display dialog "A list named " & quote & listName & quote & " already exists." buttons {"OK"} default button "OK"
			return
		end if
	end repeat

	set targetList to make new list with properties {name:listName}

	-- [PRE-LIST]
	make new reminder at end of targetList with properties {name:"[PRE-LIST]"}
	make new reminder at end of targetList with properties {name:"Send Seller Questionnaire"}
	make new reminder at end of targetList with properties {name:"Update Seller Questionnaire info"}
	make new reminder at end of targetList with properties {name:"Drop off Pre-Listing Paint Bucket"}
	make new reminder at end of targetList with properties {name:"Set Birthdates into Calendar"}
	make new reminder at end of targetList with properties {name:"Post on story about listing appt"}
	make new reminder at end of targetList with properties {name:"Send ERS Loom video"}
	make new reminder at end of targetList with properties {name:"Schedule Listing Appointment"}
	make new reminder at end of targetList with properties {name:"Sign ERS/Media Waiver/Title Docs"}
	make new reminder at end of targetList with properties {name:"Screenshot Zestimate"}
	make new reminder at end of targetList with properties {name:"Send Action Items email template"}
	make new reminder at end of targetList with properties {name:"Verify Ownership Tax Record / PR Title / Trust Docs"}
	make new reminder at end of targetList with properties {name:"Collect Mortgage Payoff Amounts"}
	make new reminder at end of targetList with properties {name:"Create Seller Net Sheet"}
	make new reminder at end of targetList with properties {name:"Pre Home Inspection walkthrough"}
	make new reminder at end of targetList with properties {name:"Send MLS Input Sheet Email Template"}
	make new reminder at end of targetList with properties {name:"Research Subject Property / pre-CMA"}
	make new reminder at end of targetList with properties {name:"Collect extra key"}
	make new reminder at end of targetList with properties {name:"Collect required Disclosures: LBP, SPCD, MLS Input"}
	make new reminder at end of targetList with properties {name:"Collect HOA information if applicable"}
	make new reminder at end of targetList with properties {name:"Verify SqFt / MLS Input sheet"}
	make new reminder at end of targetList with properties {name:"Schedule staging if applicable"}
	make new reminder at end of targetList with properties {name:"Email Photo Day guide to client"}
	make new reminder at end of targetList with properties {name:"Final Walkthrough before photos"}
	make new reminder at end of targetList with properties {name:"Add key to Supra / drop off marketing materials"}
	make new reminder at end of targetList with properties {name:"Marketing Plan booklet"}
	make new reminder at end of targetList with properties {name:"Schedule photos"}
	make new reminder at end of targetList with properties {name:"Enter into MLS and write Listing description"}
	make new reminder at end of targetList with properties {name:"Verify SPCD before going live"}

	-- [JUST BEFORE LIVE]
	make new reminder at end of targetList with properties {name:"[JUST BEFORE LIVE]"}
	make new reminder at end of targetList with properties {name:"Schedule pricing meeting"}
	make new reminder at end of targetList with properties {name:"Market Deep Dive"}
	make new reminder at end of targetList with properties {name:"CMA packet"}
	make new reminder at end of targetList with properties {name:"Showing Preferences Requested Email"}
	make new reminder at end of targetList with properties {name:"Start Canva Folder for Property Address"}
	make new reminder at end of targetList with properties {name:"Special Features Cards Throughout Home Created"}
	make new reminder at end of targetList with properties {name:"Listing Flyer Created"}
	make new reminder at end of targetList with properties {name:"Send Just Listed postcard"}
	make new reminder at end of targetList with properties {name:"Confirm sign and lockbox are there"}
	make new reminder at end of targetList with properties {name:"Organize photos into MLS"}
	make new reminder at end of targetList with properties {name:"Confirm price and Listing Date"}
	make new reminder at end of targetList with properties {name:"Make listing active on MLS"}

	-- [LAUNCH]
	make new reminder at end of targetList with properties {name:"[LAUNCH]"}
	make new reminder at end of targetList with properties {name:"Update Showing Preferences into Aligned"}
	make new reminder at end of targetList with properties {name:"Text \"It's Live\" MLS link to Sellers"}
	make new reminder at end of targetList with properties {name:"Order print materials"}
	make new reminder at end of targetList with properties {name:"Pick Up Print Materials"}
	make new reminder at end of targetList with properties {name:"Add Open House to MLS and Facebook Events"}
	make new reminder at end of targetList with properties {name:"Postcard QR - Send Postcards"}
	make new reminder at end of targetList with properties {name:"Share to relevant Facebook Groups"}
	make new reminder at end of targetList with properties {name:"B-Roll Videos / Reels Created"}

	-- [ACTIVE LISTED]
	make new reminder at end of targetList with properties {name:"[ACTIVE LISTED]"}
	make new reminder at end of targetList with properties {name:"Feedback from showings - update Sellers"}
	make new reminder at end of targetList with properties {name:"Open House Scheduled / Added as Facebook Event"}
	make new reminder at end of targetList with properties {name:"MLS Stats weekly"}
	make new reminder at end of targetList with properties {name:"Zillow Showcase Stats Report at 2 weeks"}
	make new reminder at end of targetList with properties {name:"Facebook Marketplace Ad"}
	make new reminder at end of targetList with properties {name:"Set up Aligned Showings or adjust if needed"}
	make new reminder at end of targetList with properties {name:"Drop Just Listed boxes (10 or more)"}
	make new reminder at end of targetList with properties {name:"Deliver Flyers to nearby businesses"}
	make new reminder at end of targetList with properties {name:"Invite neighbors to Open House"}

	-- [OFFERS / UNDER CONTRACT]
	make new reminder at end of targetList with properties {name:"[OFFERS / UNDER CONTRACT]"}
	make new reminder at end of targetList with properties {name:"Send Loom for REPC for Sellers"}
	make new reminder at end of targetList with properties {name:"Update MLS status"}
	make new reminder at end of targetList with properties {name:"Notify interested parties"}
	make new reminder at end of targetList with properties {name:"Send Loom for Under Contract Roadmap for Sellers"}
	make new reminder at end of targetList with properties {name:"Send Crumble for Under Contract celebration"}
	make new reminder at end of targetList with properties {name:"Schedule staging clean-up"}
	make new reminder at end of targetList with properties {name:"Confirm Home Inspection Requests with Sellers"}
	make new reminder at end of targetList with properties {name:"Remind clients to schedule Utilities / change of address"}
	make new reminder at end of targetList with properties {name:"Schedule Final Walkthrough with Sellers"}
	make new reminder at end of targetList with properties {name:"Gather leads from open house / add to CRM"}
	make new reminder at end of targetList with properties {name:"Send Under Contract postcards"}

	-- [PRE-CLOSING]
	make new reminder at end of targetList with properties {name:"[PRE-CLOSING]"}
	make new reminder at end of targetList with properties {name:"Send address change checklist email"}
	make new reminder at end of targetList with properties {name:"Confirm sellers did repairs"}
	make new reminder at end of targetList with properties {name:"Schedule Closing - notify agent"}
	make new reminder at end of targetList with properties {name:"Put closing on calendar"}
	make new reminder at end of targetList with properties {name:"Order closing gift"}
	make new reminder at end of targetList with properties {name:"Confirm de-staging"}
	make new reminder at end of targetList with properties {name:"Send Confirm Seller Closing Disclosures Received"}

	-- [POST CLOSING]
	make new reminder at end of targetList with properties {name:"[POST CLOSING]"}
	make new reminder at end of targetList with properties {name:"Social Media Post"}
	make new reminder at end of targetList with properties {name:"Put Client on Anniversary Calendar"}
	make new reminder at end of targetList with properties {name:"Add / Update Clients in database email list"}
	make new reminder at end of targetList with properties {name:"Update Zillow sales / MLS"}
	make new reminder at end of targetList with properties {name:"Send Just Sold postcards to neighborhood"}
	make new reminder at end of targetList with properties {name:"Send Google / Zillow review request"}
	make new reminder at end of targetList with properties {name:"Update Card Closing Date"}
	make new reminder at end of targetList with properties {name:"Move to Long Term Follow Up"}

	-- ============ PHASE 2: settle, look up by name, apply bodies ============

	tell application "System Events" to delay 2

	set body of (first reminder of targetList whose name is "Send ERS Loom video") to s01
	set body of (first reminder of targetList whose name is "Send Action Items email template") to s02
	set body of (first reminder of targetList whose name is "Send MLS Input Sheet Email Template") to s03
	set body of (first reminder of targetList whose name is "Email Photo Day guide to client") to s04
	set body of (first reminder of targetList whose name is "Text \"It's Live\" MLS link to Sellers") to s05
	set body of (first reminder of targetList whose name is "Send Loom for REPC for Sellers") to s06
	set body of (first reminder of targetList whose name is "Send Loom for Under Contract Roadmap for Sellers") to s07
	set body of (first reminder of targetList whose name is "Send Confirm Seller Closing Disclosures Received") to s08
	set body of (first reminder of targetList whose name is "Put closing on calendar") to s09
	set body of (first reminder of targetList whose name is "Send Google / Zillow review request") to s10
end tell

display notification quote & listName & quote & " created in Reminders" with title "Seller Checklist Created"
