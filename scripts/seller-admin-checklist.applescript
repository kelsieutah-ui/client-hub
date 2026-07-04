-- seller-admin-checklist.applescript
-- Kelsie's internal work list for a seller transaction. Prompts for full name
-- and first name (kept in sync with the other scripts so lists sit alongside
-- their client-facing counterparts). Creates "[Full Name], Seller Admin".
--
-- Intentionally NO client-facing snippets in this file. This is the agent's
-- workflow list, not the client's stage-notes list.

set fullName to text returned of (display dialog "Client full name:" default answer "" with title "New Seller Admin Checklist")
if fullName is "" then return

set AppleScript's text item delimiters to " "
set firstNameDefault to first text item of fullName
set AppleScript's text item delimiters to ""

-- First name is captured for consistency with the other scripts, though this
-- admin script does not use it in task bodies.
set firstName to text returned of (display dialog "First name (for cross-reference with the client list):" default answer firstNameDefault with title "New Seller Admin Checklist")
if firstName is "" then set firstName to firstNameDefault

set listName to fullName & ", Seller Admin"

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
	make new reminder at end of targetList with properties {name:"Text Its Live MLS link to Sellers"}
	make new reminder at end of targetList with properties {name:"Order print materials"}
	make new reminder at end of targetList with properties {name:"Pick Up Print Materials"}
	make new reminder at end of targetList with properties {name:"Add Open House to MLS and Facebook Events"}
	make new reminder at end of targetList with properties {name:"Postcard QR Send Postcards"}
	make new reminder at end of targetList with properties {name:"Share to relevant Facebook Groups"}
	make new reminder at end of targetList with properties {name:"B-Roll Videos / Reels Created"}

	-- [ACTIVE LISTED]
	make new reminder at end of targetList with properties {name:"[ACTIVE LISTED]"}
	make new reminder at end of targetList with properties {name:"Feedback from showings update Sellers"}
	make new reminder at end of targetList with properties {name:"Open House Scheduled / Added as Facebook Event"}
	make new reminder at end of targetList with properties {name:"MLS Stats weekly"}
	make new reminder at end of targetList with properties {name:"Zillow Showcase Stats Report at 2 weeks"}
	make new reminder at end of targetList with properties {name:"Facebook Marketplace Ad"}
	make new reminder at end of targetList with properties {name:"Set up Aligned Showings or adjust if needed"}
	make new reminder at end of targetList with properties {name:"Drop Just Listed boxes 10 or more"}
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
	make new reminder at end of targetList with properties {name:"Schedule Closing notify agent"}
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
end tell

display notification quote & listName & quote & " created in Reminders" with title "Seller Admin Checklist Created"
