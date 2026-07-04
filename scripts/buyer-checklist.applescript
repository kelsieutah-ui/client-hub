-- buyer-checklist.applescript
-- Prompts for full name (list name) and first name (personalized in snippets).
-- Creates a Reminders list "[Full Name], Buyer" with the full transaction task
-- set. Client-facing tasks carry the matching stage snippet in the notes body,
-- with [First Name] replaced. Admin-only tasks stay note-less.
--
-- Structure (2026-07-04): tasks are created in phase 1 (names only). Bodies
-- are applied in phase 2 by looking up the reminder by name, after a settle
-- delay. Setting body via saved refs from batch creation is unreliable in
-- macOS Reminders; lookup-by-name is the pattern that consistently persists.
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
set snippet_02 to "Hi [First Name]! Before we meet, here is what your buyer consultation covers and how to get the most out of it: https://clients.kelsiejimenez.com/buyer.html#consultation. Come with questions. All of them are fair game."
set snippet_03 to "Hi [First Name]! Before we start touring, you will sign a Buyer Broker Agreement. Here is what it means in plain English and why it protects you: https://clients.kelsiejimenez.com/buyer.html#buyer-broker-agreement. Questions before you sign anything, text me."
set snippet_04 to "Hi [First Name]! Here is how the Utah purchase contract works, what the key sections mean, and where your protections live: https://clients.kelsiejimenez.com/buyer.html#purchase-contract. We will go through the real thing together before you ever sign."
set snippet_05 to "Hi [First Name]! Time to get your pre-approval. Here is what lenders look at, what documents to gather, and why this comes before touring homes: https://clients.kelsiejimenez.com/buyer.html#pre-approval. Need a lender recommendation? Text me and I will connect you."
set snippet_06 to "Hi [First Name]! The fun part. Here is how showings work, how to compare homes without losing your mind, and what I watch for that most buyers miss: https://clients.kelsiejimenez.com/buyer.html#shopping. See something you love online? Send it to me and I will get us in."
set snippet_07 to "[First Name], your offer was ACCEPTED! Congratulations. Here is your roadmap from today to keys in hand: https://clients.kelsiejimenez.com/buyer.html#under-contract. Deadlines start now, and I will stay on every one of them with you."
set snippet_08 to "Hi [First Name]! Next up is your earnest money, due within 4 days. Here is what to expect and how to send it safely: https://clients.kelsiejimenez.com/buyer.html#earnest-money. Text me once it is sent and I will confirm receipt."
set snippet_09 to "Hi [First Name]! Inspection time. Here is what the inspector covers, how to read the report without panicking, and how we use findings to negotiate: https://clients.kelsiejimenez.com/buyer.html#inspections. Remember, every house has a list. What matters is what is on it."
set snippet_10 to "Hi [First Name]! The seller disclosures are in. Here is what to look for and which items deserve a closer look: https://clients.kelsiejimenez.com/buyer.html#seller-disclosures. I have already read them. Let us compare notes."
set snippet_11 to "Hi [First Name]! The appraisal has been ordered. Here is what happens, how long it takes, and what the possible outcomes mean for us: https://clients.kelsiejimenez.com/buyer.html#appraisal. Most of the time this is a quiet step. I will text you the moment results land."
set snippet_12 to "[First Name], you are CLEAR TO CLOSE! Here is what that milestone means and the final steps between you and keys: https://clients.kelsiejimenez.com/buyer.html#clear-to-close. Do not open new credit or move money around until after closing. Seriously."
set snippet_13 to "Hi [First Name]! Final walkthrough time. Here is exactly what we are checking to make sure the home is in the condition you agreed to: https://clients.kelsiejimenez.com/buyer.html#final-walkthrough. This is the last look before it is yours."
set snippet_14 to "[First Name], CLOSING DAY! Here is what to bring, what to expect at the table, and when you get keys: https://clients.kelsiejimenez.com/buyer.html#closing-day. Recording confirmed and keys in hand, text me a photo. Best text of the year."

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

