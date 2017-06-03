##Example - Struct Transformations

To map enums use the `JMTransformerProtocol`. Let's look at a dictionary for a business object, and see how we can map an enum to represent a struct for the coordinates:

**Response Dictionary**

```swift
{
	'business_uuid'  	 	:  9223123456754775807,
	'business_name'  		: 'UsTwo Restaurant',
	'business_longitude'  	: 40.7053319,
	'business_latitude'   	: -74.0129945,
}
```

Unlike the model objects, JSONModelKit does not autogenerate structs, due to the lack of inheritance. Structs would be un-customizable if it did, and would prevent the developer from using the many features Swift offers with structs. For the purposes of this example, let assume that we created a struct to represent the coordinates for our custom Business Object.

**Struct Definition**

```swift
struct Coordinate {
  	var longitude: Double
   	var latitude: Double
}
```

Once we have defined a Coordinate struct, let's create a mapper that parses out the values from the response and return the value of Coordinate type.

**JSONModelKitCoordinateTransformer Implementation**

```swift
let longitudeKey    = "longitude"
let latitudeKey     = "latitude"

public class JSONModelKitCoordinateTransformer : JMTransformerProtocol {

    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {

        if let coordinateDictionary = inputValues as? Dictionary<String, Double> {
            if let unwrappedLongitude = coordinateDictionary[longitudeKey] {
                if let unwrappedLatitude = coordinateDictionary[latitudeKey] {
                    return Coordinate(longitude : unwrappedLongitude, latitude : unwrappedLatitude)
                }
            }
        }

        return nil
    }
}
```

Now that we have created a transformeer, let's create some mapping for our business Object:

**Business.plist**
<br/>

![alt tag](/documentation/readme_assets/struct_example_plist.png?raw=true)
<br/>

After the creation of the mapping, perform a build **(⌘-B)**. The changes should be reflected accordingly in the internal `_Business.swift` class.


```swift
import Foundation
import JSONModelKit

class _Business {
	var uuid : Double?
	var name : String?
	var coordinates : Coordinates?

 	required init() {...}

 	convenience init?(_ dictionary: Dictionary<String, Any>) {...}
}
```

After calling the fail-able initializer - or udpateWithDictionary method with a dictionary representation - JSONModelKit will use the custom transformer to map the struct accordingly.

Note: The the keys defined in the property mapping correspond to the keys in the dictionary of values passed to the ` public func transformValues(inputValues : Dictionary<String, Any>?) -> Any?` method defined by the protocol.
