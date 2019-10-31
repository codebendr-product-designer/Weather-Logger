# Weather Logger
My final project for the Udacity iOS Nanodegree

## Purpose of the app
The purpose of Weather Logger is for users to save weather conditions in their current location or by using a map. Users can view, save and delete weather conditions from their current location or by using a map. 

## Using the app
* The app starts with an alert letting the user know to use the add button to start logging locations.
* When the add button is pressed, a request user location permission is presented to the user to choose from.
* The options available are Allow While Using App, Allow Once, Don't Allow
* When "Allow While Using App" option is selected, the app pulls the users current location
* When "Allow Once" option is selected, the app pulls the users current location but does that for the current app session and doesn't persist the location when the app is restarted

## Plans for future versions

* Improve Code Readability by using an Architecture like MVVM.
* Improve Code Readability by using the SOLID principle.
* Leverage of generics and call backs to add modularity to codebase 
* Add functionality to pull photos and forecast data for a saved location.
* Add a library like Alomofire and Kingfisher to manage caching and network calls 

