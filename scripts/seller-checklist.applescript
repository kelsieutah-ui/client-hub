-- seller-checklist.applescript
-- Client-facing seller journey list. Prompts for full name and first name,
-- creates a Reminders list "[Full Name], Seller" via AppleScript, then adds
-- every task via the reminders CLI (~/Sites/client-hub/scripts/bin/reminders).
-- The CLI writes notes reliably through EventKit, which AppleScript's own
-- Reminders scripting bridge does not.
--
-- Task list, order, and section headers are canonical, sourced from Kelsie's
-- Reminders workflow snapshot on 2026-07-06. Do not reorder without her sign-off.
--
-- Snippets sourced from:
-- /Users/kelsiejimenez/Documents/Obsidian Vault/Business Brain/Systems & SOPs/Stage-Text-Snippets.md

property REMINDERS_BIN : "/Users/kelsiejimenez/Sites/client-hub/scripts/bin/reminders"

on replaceText(theText, oldStr, newStr)
	-- Do NOT rename "joined" to "result", it is a reserved AppleScript keyword
	-- that silently produces empty string when used as a local variable. 2026-07-04.
	set AppleScript's text item delimiters to oldStr
	set parts to text items of theText
	set AppleScript's text item delimiters to newStr
	set joined to parts as text
	set AppleScript's text item delimiters to ""
	return joined
end replaceText

on addTask(listName, taskTitle, noteBody)
	if noteBody is "" then
		do shell script (quoted form of REMINDERS_BIN) & " add " & (quoted form of listName) & " " & (quoted form of taskTitle)
	else
		do shell script (quoted form of REMINDERS_BIN) & " add " & (quoted form of listName) & " " & (quoted form of taskTitle) & " --notes " & (quoted form of noteBody)
	end if
end addTask

set fullName to text returned of (display dialog "Client full name:" default answer "" with title "New Seller Checklist")
if fullName is "" then return

set AppleScript's text item delimiters to " "
set firstNameDefault to first text item of fullName
set AppleScript's text item delimiters to ""

set firstName to text returned of (display dialog "First name to use in text snippets:" default answer firstNameDefault with title "New Seller Checklist")
if firstName is "" then set firstName to firstNameDefault

set listName to fullName & ", Seller"

