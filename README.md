:Goal of this Rails App

	To display data from the Washington Post Issues Engine API and NPR Story API. I would prefer to
	not 'bother' the API's for every request a user makes - instead I would like to copy all the data
	to a relational database on the server which this app would run on. 
	
:To-Do List

	1. Figure out how to use rails_runner and create a method/class which can pre-populate the database
	2. Make a method which is smart enough to just get any NEW issues from the WaPo Issue Engine API
	3. Remove hard-coded issue engine API urls