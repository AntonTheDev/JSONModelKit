import Foundation


class _TestObjectEight  : NSObject {

	@objc var non_optionalDictionaryType : [String : TestObjectFour]

	var optionalDictionaryType : [String : TestObjectFour]?

	required init(non_optionalDictionaryType  _non_optionalDictionaryType : [String : TestObjectFour])  {

			non_optionalDictionaryType = _non_optionalDictionaryType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary,
												   forType: className!,
												   employing: JMInstantiator.sharedInstance,
												   defaultsEnabled : true)
		{
			let temp_non_optionalDictionaryType : [String : TestObjectFour] = typeCast(valuesDict["non_optionalDictionaryType"])!

			self.init(non_optionalDictionaryType : temp_non_optionalDictionaryType)

			if let unwrapped_optionalDictionaryType : Any = valuesDict["optionalDictionaryType"]  { 
				optionalDictionaryType = typeCast(unwrapped_optionalDictionaryType)! 
			}

		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary,
												   forType: className!,
												   employing: JMInstantiator.sharedInstance,
												   defaultsEnabled : false)
		{
			if let unwrapped_optionalDictionaryType : Any = valuesDict["optionalDictionaryType"]  { 
				optionalDictionaryType = typeCast(unwrapped_optionalDictionaryType)! 
			}

			if let unwrapped_non_optionalDictionaryType : Any = valuesDict["non_optionalDictionaryType"]  { 
				non_optionalDictionaryType = typeCast(unwrapped_non_optionalDictionaryType)! 
			}

 		}
	}
}
