import Foundation


class _TestObjectEight   {

	var non_optionalDictionaryType : [String : TestObjectFour]

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

extension _TestObjectEight : CustomDebugStringConvertible {

	var debugDescription: String {

		var debug_string = "[TestObjectEight]\n"

			if let unwrapped_optionalDictionaryType = optionalDictionaryType { 
				if unwrapped_optionalDictionaryType.keys.count > 0 {
					for (key, value) in unwrapped_optionalDictionaryType {
						debug_string += "              - [ "
						debug_string += "\(key)"
						debug_string += " : "
						debug_string += "\(value)"
						debug_string += " ]"
					}
				} else {
					debug_string += "[ : ]"
				}
			}
			
			if non_optionalDictionaryType.keys.count > 0 {
				for (key, value) in non_optionalDictionaryType {
					debug_string += "\n              - [ "
					debug_string += "\(key)"
					debug_string += " : "
					debug_string += "\(value)"
					debug_string += " ]"
				}
			} else {
				debug_string += "[ : ]"
			}

			debug_string += "\n"

			return debug_string
	}
}
