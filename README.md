:Goal of this Rails App

	To display data from the Washington Post Issues Engine API and NPR Story API. I would prefer to
	not 'bother' the API's for every request a user makes - instead I would like to copy all the data
	to a relational database on the server which this app would run on. 
	
:To-Do List

	1. Can land on details page, need to tweak view ruby code.
	2. Make a reusable process to just get any NEW issues/statements from the WaPo Issue Engine API
	3. Address Errno::ECONNRESET occurring during API data retrieval
	4. Clean up and refactor code 
	5. Use Rails.logger more intelligently
	6. Clean up Statements view so that there is a more even distribution of whitespace to please the eyes. :)
	
:Shortcomings

	1. When a statement from the Issue Engine does not return any entities from the Trove API, I choose not to display it.
	   This is because I use each category to try and show 'relevant' links.