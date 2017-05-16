# On the Spot
![Logo](https://raw.githubusercontent.com/Ramesh-P/on-the-spot/master/On%20the%20Spot/Assets.xcassets/AppIcon.appiconset/Icon-60%403x.png)

## Overview
You are looking for a gas station, a parking space, a medical store, a café, or a workshop to repair your car, but the issue is that you are new to that place and you don’t know if there are any, or if so, where they are.

Sometimes finding the most needed service in an unfamiliar city or location will be the most daunting experience we all face. With the right location-aware and map-friendly app you know you can find the best rated restaurant, the nearest ATM, lodging, bar, beauty salon, laundry, or virtually anything that you need which is near you. On the Spot can just do that for you.

What good such an useful app that has so much to offer but is not easy to use, you might ask.

Using On the Spot, you can find your needs with just one tap. Yes, it is that simple. On the Spot knows where you are. Just tap the place type you want to find. Voila! get the list of all the places in the category you tapped on. What is more, know if the place is open or not, and also know how well it is rated.

So the next time when you are on the road looking for a gas station, or in the city looking for a parking space, you know what to do. Powered by Google Maps and Google Places, On the Spot lets you find just about any place within 30 miles around you.

## Specification
On the Spot is built and tested for the following software versions:
* Xcode 8.3
* iOS (minimum) 10.0
* Swift 3.1
* SwiftyJSON 3.1.4

On the Spot is powered by:
* Google Maps SDK for iOS 2.2.0
* Google Places API Web Services 2.2.0

## Preview

## Extra Credit Features
On the Spot includes the following extra credit features:
* The app uses two APIs, namely Google Maps API and Google Places API
* The most recent places search result is saved in core data and is available for offline use
* The app uses SwiftyJSON, an open source library for JSON parsing in Swift

## Key Features
The most outstanding feature of On the Spot is that it lets you search places by just one tap.
* On the Spot is packed with cool features. In the below sections, you can learn more about those features.

### All Places
On the Spot starts with this screen. In this screen, you can view your current location both as address and as coordinates. Your location data is continually updated as you move.

An alphabetic list of 90 place types are presented in tiles.  You can either scroll through this list and choose a place type directly or alternatively enter the place type in the search bar above.

When you enter the place type in the search bar, the list narrows down as you type. This helps you find the place type quickly.

### Selected Places Map
When you select a place type, On the Spot will download a list of 20 places of that type from Google Places and plot them in a map centered to your current location. By tapping on each pin you can find the name and address of the place associated with that pin.

You can specify how places are searched by setting the options. Details of which are described in the *settings* section below.

In the same map, On the Spot will also plot and track in real-time your current location. So you will always know where you are relative to your destination.

You can zoom and scroll the map just as normal. When you tap the **my location** button on the bottom right of the screen, On the Spot will reset the zoom and redraw the map centered to your new current location.

From this screen you will be able to toggle between the map view and the list view which is described in the next section.

### Selected Places List
In this screen, the same 20 places of the selected type are displayed as a list.

Along with name and address of each place, additional information such as rating and if the place is currently open or not is also available.

For your offline use, this list is saved in the memory and will be retained until your next search. You don't need network connection to access the saved list. You can access it through the **saved places** button on the top right of the *all places* screen.

From the list view or from the map view, you can go back to the *all places* screen at anytime by selecting the **back** button from the top left of the screen.

### Settings
In the settings screen you can set your search preferences. Your preferences are saved in the memory and will be retained until you change them.

You can access the settings screen through the **menu** button on the top left of the *all places* screen.

Select **nearby**, if you want to find places based on their distance to your current location and not by their ranking. When nearby is selected, you cannot specify the search radius.

Select **distance**, if you want to search places based on their ranking and not by their distance to your current location. When distance is selected, you must also specify the search radius. Places will be searched only within the search radius you specify.

Google determines ranking of a place based on its relevance, distance, and prominence. Hence ranking is not the same as the public’s rating for that place.

Select the **cancel** button at the top right of the screen to exit the settings screen.

## Authors
* [Ramesh Parthasarathy](mailto:msg.rameshp@gmail.com)

## License

## Credits