-- --- Snippet templates. [First Name] gets substituted below. ---
set snippet_questionnaire to "Hi [First Name]! First step is easy. Fill out your seller questionnaire so I can tailor everything to your home and your timeline: https://clients.kelsiejimenez.com/seller-questionnaire.html. Takes about five minutes."
set snippet_calendly to "Hi [First Name]! Let us get your listing consultation on the calendar. Grab whatever time works best for you here: https://calendly.com/kelsie-utah/30min. Come with questions, all of them are fair game."
set snippet_prelisting to "Hi [First Name]! Here is where we start: getting your home ready to earn top dollar. This is my full prep playbook, the same one I use on every listing. Read the parts that apply and I will walk the house with you before we touch a thing: https://clients.kelsiejimenez.com/seller.html#pre-listing-prep"
set snippet_actionitems to "Hi [First Name]! Quick one. Here is your short list of action items before photos. Nothing overwhelming, just the handful of things that make the biggest difference on camera: https://clients.kelsiejimenez.com/seller.html#action-items. Text me if anything on the list feels like a project and we will figure it out together."
set snippet_mls to "Hi [First Name]! I am building your MLS listing this week. Here is what I need from you and why it matters for how buyers find your home: https://clients.kelsiejimenez.com/seller.html#mls-input-sheet. A few minutes now means your listing goes live clean and complete."
set snippet_photoday to "Hi [First Name]! Photo day is coming up. Here is exactly how to have the house ready so it photographs like a magazine spread: https://clients.kelsiejimenez.com/seller.html#photo-day. Do not stress about perfect. I will do a walkthrough before the photographer starts."
set snippet_golive to "[First Name], we are LIVE! Here is what happens in the first 72 hours and what to expect with showings: https://clients.kelsiejimenez.com/seller.html#go-live. Keep your phone close, keep the house show-ready, and let me handle the rest."
set snippet_offers to "Hi [First Name]! Offer activity time. Here is how I evaluate offers with you, because price is only one piece of a strong offer: https://clients.kelsiejimenez.com/seller.html#offers. When one comes in, we will go through it line by line together. We will run every offer through my net sheet calculator together so you see the real walk away number, not just the price."
set snippet_undercontract to "[First Name], we are under contract! Congratulations. Here is your map of what happens between now and closing so nothing catches you off guard: https://clients.kelsiejimenez.com/seller.html#under-contract. I will keep you posted at every checkpoint."
set snippet_closingdisc to "Hi [First Name]! Closing paperwork is starting to move. Here is what you will be signing and what to double check before you do: https://clients.kelsiejimenez.com/seller.html#closing-disclosures. Any number that looks off, screenshot it and text me before signing."
set snippet_closingday to "[First Name], closing day! Here is what to bring, how long it takes, and when the money actually lands: https://clients.kelsiejimenez.com/seller.html#closing-day. Almost there."
set snippet_afterclose to "Hi [First Name]! It is official. Here are the loose ends to tie up after closing, utilities, records, and a couple things people always forget: https://clients.kelsiejimenez.com/seller.html#after-close. It has been an honor. I am always one text away, for you and for anyone you love who needs a straight-shooting agent."
set snippet_movingutilities to "Hi [First Name]! Here is my one stop shop for scheduling utilities and changing your address everywhere: https://guide.kelsiejimenez.com/moving-resource-guide.html. Fifteen minutes now saves a headache on move day."
set snippet_review to "Hi [First Name]! It was an honor helping you sell your home. If you have two minutes, a quick review means the world to my small business: https://guide.kelsiejimenez.com/leave-a-review.html. Thank you for trusting me with this."
set snippet_showingprefs to "Hi [First Name]! Quick one before we go live: how do you want showings to run? Notice needed, times that never work, pets I should know about? Text me your preferences and I will set the rules so showings never catch you off guard."
set snippet_netsheet to "Hi [First Name]! I ran your personalized net sheet, but here is the calculator itself so you can play with the numbers anytime: https://guide.kelsiejimenez.com/seller-net-sheet.html. Change the price, commissions, or payoff and watch your walk away number update live. When offers come in, the Compare Offers tab shows why the highest price is not always the highest net."

set s_questionnaire to my replaceText(snippet_questionnaire, "[First Name]", firstName)
set s_calendly to my replaceText(snippet_calendly, "[First Name]", firstName)
set s_prelisting to my replaceText(snippet_prelisting, "[First Name]", firstName)
set s_actionitems to my replaceText(snippet_actionitems, "[First Name]", firstName)
set s_mls to my replaceText(snippet_mls, "[First Name]", firstName)
set s_photoday to my replaceText(snippet_photoday, "[First Name]", firstName)
set s_golive to my replaceText(snippet_golive, "[First Name]", firstName)
set s_offers to my replaceText(snippet_offers, "[First Name]", firstName)
set s_undercontract to my replaceText(snippet_undercontract, "[First Name]", firstName)
set s_closingdisc to my replaceText(snippet_closingdisc, "[First Name]", firstName)
set s_closingday to my replaceText(snippet_closingday, "[First Name]", firstName)
set s_afterclose to my replaceText(snippet_afterclose, "[First Name]", firstName)
set s_movingutilities to my replaceText(snippet_movingutilities, "[First Name]", firstName)
set s_review to my replaceText(snippet_review, "[First Name]", firstName)
set s_showingprefs to my replaceText(snippet_showingprefs, "[First Name]", firstName)
set s_netsheet to my replaceText(snippet_netsheet, "[First Name]", firstName)

