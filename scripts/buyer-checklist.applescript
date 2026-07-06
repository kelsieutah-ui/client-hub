-- buyer-checklist.applescript
-- Prompts for full name (list name) and first name (personalized in snippets).
-- Creates a Reminders list "[Full Name], Buyer" via AppleScript, then adds every
-- task by calling the reminders CLI (~/Sites/client-hub/scripts/bin/reminders).
-- Uses the CLI because AppleScript's Reminders scripting silently drops the
-- body/notes property on this system (macOS 14.6), and Apple's Shortcuts GUI
-- editor kept regressing our task-splitting shortcut.
--
-- The `reminders` binary is by Keith Smiley: github.com/keith/reminders-cli.
-- It talks to Reminders through EventKit, which is the canonical write path.
--
-- Snippets sourced from:
-- /Users/kelsiejimenez/Documents/Obsidian Vault/Business Brain/Systems & SOPs/Stage-Text-Snippets.md

property REMINDERS_BIN : "/Users/kelsiejimenez/Sites/client-hub/scripts/bin/reminders"

on replaceText(theText, oldStr, newStr)
	-- Note: do NOT use "result" as a local variable here. AppleScript reserves it
	-- to hold the last statement's return value, and using it silently produces
	-- empty output. Learned the hard way, 2026-07-04.
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

set fullName to text returned of (display dialog "Client full name:" default answer "" with title "New Buyer Checklist")
if fullName is "" then return

set AppleScript's text item delimiters to " "
set firstNameDefault to first text item of fullName
set AppleScript's text item delimiters to ""

set firstName to text returned of (display dialog "First name to use in text snippets:" default answer firstNameDefault with title "New Buyer Checklist")
if firstName is "" then set firstName to firstNameDefault

set listName to fullName & ", Buyer"

-- Snippet templates. [First Name] gets substituted below.
set snippet_01 to "Hi [First Name]! First step is easy. Fill out your buyer questionnaire so I can make our consult about YOUR goals, not a generic pitch: https://clients.kelsiejimenez.com/buyer-questionnaire.html. Takes about five minutes."
set snippet_02 to "Hi [First Name]! Let us get your buyer consultation on the calendar. Grab whatever time works best for you here: https://calendly.com/kelsie-utah/30min. Come with questions, all of them are fair game."
set snippet_03 to "Hi [First Name]! Before we start touring, you will sign a Buyer Broker Agreement. Here is what it means in plain English and why it protects you: https://clients.kelsiejimenez.com/buyer.html#buyer-broker-agreement. Questions before you sign anything, text me."
set snippet_04 to "Hi [First Name]! Before we write an offer, here is a plain English walkthrough of the Utah purchase contract, including a video where I break it all down: https://clients.kelsiejimenez.com/buyer.html#purchase-contract. Questions on any section, text me."
set snippet_05 to "Hi [First Name]! Time to get your pre-approval. Here is what lenders look at and why this comes before touring homes: https://clients.kelsiejimenez.com/buyer.html#pre-approval. When you are ready to apply, my recommended lender TJ Shelley makes it easy, start here: https://fcm.tidalwave.ai/signup/torin.shelley/D6NJJJ536C4Q72PTE7BG. Want to shop around instead? Smart move, text me and I will point you to good options."
set snippet_06 to "Hi [First Name]! Time to start house hunting. Here are a few quick things to keep in mind as we tour: https://clients.kelsiejimenez.com/buyer.html#shopping. See something you love online? Send it to me and I will get us in."
set snippet_07 to "[First Name], your offer was ACCEPTED! Congratulations. Here is your roadmap from today to keys in hand: https://clients.kelsiejimenez.com/buyer.html#under-contract. Deadlines start now, and I will stay on every one of them with you."
set snippet_08 to "Hi [First Name]! Next up is your earnest money, due within 4 days. Here is what to expect and how to send it safely: https://clients.kelsiejimenez.com/buyer.html#earnest-money. Text me once it is sent and I will confirm receipt."
set snippet_09 to "Hi [First Name]! Inspection time. Here is what the inspector covers, how to read the report without panicking, and how we use findings to negotiate: https://clients.kelsiejimenez.com/buyer.html#inspections. Remember, every house has a list. What matters is what is on it."
set snippet_10 to "Hi [First Name]! The seller disclosures are in. Here is what to look for and which items deserve a closer look: https://clients.kelsiejimenez.com/buyer.html#seller-disclosures. I have already read them. Let us compare notes."
set snippet_11 to "Hi [First Name]! The appraisal has been ordered. Here is what happens, how long it takes, and what the possible outcomes mean for us: https://clients.kelsiejimenez.com/buyer.html#appraisal. Most of the time this is a quiet step. I will text you the moment results land."
set snippet_12 to "[First Name], you are CLEAR TO CLOSE! Here is what that milestone means and the final steps between you and keys: https://clients.kelsiejimenez.com/buyer.html#clear-to-close. Do not open new credit or move money around until after closing. Seriously."
set snippet_13 to "Hi [First Name]! Final walkthrough time. Here is exactly what we are checking to make sure the home is in the condition you agreed to: https://clients.kelsiejimenez.com/buyer.html#final-walkthrough. This is the last look before it is yours."
set snippet_14 to "[First Name], CLOSING DAY! Here is what to bring, what to expect at the table, and when you get keys: https://clients.kelsiejimenez.com/buyer.html#closing-day. Recording confirmed and keys in hand, text me a photo. Best text of the year."
set snippet_address to "Hi [First Name]! In case you missed it earlier, here is my one stop shop for scheduling utilities and changing your address everywhere: https://guide.kelsiejimenez.com/moving-resource-guide.html. Fifteen minutes now saves a headache on move day."
set snippet_review to "Hi [First Name]! It was an honor helping you get home. If you have two minutes, a quick review means the world to my small business: https://guide.kelsiejimenez.com/leave-a-review.html. Thank you for trusting me with this."
set snippet_homeguide to "Hi [First Name]! One last gift: my new homeowner guide, from maintenance timelines to who to call when something breaks: https://guide.kelsiejimenez.com/new-homeowner-guide.html. Welcome home."
set snippet_uc_cheatsheet to "Cheat sheet: congrats under contract link within 24 hrs of acceptance. Seller disclosures link 2 days. Due diligence checklist link 2 days. Earnest money link 24 hrs. Appraisal link 7 days. Clear to close link 2 days before the F and A deadline. Final walkthrough link 48 hrs before settlement. Settlement link 24 hrs before settlement. Review link same day as settlement."

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
set s11 to my replaceText(snippet_11, "[First Name]", firstName)
set s12 to my replaceText(snippet_12, "[First Name]", firstName)
set s13 to my replaceText(snippet_13, "[First Name]", firstName)
set s14 to my replaceText(snippet_14, "[First Name]", firstName)
set sAddress to my replaceText(snippet_address, "[First Name]", firstName)
set sReview to my replaceText(snippet_review, "[First Name]", firstName)
set sHomeGuide to my replaceText(snippet_homeguide, "[First Name]", firstName)

