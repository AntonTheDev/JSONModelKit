[![Platform](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos-lightgrey.svg)](https://github.com/AntonTheDev/JSONModelKit/)
[![Cocoapods Compatible](https://img.shields.io/badge/pod-v1.0.0-blue.svg)](https://cocoapods.org/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
<br/><br/>
[![Build Status](https://travis-ci.org/AntonTheDev/JSONModelKit.svg?branch=dev)](https://travis-ci.org/AntonTheDev/JSONModelKit)
[![License](https://img.shields.io/badge/license-MIT-343434.svg)](https://github.com/AntonTheDev/JSONModelKit/)


# JSONModelKit

## Introduction

JSONModelKit uses a JSON, or Plist, mapping file to generate flexible data models against API. JSONModelKit differs from other mapping frameworks by taking an API-centric focus by mapping a model's properties against dictionary's keys. Once the model definition is created, JSONModel kit automatically generate, and add the model files to the project ready to use.

The benefits to this approach ensures that the model continuously stays in sync with the API in a single place, which in return allows for the development effort to focus on using MVVM, and Protocol Oriented Programming paradigms for maximum flexibility in the development lifecycle.

## Features

- [X] Auto-Model Generation .json/.plists configuration files
- [X] String, Int, Double, Float, Bool, Array, Dictionary
- [X] Optional & Non-Optional Property Support:
	* Native Types: String, Int, Double, Float, Bool, Array, Dictionary
	* Collections Types: Array\<AnyObject\>, Dictionary\<String, AnyObject\>
	* Structs, Enums, Closures, Tuples via Transformations
- [X] Mapping Nested Values
- [X] Predefined Default Values

## Installation

* **Requirements** : XCode 8.0+, iOS 8.0+, OSX 10.9+, tvOS 9.0+
* [Installation Instructions](/documentation/installation.md)
* [Release Notes](/documentation/changelog.md)

## Communication

- If you **found a bug**, or **have a feature request**, open an issue.
- If you **need help** or a **general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/json-mapperkit). (tag 'json-mapperkit')
- If you **want to contribute**, review the [Contribution Guidelines](/Documentation/CONTRIBUTING.md), and submit a pull request.

## Basic Use

Once configured per the [Installation](/documentation/installation.md) instructions, run the build script once **⌘+B**. Navigate to your project directory and notice that the script generated the following inside the base directory of your project.

<p align="center">
<img align="center"  src="https://github.com/AntonTheDev/JSONModelKit/blob/dev/documentation/readme_assets/folder_structure.png?raw=true" width="378" height="134" />
</p>

All JSON Mappings will go into the Mappings directory from this point forward, and your Classes will be generated into the Model directory, and automatically added to your project during build time.

**NOTE: Every time a new mapping configurations is added, the first build will always be canceled by Xcode, and will need to run again. This is due to the project file changing in the middle of a build, since a new file is added. If not new mapping is added, it will build as usual**


#### Simple Example

Let look as a simple mapping that defines a class below in JSON.

```
Input File: JSOModelKit/Mappings/Business.json

{
	"uuid" : {						 
		"key" : "identifier",		 
		"type" : "Double",			 
		"nonoptional" : "true"		 
	},
	"businessName" : {
		"key" : "business_name",
		"type" : "String"			
	},
	"ratings" : {
		"key" : "ratings",
		"type" : "Array",			
		"subtype" : "Float"			
	},
	"metaTags" : {
		"key" : "metadata.tags",
		"type" : "Array",			
		"subtype" : "Float"			
	},
	"locations" : {
		"key" : "locations",
		"type" : "Array",			
		"subtype" : "Coordinate"
	},
	"dateOpened" : {
		"key" : "grand_opening_date",		
		"type" : "Date",					
		"transformer" : "DateTransformer"
	}
}

```
Run the build script once **⌘+B**. and you will see that it generated the following files in the output directory. This will also be reflected in the Project structure within the **Model** group

<p align="center">
<img align="center"  src="https://github.com/AntonTheDev/JSONModelKit/blob/dev/documentation/readme_assets/genrerated_folder_structure.png?raw=true" width="414" height="206" />
</p>


Observe the internal file that was generated

```
class _Business  {

	var uuid : Double

	var metaTags : [Float]?
	var ratings : [Float]?
	var locations : [Coordinate]?
	var dateOpened : Date?
	var businessName : String?

	..........

	required init(uuid  _uuid : Double)  {
		// Required init with all non-optionals defined
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
		// Failable initializer, returns nil when any non-optional values is not defined
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {
		// Helper methods to updated an instance with a new dictionary of values
	}
}

```

Once a JSON response is received call the following method, and all the properties will be parsed and mapped accordingly.

```
let newInstance = TestModelObject(dataDictionary)
```

## License

*JSONModelKit is released under the MIT license. See [License](/LICENSE.md) for details.*
