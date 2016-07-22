import Foundation

class _TestObjectNine  {	

	var non_optionalArrayIntType : [Int]
    var non_optionalArrayDoubleType : [Double]
    var non_optionalArrayFloatType : [Float]
    var non_optionalArrayStringType : [String]
	
var optionalArrayDoubleType : [Double]?
    var optionalArrayIntType : [Int]?
    var optionalArrayStringType : [String]?
    var optionalArrayFloatType : [Float]?

	required init(non_optionalArrayIntType  _non_optionalArrayIntType : [Int],
    			  non_optionalArrayDoubleType  _non_optionalArrayDoubleType : [Double],
    			  non_optionalArrayFloatType  _non_optionalArrayFloatType : [Float],
    			  non_optionalArrayStringType  _non_optionalArrayStringType : [String])  {
 	
						non_optionalArrayIntType = _non_optionalArrayIntType
    					non_optionalArrayDoubleType = _non_optionalArrayDoubleType
    					non_optionalArrayFloatType = _non_optionalArrayFloatType
    					non_optionalArrayStringType = _non_optionalArrayStringType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : true) {
			
			let temp_non_optionalArrayIntType : [Int] = typeCast(valuesDict["non_optionalArrayIntType"])!
    		let temp_non_optionalArrayDoubleType : [Double] = typeCast(valuesDict["non_optionalArrayDoubleType"])!
    		let temp_non_optionalArrayFloatType : [Float] = typeCast(valuesDict["non_optionalArrayFloatType"])!
    		let temp_non_optionalArrayStringType : [String] = typeCast(valuesDict["non_optionalArrayStringType"])!

			self.init(non_optionalArrayIntType : temp_non_optionalArrayIntType,
    			      non_optionalArrayDoubleType : temp_non_optionalArrayDoubleType,
    			      non_optionalArrayFloatType : temp_non_optionalArrayFloatType,
    			      non_optionalArrayStringType : temp_non_optionalArrayStringType) 
		
			if let unwrapped_optionalArrayDoubleType : Any = valuesDict["optionalArrayDoubleType"]  { 
				optionalArrayDoubleType = typeCast(unwrapped_optionalArrayDoubleType)! 
			}

    		if let unwrapped_optionalArrayIntType : Any = valuesDict["optionalArrayIntType"]  { 
				optionalArrayIntType = typeCast(unwrapped_optionalArrayIntType)! 
			}

    		if let unwrapped_optionalArrayStringType : Any = valuesDict["optionalArrayStringType"]  { 
				optionalArrayStringType = typeCast(unwrapped_optionalArrayStringType)! 
			}

    		if let unwrapped_optionalArrayFloatType : Any = valuesDict["optionalArrayFloatType"]  { 
				optionalArrayFloatType = typeCast(unwrapped_optionalArrayFloatType)! 
			}

		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : false) {

			if let unwrapped_optionalArrayDoubleType : Any = valuesDict["optionalArrayDoubleType"]  { 
				optionalArrayDoubleType = typeCast(unwrapped_optionalArrayDoubleType)! 
			}

    		if let unwrapped_optionalArrayIntType : Any = valuesDict["optionalArrayIntType"]  { 
				optionalArrayIntType = typeCast(unwrapped_optionalArrayIntType)! 
			}

    		if let unwrapped_optionalArrayStringType : Any = valuesDict["optionalArrayStringType"]  { 
				optionalArrayStringType = typeCast(unwrapped_optionalArrayStringType)! 
			}

    		if let unwrapped_optionalArrayFloatType : Any = valuesDict["optionalArrayFloatType"]  { 
				optionalArrayFloatType = typeCast(unwrapped_optionalArrayFloatType)! 
			}

			if let unwrapped_non_optionalArrayIntType : Any = valuesDict["non_optionalArrayIntType"]  { 
				non_optionalArrayIntType = typeCast(unwrapped_non_optionalArrayIntType)! 
			}

    		if let unwrapped_non_optionalArrayDoubleType : Any = valuesDict["non_optionalArrayDoubleType"]  { 
				non_optionalArrayDoubleType = typeCast(unwrapped_non_optionalArrayDoubleType)! 
			}

    		if let unwrapped_non_optionalArrayFloatType : Any = valuesDict["non_optionalArrayFloatType"]  { 
				non_optionalArrayFloatType = typeCast(unwrapped_non_optionalArrayFloatType)! 
			}

    		if let unwrapped_non_optionalArrayStringType : Any = valuesDict["non_optionalArrayStringType"]  { 
				non_optionalArrayStringType = typeCast(unwrapped_non_optionalArrayStringType)! 
			}

 		} 
	}
} 

extension _TestObjectNine {
    enum _TestObjectFourSerializationEnum: String { 
		 case _update		= "update"
    }
    
    func params(forGroup group : String) -> [String : Any] {
        if let groupType = _TestObjectFourSerializationEnum(rawValue: group) {
            switch groupType {
			case ._update:
				return serializedupdate()
            }
        }
        
        print("Group \(group) not defined, check your spelling or define in your mapping for class : TestObjectNine")
        
        return [String : Any]()
    }

	private func serializedupdate() -> [String : Any] { 
		var params = [String : Any]()

		params["optional_array_int_type"] = optionalArrayIntType
		params["optional_array_string_type"] = optionalArrayStringType
		params["non_optional_array_float_type"] = non_optionalArrayFloatType
		params["non_optional_array_double_type"] = non_optionalArrayDoubleType
		params["non_optional_array_int_type"] = non_optionalArrayIntType
		params["non_optional_array_string_type"] = non_optionalArrayStringType
		params["optional_array_double_type"] = optionalArrayDoubleType
		params["optional_array_float_type"] = optionalArrayFloatType

		return params
	}

}