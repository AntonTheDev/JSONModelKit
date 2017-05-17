## Example - Closure Transformations

A closure is mapped by using a custom transformer implementing the `JMTransformerProtocol`. Let's look at a dictionary for a business object, and see how we can map a function/closure.

**Response Dictionary**

```
{
	'business_uuid'  	 				: 9223123456754775807,
	'business_name'  					: 'Somewhere Epic',
	'business_facebook_id'  	: '123456789323123',
	'business_yelp_id'  			: '409283409238409',
}
```
Let's create a mapper that parses out the values from the response which, based on the identifier, returns the closure:

**JSONModelKitSocialClosureTransformer Implementation**

```
import Foundation
import UIKit

let facebookIDKey = "facebook_id"
let yelpIDKey     = "yelp_id"

public class JSONModelKitSocialClosureTransformer : US2TransformerProtocol {

    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {

				if let facebookdentifier = inputValues![facebookIDKey] as? String {

      			func routeToFacebookApp() {

    						if UIApplication.sharedApplication().openURL(NSURL(string:"fb://")!) {
       							let facebookAppLink = "fb://profile/\(facebookdentifier)"
        						UIApplication.sharedApplication().openURL(NSURL(string: facebookAppLink)!)
    						} else {
        						let itunesLink = "itms://itunes.apple.com/us/app/apple-store/id284882215?mt=8"
        						UIApplication.sharedApplication().openURL(NSURL(string: itunesLink)!)
    						}
						}

						return routeToFacebookApp
      	}

        if let yelpIdentifier = inputValues![yelpIDKey] as? String {

            	func routeToFacebookApp() {

	    						if UIApplication.sharedApplication().openURL(NSURL(string:"yelp://")!) {
	        						let yelpAppLink = "yelp:///biz/\(yelpIdentifier)"
        							UIApplication.sharedApplication().openURL(NSURL(string:yelpAppLink)!)
    							} else {
        							let itunesLink = "itms://itunes.apple.com/us/app/apple-store/id284910350?mt=8"
        							UIApplication.sharedApplication().openURL(NSURL(string: itunesLink)!)
   				 				}
							}

            	return routeToYelpApp
        }

        return nil
    }
}
```

Now that we have created a transformer, let's create some mapping to map our closures to an instance variable.

```
Input File: JSOModelKit/Mappings/Business.json

{
    "uuid" : { ... },
    "name" : { ... },
		"open" : { ... },
    "routeToFacebook" : {
			  "transformer" : "JSONModelKitSocialClosureTransformer",
        "key" : {
					"type": "facebook_id"
				}
    },
    "routeToYelp" : {
				"transformer" : "JSONModelKitSocialClosureTransformer",
				"key" : {
					"type": "yelp_id"
				}
    }
}
```

After the creation of the mapping, perform a build **(⌘-B)**. The changes should be reflected accordingly in the internal `_Business.swift` class.


```
import Foundation
import JSONModelKit

class _Business {
	var uuid : Double?
	var name : String?
	var routeToFacebook : (() -> Void)?
	var routeToYelp : (() -> Void)?

 	required init() {...}

 	convenience init?(_ dictionary: Dictionary<String, Any>) {...}
}
```

After calling the fail-able initializer - or updateWithDictionary method with a dataDictionary representation - JSONMapperKit will use the custom transformer to map the custom closure accordingly. Although this is a simple and abstract scenario, the potential for this functionality has many outcomes to be explored.

Note: The the keys defined in the property mapping correspond to the keys in the dictionary of values passed to the ` public func transformValues(inputValues : Dictionary<String, Any>?) -> Any?` method defined by the protocol.