-- --- Internal notes (no client-facing snippet, no [First Name] token) ---
set note_ersloom to "Loom not recorded yet. Walk them through the listing agreement live for now. When the ERS Loom exists, replace this note with the client text and link."
set note_repcloom to "Seller REPC Loom not recorded yet. Interim option: Kelsie's REPC walkthrough video lives on the buyer journey at https://clients.kelsiejimenez.com/buyer.html#purchase-contract if a seller needs it before the seller version exists."
set note_deadlines to "Cheat sheet: congrats under contract link within 24 hrs of acceptance. MLS status update 24 hrs. Home inspection requests confirmed by the buyer due diligence deadline. Repairs confirmed complete 7 days before settlement. Closing disclosures link 3 days before settlement. Final walkthrough scheduled 48 hrs before settlement. Closing day link 24 hrs before settlement. Moving and utilities link 1 week before settlement. Review request same day as closing."

-- --- Create the list up front ---
tell application "Reminders"
	set nameList to name of lists
	set alreadyExists to false
	repeat with n in nameList
		if (n as text) is listName then set alreadyExists to true
	end repeat
	if alreadyExists then
		display dialog "A list named " & quote & listName & quote & " already exists." buttons {"OK"} default button "OK"
		return
	end if
	make new list with properties {name:listName}
end tell

-- --- Populate every task through the reminders CLI ---

-- [PRE-LISTING]
my addTask(listName, "[PRE-LISTING]", "")
my addTask(listName, "Send the seller questionnaire link", s_questionnaire)
my addTask(listName, "Input client information in CRM and phone", "")
my addTask(listName, "Update Seller Questionnaire information collected", "")
my addTask(listName, "Drop off Pre-Listing paint bucket", "")
my addTask(listName, "Send Listing appt Calendly", s_calendly)
my addTask(listName, "Send the listing prep playbook link", s_prelisting)
my addTask(listName, "Set collected birthdays in calendar", "")
my addTask(listName, "Post on story about listing appt.", "")
my addTask(listName, "Send ERS Loom video", note_ersloom)
my addTask(listName, "Sign ERS/media waiver/title docs", "")
my addTask(listName, "Screenshot Estimate", "")
my addTask(listName, "Send the action items link", s_actionitems)
my addTask(listName, "Verify Ownership Tax Records/ PR Title/ Trust Docs", "")
my addTask(listName, "Collect Mortgage Payoff Amounts", "")
my addTask(listName, "Create Seller Net Sheet and Send Seller Net Calculator Webpage", s_netsheet)
my addTask(listName, "Pre Home Inspection Walkthrough", "")
my addTask(listName, "Send the MLS input sheet link", s_mls)
my addTask(listName, "Research Subject Property/ Pre-CMA", "")
my addTask(listName, "Collect extra key", "")
my addTask(listName, "Collect required Disclosures: LBP, SPCD, MLS Input", "")
my addTask(listName, "Collect HOA information if applicable", "")
my addTask(listName, "Verify sq/ft MLS input sheet", "")
my addTask(listName, "Schedule staging if applicable", "")
my addTask(listName, "Send the photo day link", s_photoday)
my addTask(listName, "Final walkthrough before photos", "")
my addTask(listName, "Add key to Supra/ drop off marketing materials", "")
my addTask(listName, "Marketing plan booklet", "")
my addTask(listName, "Schedule photos", "")
my addTask(listName, "Verify SPCD before going live", "")

-- [LISTING PREP]
my addTask(listName, "[LISTING PREP]", "")
my addTask(listName, "Schedule Pricing Meeting", "")
my addTask(listName, "Market Deep Dive", "")
my addTask(listName, "CMA packet", "")
my addTask(listName, "Text showing preferences request", s_showingprefs)
my addTask(listName, "Start Canva Folder for Property Address", "")
my addTask(listName, "Special Features Cards Throughout Home Created", "")
my addTask(listName, "Listing Flyer Created", "")
my addTask(listName, "Send Just Listed postcard", "")
my addTask(listName, "Confirm sign and lockbox are there", "")
my addTask(listName, "Organize photos into MLS", "")
my addTask(listName, "Enter into MLS and write Listing description", "")
my addTask(listName, "Confirm price and Listing Date", "")
my addTask(listName, "Make listing active on MLS", "")

