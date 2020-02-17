# SwiftUIReference

What is SwiftUIReference?

This is a SwiftUI reference app based upon GiphyTags.

It's GiphyTags meets SwiftUI!!

It is written in Swift 5 and Xcode 11.4 beta (11N111s).

It queries the GIPHY website via its URL interface, and uses the tags returned to search deeper and deeper.  (This isn't necessarily a good thing.)

GIPHY Tags uses lots of Swift and iOS features:  

* classes and structs  
* protocols  
* extensions  
* computed properties  

SwiftUI changes:

UIImageView is now wrapped in a UIViewRepresentable.
The Storyboard is gone.
All Segues are gone.
All Navigation is driven by @State changes

Asynch REST
Unit Test
Information hiding

It also has:

Most results/respones now use Result<T, ReferenceError> objects.

Data:

* DataModel classes - improved and Decodable for easier conversion from Data to objects.
* DataSource class (contains DataModel protocols)

Networking:

* URLSession dataTask extension
* Alamofire Session dataTask extension
* HTTPURLResponse validation extension
* Data decode<T> extension
* JSONNetwork services - on top of URLSession and Session - both with and without an RxSwift wrapper

Managers:

* DataManager -
    * invokes JSONNetwork services
    * uses results to create DataModels
    * passes DataModels to DataSource
    * hides all of that behind a DataManagerProtocol
* ViewManager - is gone!
    * SwiftUI now synthesizes UITableViewDataSource, UITableViewDelegate, etc.
* UserDefaultsManager
* ViewControllers - are gone -- replaced by SwiftUI Views
* Screen Views -
    * Main
    * Image (detail)
    * Settings
    * Tag Selector
* Resuable UIViews - are gone -- replaced by more SwiftUI Views
* Views -
    * Row View
    * Image Views - animated gif and asynch image