-- Create the list up front so the Shortcut's Add New Reminder finds it.
tell application "Reminders"
	set nameList to name of lists
	set alreadyExists to false
	repeat with n in nameList
		if (n as text) is listName then
			set alreadyExists to true
			exit repeat
		end if
	end repeat
	if alreadyExists then
		display dialog "A list named " & quote & listName & quote & " already exists." buttons {"OK"} default button "OK"
		return
	end if
	make new list with properties {name:listName}
end tell

-- Populate every task through the CLI. Empty note for admin-only tasks.

-- [LEAD INTAKE]
my addTask(listName, "[LEAD INTAKE]", "")
my addTask(listName, "Email link of Buyers Questionnaire", s01)
my addTask(listName, "Input client information in CRM and phone", "")
my addTask(listName, "Schedule Consultation", s02)
my addTask(listName, "Prep for consult", "")

-- [BUYER CONSULTATION]
my addTask(listName, "[BUYER CONSULTATION]", "")
my addTask(listName, "Get preapproval from lender", s05)
my addTask(listName, "Add lending notes to file", "")
my addTask(listName, "Needs and Wants Paper", "")
my addTask(listName, "BBA Loom sent", s03)
my addTask(listName, "Send the Introduction to REPC", s04)
my addTask(listName, "Timeline confirmed", "")
my addTask(listName, "Budget and Rate Confirmed", "")
my addTask(listName, "Set up search criteria in MLS", "")
my addTask(listName, "Set up Listing Alerts", "")

-- [OFFERING]
my addTask(listName, "[OFFERING]", "")
my addTask(listName, "Send the Time to start shopping link", s06)
my addTask(listName, "Market update weekly", "")
my addTask(listName, "Weekly follow-up", "")
my addTask(listName, "CMA before UC", "")
my addTask(listName, "Review UC stages with weekly tips", "")

-- [UNDER CONTRACT]
my addTask(listName, "[UNDER CONTRACT]", "")
my addTask(listName, "Add due dates to the tasks below per the REPC deadlines", snippet_uc_cheatsheet)
my addTask(listName, "Submit REPC to TPG stats", "")
my addTask(listName, "Input Dates / Contract information", "")
my addTask(listName, "Send congrats you are under contract link", s07)
my addTask(listName, "Send Seller Disclosure Deadline link", s10)
my addTask(listName, "Send Know Before You Buy Due Diligence Checklist link", s09)
my addTask(listName, "Pre-closing Reminder Set Up", "")
my addTask(listName, "Send the earnest money link", s08)
my addTask(listName, "Follow up with client that inspections were scheduled", "")
my addTask(listName, "Confirm Inspection with Listing Agent", "")
my addTask(listName, "Review PR / Title", "")
my addTask(listName, "Repair Requests Negotiated", "")
my addTask(listName, "Send the appraisal link to clients", s11)

-- [PRE-CLOSING]
my addTask(listName, "[PRE-CLOSING]", "")
my addTask(listName, "Send client you are clear to close link", s12)
my addTask(listName, "Send client final walkthrough link", s13)
my addTask(listName, "Plan and Order Closing Gift", "")
my addTask(listName, "Final Walkthrough Performed", "")
my addTask(listName, "Prepare Closing Congrats Card and Review Card", "")
my addTask(listName, "Schedule Closing with Title", "")
my addTask(listName, "Send Settlement Day What to Expect Email", s14)
my addTask(listName, "Send address change checklist with links", sAddress)
my addTask(listName, "Coordinate Keys with Listing Agent", "")

-- [CLOSED]
my addTask(listName, "[CLOSED]", "")
my addTask(listName, "Text clients to ask for a review", sReview)
my addTask(listName, "Create IG post", "")
my addTask(listName, "Update Zillow sale", "")
my addTask(listName, "Add Buyer to popby list", "")
my addTask(listName, "Send the link to new homeowner guide", sHomeGuide)
my addTask(listName, "Client added to newsletter", "")
my addTask(listName, "Add Home Anniversary reminder in calendar", "")
my addTask(listName, "Update Clients New Address", "")
my addTask(listName, "Move to Long Term Follow Up", "")

display notification quote & listName & quote & " created in Reminders" with title "Buyer Checklist Created"