-- [GO LIVE]
my addTask(listName, "[GO LIVE]", "")
my addTask(listName, "Update Showing Preferences into Aligned", "")
my addTask(listName, "Text Its Live MLS link to Sellers", s_golive)
my addTask(listName, "Order Print Materials", "")
my addTask(listName, "Pick up Print Materials", "")
my addTask(listName, "Add Open House to MLS and Facebook Events", "")
my addTask(listName, "Postcard QR Send Postcards", "")
my addTask(listName, "Share to relevant Facebook Groups", "")
my addTask(listName, "B-roll Videos / Reels Created", "")

-- [ACTIVE]
my addTask(listName, "[ACTIVE]", "")
my addTask(listName, "Feedback from showings update Sellers", "")
my addTask(listName, "Open House Scheduled/ Added as Facebook event", "")
my addTask(listName, "MLS stats weekly", "")
my addTask(listName, "Zillow showcase stats report at 2 weeks out", "")
my addTask(listName, "Facebook marketplace ad", "")
my addTask(listName, "Set up Aligned Showings or adjust if needed", "")
my addTask(listName, "Drop just listed boxes 10 or more", "")
my addTask(listName, "Deliver flyers to nearby businesses", "")
my addTask(listName, "Invite neighbors to Open House", "")

-- [UNDER CONTRACT]
my addTask(listName, "[UNDER CONTRACT]", "")
my addTask(listName, "Add due dates to the tasks below per the REPC deadlines", note_deadlines)
my addTask(listName, "Send the reviewing offers link", s_offers)
my addTask(listName, "Send Loom for REPC to Sellers", note_repcloom)
my addTask(listName, "Update MLS status", "")
my addTask(listName, "Notify interested parties", "")
my addTask(listName, "Send congrats you are under contract link", s_undercontract)
my addTask(listName, "Send Crumble cookies for Under Contract celebration", "")
my addTask(listName, "Schedule staging clean-up", "")
my addTask(listName, "Confirm home inspection requests with sellers", "")
my addTask(listName, "Remind client to schedule utilities/change of address with moving resource guide", "")
my addTask(listName, "Schedule final walk through with sellers", "")
my addTask(listName, "Gather leads from Open House/ add to CRM", "")
my addTask(listName, "Send Under Contract postcards", "")

-- [PRE-CLOSING]
my addTask(listName, "[PRE-CLOSING]", "")
my addTask(listName, "Send the moving and utilities link", s_movingutilities)
my addTask(listName, "Confirm Sellers did repairs", "")
my addTask(listName, "Schedule closing notify agent", "")
my addTask(listName, "Put closing on calendar", "")
my addTask(listName, "Send the closing day link", s_closingday)
my addTask(listName, "Order closing gift", "")
my addTask(listName, "Send the after close link", s_afterclose)
my addTask(listName, "Confirm de-staging", "")
my addTask(listName, "Send the closing disclosures link", s_closingdisc)

-- [CLOSED]
my addTask(listName, "[CLOSED]", "")
my addTask(listName, "Social media post", "")
my addTask(listName, "Put client on anniversary calendar", "")
my addTask(listName, "Add/update clients in database email list", "")
my addTask(listName, "Update zillow sales/MLS", "")
my addTask(listName, "Send just sold postcards to neighborhood", "")
my addTask(listName, "Text clients to ask for a review", s_review)
my addTask(listName, "Update client closing date in CRM", "")
my addTask(listName, "Move to Long Term Follow Up", "")

display notification quote & listName & quote & " created in Reminders" with title "Seller Checklist Created"
