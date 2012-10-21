:Goal of this Rails App

	To display data from the Washington Post Issues Engine API and NPR Story API. I would prefer to
	not 'bother' the API's for every request a user makes - instead I would like to copy all the data
	to a relational database on the server which this app would run on. 
	
:To-Do List

	1. Can land on details page, need to tweak view ruby code.
	2. Make a reusable process to just get any NEW issues/statements from the WaPo Issue Engine API
	3. Address Errno::ECONNRESET occurring during API data retrieval
	