tell application "Reminders"
	repeat with l in lists
		if name of l is listName then
			display dialog "A list named " & quote & listName & quote & " already exists." buttons {"OK"} default button "OK"
			return
		end if
	end repeat

	set targetList to make new list with properties {name:listName}

	-- ============ PHASE 1: create all tasks with names only ============

	-- [LEAD INTAKE]
	make new reminder at end of targetList with properties {name:"[LEAD INTAKE]"}
	make new reminder at end of targetList with properties {name:"Email link of Buyers Questionnaire"}
	make new reminder at end of targetList with properties {name:"Input client in CRM"}
	make new reminder at end of targetList with properties {name:"Input client contact information in phone"}
	make new reminder at end of targetList with properties {name:"Prep for consult"}
	make new reminder at end of targetList with properties {name:"Get Pre-approval from Lender"}
	make new reminder at end of targetList with properties {name:"Add Lending notes to file"}

	-- [BUYER CONSULTATION]
	make new reminder at end of targetList with properties {name:"[BUYER CONSULTATION]"}
	make new reminder at end of targetList with properties {name:"Needs and Wants Paper"}
	make new reminder at end of targetList with properties {name:"BBA Loom sent"}
	make new reminder at end of targetList with properties {name:"REPC Paper Copy Highlighted"}
	make new reminder at end of targetList with properties {name:"Buyers Guide Roadmap"}
	make new reminder at end of targetList with properties {name:"Schedule Consultation"}
	make new reminder at end of targetList with properties {name:"Timeline confirmed"}
	make new reminder at end of targetList with properties {name:"Budget and Rate Confirmed"}
	make new reminder at end of targetList with properties {name:"Set up search criteria in MLS"}
	make new reminder at end of targetList with properties {name:"Set up Listing Alerts"}

	-- [OFFERING]
	make new reminder at end of targetList with properties {name:"[OFFERING]"}
	make new reminder at end of targetList with properties {name:"Refine preferences"}
	make new reminder at end of targetList with properties {name:"Market update weekly"}
	make new reminder at end of targetList with properties {name:"Weekly follow-up"}
	make new reminder at end of targetList with properties {name:"CMA before UC"}
	make new reminder at end of targetList with properties {name:"Review UC stages with weekly tips"}

	-- [UNDER CONTRACT]
	make new reminder at end of targetList with properties {name:"[UNDER CONTRACT]"}
	make new reminder at end of targetList with properties {name:"Submit REPC to TPG stats"}
	make new reminder at end of targetList with properties {name:"Input Dates / Contract information"}
	make new reminder at end of targetList with properties {name:"Send Congrats Earnest Money email template"}
	make new reminder at end of targetList with properties {name:"Send Seller Disclosure Deadline email template"}
	make new reminder at end of targetList with properties {name:"Send Know Before You Buy Due Diligence Checklist email"}
	make new reminder at end of targetList with properties {name:"Pre-closing Reminder Set Up"}
	make new reminder at end of targetList with properties {name:"Earnest Money Collected"}
	make new reminder at end of targetList with properties {name:"Schedule Inspections"}
	make new reminder at end of targetList with properties {name:"Confirm Inspection with Listing Agent"}
	make new reminder at end of targetList with properties {name:"Review PR / Title"}
	make new reminder at end of targetList with properties {name:"Repair Requests Negotiated"}
	make new reminder at end of targetList with properties {name:"Confirm Appraisal Ordered"}

	-- [PRE-CLOSING]
	make new reminder at end of targetList with properties {name:"[PRE-CLOSING]"}
	make new reminder at end of targetList with properties {name:"Send address change checklist with links"}
	make new reminder at end of targetList with properties {name:"Send One Last Thing Before Keys / Utilities email"}
	make new reminder at end of targetList with properties {name:"Schedule Final Walkthrough"}
	make new reminder at end of targetList with properties {name:"Plan and Order Closing Gift"}
	make new reminder at end of targetList with properties {name:"Final Walkthrough Performed"}
	make new reminder at end of targetList with properties {name:"Prepare Closing Congrats Card and Review Card"}
	make new reminder at end of targetList with properties {name:"Schedule Closing with Title"}
	make new reminder at end of targetList with properties {name:"Send Settlement Day What to Expect Email"}
	make new reminder at end of targetList with properties {name:"Coordinate Keys with Listing Agent"}
	make new reminder at end of targetList with properties {name:"Send Before You Unpack / Enroll Kids in School email"}
	make new reminder at end of targetList with properties {name:"Send Pack This Box First / Packing Guidance Email"}

	-- [CLOSED]
	make new reminder at end of targetList with properties {name:"[CLOSED]"}
	make new reminder at end of targetList with properties {name:"Text clients to ask for a review"}
	make new reminder at end of targetList with properties {name:"Create IG post"}
	make new reminder at end of targetList with properties {name:"Update Zillow sale"}
	make new reminder at end of targetList with properties {name:"Add Buyer to popby list"}
	make new reminder at end of targetList with properties {name:"Homeowner resources sent"}
	make new reminder at end of targetList with properties {name:"Client added to newsletter"}
	make new reminder at end of targetList with properties {name:"Add Home Anniversary reminder in calendar"}
	make new reminder at end of targetList with properties {name:"Update Clients New Address"}
	make new reminder at end of targetList with properties {name:"Move to Long Term Follow Up"}

	-- ============ PHASE 2: settle, look up by name, apply bodies ============

	tell application "System Events" to delay 2

	set body of (first reminder of targetList whose name is "Email link of Buyers Questionnaire") to s01
	set body of (first reminder of targetList whose name is "Schedule Consultation") to s02
	set body of (first reminder of targetList whose name is "BBA Loom sent") to s03
	set body of (first reminder of targetList whose name is "REPC Paper Copy Highlighted") to s04
	set body of (first reminder of targetList whose name is "Get Pre-approval from Lender") to s05
	set body of (first reminder of targetList whose name is "Refine preferences") to s06
	set body of (first reminder of targetList whose name is "Send Congrats Earnest Money email template") to s07
	set body of (first reminder of targetList whose name is "Earnest Money Collected") to s08
	set body of (first reminder of targetList whose name is "Send Know Before You Buy Due Diligence Checklist email") to s09
	set body of (first reminder of targetList whose name is "Send Seller Disclosure Deadline email template") to s10
	set body of (first reminder of targetList whose name is "Confirm Appraisal Ordered") to s11
	set body of (first reminder of targetList whose name is "Send One Last Thing Before Keys / Utilities email") to s12
	set body of (first reminder of targetList whose name is "Schedule Final Walkthrough") to s13
	set body of (first reminder of targetList whose name is "Send Settlement Day What to Expect Email") to s14
end tell

display notification quote & listName & quote & " created in Reminders" with title "Buyer Checklist Created"
