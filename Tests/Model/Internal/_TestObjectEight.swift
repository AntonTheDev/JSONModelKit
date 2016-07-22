import Foundation

class _TestObjectEight  {	

	var non_optionalDictionaryType : [String : TestObjectFour]
	
var optionalDictionaryType : [String : TestObjectFour]?

	required init(non_optionalDictionaryType  _non_optionalDictionaryType : [String : TestObjectFour])  {
 	
						non_optionalDictionaryType = _non_optionalDictionaryType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : true) {
			
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

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : false) {

			if let unwrapped_optionalDictionaryType : Any = valuesDict["optionalDictionaryType"]  { 
				optionalDictionaryType = typeCast(unwrapped_optionalDictionaryType)! 
			}

			if let unwrapped_non_optionalDictionaryType : Any = valuesDict["non_optionalDictionaryType"]  { 
				non_optionalDictionaryType = typeCast(unwrapped_non_optionalDictionaryType)! 
			}

 		} 
	}
} 

extension _TestObjectEight {
    enum _TestObjectFourSerializationEnum: String { 
		 case _delete		= "delete"
    }
    
    func params(forGroup group : String) -> [String : Any] {
        if let groupType = _TestObjectFourSerializationEnum(rawValue: group) {
            switch groupType {
			case ._delete:
				return serializeddelete()
            }
        }
        
        print("Group \(group) not defined, check your spelling or define in your mapping for class : TestObjectEight")
        
        return [String : Any]()
    }

	private func serializeddelete() -> [String : Any] { 
		var params = [String : Any]()


		if let dictionary = params["non_optional_sub_object_dictionary"] as?  [String : TestObjectFour] { 
			var newDict = [String : Any]()

			for (key, value) in dictionary {
				newDict[key] = value.params(forGroup :"delete")  
			}

			return newDict
		}

		if let dictionary = params["optional_sub_object_dictionary"] as?  [String : TestObjectFour] { 
			var newDict = [String : Any]()

			for (key, value) in dictionary {
				newDict[key] = value.params(forGroup :"delete")  
			}

			return newDict
		}

		return params
	}

}