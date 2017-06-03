## Example - Complex Value Types
JSONModelKit's support for mapping complete types allows for creating object types as other objects generated. Let's assume in the example below that the business listing result returns a sub-dictionary for a location, and we would like to store it as a Location type.

**Response Dictionary**

```swift
{
	'business_uuid'  	 :  9223123456754775807,
	'business_name'  	 : 'UsTwo Restaurant',
	'business_rating' 	 :  5,
	'business_location   :
		{
			'longitude' : 40.7053319,
			'latitude'  : -74.0129945
		},					
	'business_open'    	 : 1
}
```

First, create a model mapping for the Location object.

```swift
Input File: JSOModelKit/Mappings/Location.json

{
		"longitude" : {
				"key" : "longitude",
				"type" : "Double"
		}
    "latitude" : {
        "key" : "latitude",
        "type" : "Double"
    }
}
```

Once the model mapping for a location has generated a `Location` object, and it has been added to the project, update the Business object mapping by defining a location property typed as **Location**

```swift
Input File: JSOModelKit/Mappings/Business.json

{
    "uuid" : { ... },
    "businessName" : { ... },
    "ratings" : { ... },
    "metaTags" : { ... },
    "open" : { ... }
		"location" : {
        "key" : "business_location",
        "type" : "Location"
    },
}
```


When parsing the data for a `Business` object, JSONModelKit will create a `Location` instance, and will assign the resulting value to the location property of the `Business` instance before returning it :)
