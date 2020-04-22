
# SwiftUICombined

What is SwiftUICombined?

It's SwiftUIReference meets Combine.

This is a SwiftUI reference app based upon GiphyTags and then updated with Combine.

It's GiphyTags meets SwiftUI!!

It is written in Swift 5 and Xcode Version 11.4.1 (11E503a)

Issues:
1. On a slower device -- like an iPhone on a 3G service with just one or two bars -- loading the images can take so long that the user interface becomes unresponsive.

It queries the GIPHY website via its URL interface, and uses the tags returned to search deeper and deeper.  (This isn't necessarily a good thing.)  To use the app you will need to get an API key.  The app can open the Giphy website and take you there.

SwiftUICombined changes:

Dropped Alamofire and RxSwift.
Networking uses URLSession.dataTaskPublisher and uses AnyPublisher<> for most networking objects.
The SolitaryViewModel is now and ObservableObject for slightly better integration with SwiftUI.
