import Foundation


class _TestObjectTen   {

	var non_optionalDictionaryIntType : [String : Int]
    var non_optionalDictionaryDoubleType : [String : Double]
    var non_optionalDictionaryFloatType : [String : Float]
    var non_optionalDictionaryStringType : [String : String]

	var optionalDictionaryIntType : [String : Int]?
    var optionalDictionaryDoubleType : [String : Double]?
    var optionalDictionaryFloatType : [String : Float]?
    var optionalDictionaryStringType : [String : String]?

	required init(non_optionalDictionaryIntType  _non_optionalDictionaryIntType : [String : Int],
    			  non_optionalDictionaryDoubleType  _non_optionalDictionaryDoubleType : [String : Double],
    			  non_optionalDictionaryFloatType  _non_optionalDictionaryFloatType : [String : Float],
    			  non_optionalDictionaryStringType  _non_optionalDictionaryStringType : [String : String])  {

			non_optionalDictionaryIntType = _non_optionalDictionaryIntType
    		non_optionalDictionaryDoubleType = _non_optionalDictionaryDoubleType
    		non_optionalDictionaryFloatType = _non_optionalDictionaryFloatType
    		non_optionalDictionaryStringType = _non_optionalDictionaryStringType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary,
												   forType: className!,
												   employing: JMInstantiator.sharedInstance,
												   defaultsEnabled : true)
		{
			let temp_non_optionalDictionaryIntType : [String : Int] = typeCast(valuesDict["non_optionalDictionaryIntType"])!
    		let temp_non_optionalDictionaryDoubleType : [String : Double] = typeCast(valuesDict["non_optionalDictionaryDoubleType"])!
    		let temp_non_optionalDictionaryFloatType : [String : Float] = typeCast(valuesDict["non_optionalDictionaryFloatType"])!
    		let temp_non_optionalDictionaryStringType : [String : String] = typeCast(valuesDict["non_optionalDictionaryStringType"])!

			self.init(non_optionalDictionaryIntType : temp_non_optionalDictionaryIntType,
    			      non_optionalDictionaryDoubleType : temp_non_optionalDictionaryDoubleType,
    			      non_optionalDictionaryFloatType : temp_non_optionalDictionaryFloatType,
    			      non_optionalDictionaryStringType : temp_non_optionalDictionaryStringType)

			if let unwrapped_optionalDictionaryIntType : Any = valuesDict["optionalDictionaryIntType"]  { 
				optionalDictionaryIntType = typeCast(unwrapped_optionalDictionaryIntType)! 
			}

    		if let unwrapped_optionalDictionaryDoubleType : Any = valuesDict["optionalDictionaryDoubleType"]  { 
				optionalDictionaryDoubleType = typeCast(unwrapped_optionalDictionaryDoubleType)! 
			}

    		if let unwrapped_optionalDictionaryFloatType : Any = valuesDict["optionalDictionaryFloatType"]  { 
				optionalDictionaryFloatType = typeCast(unwrapped_optionalDictionaryFloatType)! 
			}

    		if let unwrapped_optionalDictionaryStringType : Any = valuesDict["optionalDictionaryStringType"]  { 
				optionalDictionaryStringType = typeCast(unwrapped_optionalDictionaryStringType)! 
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
			if let unwrapped_optionalDictionaryIntType : Any = valuesDict["optionalDictionaryIntType"]  { 
				optionalDictionaryIntType = typeCast(unwrapped_optionalDictionaryIntType)! 
			}

    		if let unwrapped_optionalDictionaryDoubleType : Any = valuesDict["optionalDictionaryDoubleType"]  { 
				optionalDictionaryDoubleType = typeCast(unwrapped_optionalDictionaryDoubleType)! 
			}

    		if let unwrapped_optionalDictionaryFloatType : Any = valuesDict["optionalDictionaryFloatType"]  { 
				optionalDictionaryFloatType = typeCast(unwrapped_optionalDictionaryFloatType)! 
			}

    		if let unwrapped_optionalDictionaryStringType : Any = valuesDict["optionalDictionaryStringType"]  { 
				optionalDictionaryStringType = typeCast(unwrapped_optionalDictionaryStringType)! 
			}

			if let unwrapped_non_optionalDictionaryIntType : Any = valuesDict["non_optionalDictionaryIntType"]  { 
				non_optionalDictionaryIntType = typeCast(unwrapped_non_optionalDictionaryIntType)! 
			}

    		if let unwrapped_non_optionalDictionaryDoubleType : Any = valuesDict["non_optionalDictionaryDoubleType"]  { 
				non_optionalDictionaryDoubleType = typeCast(unwrapped_non_optionalDictionaryDoubleType)! 
			}

    		if let unwrapped_non_optionalDictionaryFloatType : Any = valuesDict["non_optionalDictionaryFloatType"]  { 
				non_optionalDictionaryFloatType = typeCast(unwrapped_non_optionalDictionaryFloatType)! 
			}

    		if let unwrapped_non_optionalDictionaryStringType : Any = valuesDict["non_optionalDictionaryStringType"]  { 
				non_optionalDictionaryStringType = typeCast(unwrapped_non_optionalDictionaryStringType)! 
			}

 		}
	}
}

extension _TestObjectTen : CustomDebugStringConvertible {

	var debugDescription: String {

		var debug_string = "TestObjectTen"

			if let unwrapped_optionalDictionaryIntType = optionalDictionaryIntType { 
				if unwrapped_optionalDictionaryIntType.keys.count > 0 {
					for (key, value) in unwrapped_optionalDictionaryIntType {
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
    		if let unwrapped_optionalDictionaryDoubleType = optionalDictionaryDoubleType { 
				if unwrapped_optionalDictionaryDoubleType.keys.count > 0 {
					for (key, value) in unwrapped_optionalDictionaryDoubleType {
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
    		if let unwrapped_optionalDictionaryFloatType = optionalDictionaryFloatType { 
				if unwrapped_optionalDictionaryFloatType.keys.count > 0 {
					for (key, value) in unwrapped_optionalDictionaryFloatType {
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
    		if let unwrapped_optionalDictionaryStringType = optionalDictionaryStringType { 
				if unwrapped_optionalDictionaryStringType.keys.count > 0 {
					for (key, value) in unwrapped_optionalDictionaryStringType {
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
			
			if non_optionalDictionaryIntType.keys.count > 0 {
				for (key, value) in non_optionalDictionaryIntType {
					debug_string += "              - [ "
					debug_string += "\(key)"
					debug_string += " : "
					debug_string += "\(value)"
					debug_string += " ]"
				}
			} else {
				debug_string += "[ : ]"
			}    		
			if non_optionalDictionaryDoubleType.keys.count > 0 {
				for (key, value) in non_optionalDictionaryDoubleType {
					debug_string += "              - [ "
					debug_string += "\(key)"
					debug_string += " : "
					debug_string += "\(value)"
					debug_string += " ]"
				}
			} else {
				debug_string += "[ : ]"
			}    		
			if non_optionalDictionaryFloatType.keys.count > 0 {
				for (key, value) in non_optionalDictionaryFloatType {
					debug_string += "              - [ "
					debug_string += "\(key)"
					debug_string += " : "
					debug_string += "\(value)"
					debug_string += " ]"
				}
			} else {
				debug_string += "[ : ]"
			}    		
			if non_optionalDictionaryStringType.keys.count > 0 {
				for (key, value) in non_optionalDictionaryStringType {
					debug_string += "              - [ "
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
