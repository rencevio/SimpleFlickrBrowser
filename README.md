# Flickr photo browser app

Displays a continuous feed of photos posted to [Flickr]([https://www.flickr.com/](https://www.flickr.com/)) with ability to specify a search criteria.

## Developer notes
The app was developed based on [Clean Swift/VIP](https://clean-swift.com/) architecture.

Two VIP scenes are defined in the app:
* **Browser** - Encapsulates a collection view, manages photo metadata retrieval, search and refresh controls.
* **BrowserCell** - Represents a collection view cell as a part of **Browser**'s collection view. Responsible for fetching of the photo's data and handling of the cell recycle mechanics.

Apart from the scenes, the core of the app also consists of services that facilitate image retrieval and caching:
* **FlickrApiServices** - OO wrappers around [Flickr's API](https://www.flickr.com/services/api/). Currently contains only **FlickrPhotosService**.
* **PhotoCollectionFetcher** - responsible for retrieving metadata of recent photos or photos that match a given search criteria.
* **PhotoDataProvider** - responsible for fetching photo data from a given URL as well as data caching.

Data retrieval, image caching and API communication were implemented in a way that would allow developers to easily substitute them with another solution as dictated by _Liskov Substitution Principle_.

All critical parts of the app have UT coverage.

## Improvements to consider
* Image caching is implemented using [NSCache](https://developer.apple.com/documentation/foundation/nscache). While it gets the job done, NSCache does not always behave in a predictable manner. It could be substituted by custom solution, or, better yet, an acknowledged one, e.g. [Kingfisher](https://github.com/onevcat/Kingfisher)
* When a collection view cell gets reused it requests a new image. The old request, though, still goes through. While that is accounted for, it might be desirable to cancel the old request to save some traffic.
* UT coverage can be improved even further.

