##Example - Tuple Transformations

To map enums use the `JMTransformerProtocol`. Let's look at a dictionary for a business object, and see how we can map the coordinates as a tuple.

**Response Dictionary**

```
{
	'business_uuid'  	 	:  9223123456754775807,
	'business_name'  		: 'UsTwo Restaurant',
	'business_longitude'  	: 40.7053319,
	'business_latitude'   	: -74.0129945,
}
```

For the purposes of the example, let's create a mapper that returns a tuple. First, create an enum to represent the business type for our custom Business Object:


**JSONModelKitTupleCoordinateExampleTransformer Implementation**

```
let longitudeKey    = "business_longitude"
let latitudeKey     = "business_latitude"

public class JSONModelKitTupleCoordinateExampleTransformer : JMTransformerProtocol {

    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {
        if let coordinateDictionary = inputValues as? Dictionary<String, Double> {
            if let unwrappedLongitude = coordinateDictionary[longitudeKey] as? Double {
                if let unwrappedLatitude = coordinateDictionary[latitudeKey] as? Double {
                    return (longitude : unwrappedLongitude, latitude : unwrappedLatitude)
                }
            }
        }
        return nil
    }
}
```

Now that we have created a transformer, let's create mapping for our business Object:

**Business.plist**
<br/>

![alt tag](/documentation/readme_assets/tuple_mapping_example.png?raw=true)
<br/>

After the creation of the mapping, perform a build **(⌘-B)**. The changes should be reflected accordingly in the internal `_Business.swift` class.

```
import Foundation
import JSONModelKit

class _Business {
	var uuid : Double?
	var name : String?
	var coordinates : (longitude : Double, latitude : Double)?

 	required init() {...}

 	convenience init?(_ dictionary: Dictionary<String, Any>) {...}
}
```

After calling the fail-able initializer - or udpateWithDictionary method with a dictioanry representation - JSONModelKit will use the custom transformer to map the tuple accordingly.

Note: The the keys defined in the property mapping correspond to the keys in the dictionary of values passed to the ` public func transformValues(inputValues : Dictionary<String, Any>?) -> Any?` method defined by the protocol.
