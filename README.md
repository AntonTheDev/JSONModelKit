
[![Cocoapods Compatible](https://img.shields.io/badge/pod-1.0.0-blue.svg)](https://cocoapods.org/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/AntonTheDev/JSONModelKit.svg?branch=dev)](https://travis-ci.org/AntonTheDev/JSONModelKit)
[![Platform](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos%20%7C%20watchos-lightgrey.svg)](https://github.com/AntonTheDev/JSONModelKit/)
[![License](https://img.shields.io/badge/license-MIT-343434.svg)](https://github.com/AntonTheDev/JSONModelKit/)
[![Join the chat at https://gitter.im/AntonTheDev/JSONModelKit](https://badges.gitter.im/AntonTheDev/JSONModelKit.svg)](https://gitter.im/AntonTheDev/JSONModelKit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


# JSONModelKit
![alt tag](/documentation/readme_assets/mapperkit_header.png?raw=true)
JSONModelKit is an API centric mapping framework that uses, JSON or Plist, mapping files to define a model against an arbitrary dictionary. At build time, the library will generate the model files based on the definitions, and add them to the project automatically, or update any existing files.

By reducing the focus on the model layer itself, and keeping it continuously in sync with an API response in a single place, we can now treat the model as just a "data bucket", and extend it as needed. It comes really handy when implementing MVVM as part of a project's architecture, as it basically reduces the model(s) to ingestible wrapper(s) around dictionary data.

## Features

- [X] Auto-Model Generation .json/.plists configuration files
- [X] Optional & Non-Optional Property Mapping:
	* String, Int, Double, Float, Bool, Array, Dictionary
	* Collections Types: Array, Dictionary
	* Structs, Enums, Closures, Tuples via Transformations
- [X] Supports Nested Types
- [X] Mapping Nested Values
- [X] Predefine Default Values

## Installation

* **Requirements** : XCode 8.0+, iOS 8.0+, OSX 10.9+, tvOS 9.0+
* [Installation Instructions](https://github.com/AntonTheDev/JSONModelKit/wiki/Installation)
* [Release Notes](https://github.com/AntonTheDev/JSONModelKit/wiki/Release-Notes)

## Communication

- If you **found a bug**, or **have a feature request**, open an issue.
- If you **need help** or a **general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/json-modelkit). (tag 'json-modelkit')
- If you **want to contribute**, review the [Contribution Guidelines](https://github.com/AntonTheDev/JSONModelKit/wiki/Contributing-Guidelines), and submit a pull request.

## Basic Use

Once configured per the [Installation](https://github.com/AntonTheDev/JSONModelKit/wiki/Installation.md) instructions, run the build script once **⌘+B**. You will see the Model folder appears within your project.


All JSON Mappings will go into the **Model/Mappings** directory, and your Classes will be generated into the Model directory, then automatically added to your project during build time.

### Simple Example

Let look as a simple mapping that defines a class below in JSON.

```swift
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
        "subtype" : "Double"
    },
    "metaTags" : {
        "key" : "metadata.tags",
        "type" : "Array",
        "subtype" : "String"
    },
    "open" : {
        "key" : "open",
        "type" : "Bool",
        "default" : "0"
    }
}
```
Run the build script once **⌘+B**. and you will see that it generated the following files in the output directory. This will also be reflected in the Project structure within the **Model** group

**NOTE: Every time a new mapping configurations is added, the following build will always be canceled by Xcode, and needs to be run again. This is due to the project file changing in the middle of a build, since a new file is added. If no new mapping is added, it will build as usual**

<p align="center">
<img align="center"  src="https://github.com/AntonTheDev/JSONModelKit/blob/dev/documentation/readme_assets/genrerated_folder_structure.png?raw=true" width="286" height="196" />
</p>


Observe the internal file that was generated

```swift
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

### More Examples

Below is a list of examples for the supported features by JSONModelKit. Each provides an overall view on how to setup the model mapping file, and short examples of the outputs generated by pre-packaged script within the framework.

* [Optionals](https://github.com/AntonTheDev/JSONModelKit/wiki/Optional-Value-Types)
* [Non-Optionals](https://github.com/AntonTheDev/JSONModelKit/wiki/Non-Optional-Value-Types)
* [Collections](https://github.com/AntonTheDev/JSONModelKit/wiki/Collection-Types)
* [Custom Types](https://github.com/AntonTheDev/JSONModelKit/wiki/Custom-Types)
* [Custom Transformers](https://github.com/AntonTheDev/JSONModelKit/wiki/Custom-Transformations)
  * [Structs](https://github.com/AntonTheDev/JSONModelKit/wiki/Struct-Transformations)
  * [Enum](https://github.com/AntonTheDev/JSONModelKit/wiki/Enum-Transformations)
  * [Closures](https://github.com/AntonTheDev/JSONModelKit/wiki/Closure-Transformations)
  * [Tuples](https://github.com/AntonTheDev/JSONModelKit/wiki/Tuple-Transformations)

## License

*JSONModelKit is released under the MIT license. See [License](/LICENSE.md) for details.*
