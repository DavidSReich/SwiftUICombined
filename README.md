
# SwiftUICombined

What is **SwiftUICombined**?  

It's **SwiftUIReference** meets Combine.  
**SwiftUIReference** is **GiphyTags** meets SwiftUI.  

This is a SwiftUI reference app based upon **GiphyTags** and then updated with Combine.  

It is written in Swift 5 and Xcode Version 11.4.1 (11E503a)  

## Overview  
This app queries the GIPHY website via its URL API interface, and uses the tags returned to search deeper and deeper.  
(This isn't necessarily a good thing!)  
To use the app you will need to get an API key from <https://developers.giphy.com/dashboard/?create=true>.  
The app can open the Giphy website and take you there.

## SwiftUICombined changes

Dropped `Alamofire` and `RxSwift`.  
Networking uses `URLSession.dataTaskPublisher` and uses `AnyPublisher<>` for most networking objects.  
The SolitaryViewModel is now an `ObservableObject` for slightly more efficient integration with SwiftUI.

## SwiftUI  
### The main full screen view uses:  
* A view model (MVVM)  
* Loading activity indicator  
* `Alert` views  
* Navigation bar items that vary with changes in the view model  
* Sheet views to present modal views - which interact with the view model  
* Navigation to a detail view.  
 * Master-detail was not implmented because it has selection and detail view update problems on iPads and landscape iPhones when the data changes.

### Additional large views  
* A SwiftUI launch screen view  
* A detail view  
* A settings view - displayed as a `sheet`  
* A multiple selection view - displayed as a `sheet`  

### UIKit wrappers  
* `UIViewRepresentable` wrapper around `UIActivityIndicatorView`  
* `UIViewRepresentable` wrapper around `UIImageView`  

## `Combine`  
* `ObservableObject` and `ObservedObject`  
* Publishers  

## Extensions  
* Generic `Data` extensions for both `Result<>` and `AnyPublisher<>`  
 * `func decodeData<T: Decodable>() *> Result<T, ReferenceError>`  
 * `func decodeData<T: Decodable>() *> AnyPublisher<T, ReferenceError>`  

* `HTTPURLResponse` extension  
 * `HTTPURLResponse.validateData(Data, URLResponse, ...) *> AnyPublisher<Data, ReferenceError>`  

## Networking  
* `NetworkService.getDataPublisher() *> AnyPublisher<Data, ReferenceError>`  
 * using `URLSession.dataTaskPublisher`  
