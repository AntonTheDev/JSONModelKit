import Foundation

class _TestObjectFive  {	

	var non_optionalSubType : TestObjectThree
	
var optionalSubType : TestObjectThree?

	required init(non_optionalSubType  _non_optionalSubType : TestObjectThree)  {
 	
						non_optionalSubType = _non_optionalSubType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : true) {
			
			let temp_non_optionalSubType : TestObjectThree = typeCast(valuesDict["non_optionalSubType"])!

			self.init(non_optionalSubType : temp_non_optionalSubType) 
		
			if let unwrapped_optionalSubType : Any = valuesDict["optionalSubType"]  { 
				optionalSubType = typeCast(unwrapped_optionalSubType)! 
			}

		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : false) {

			if let unwrapped_optionalSubType : Any = valuesDict["optionalSubType"]  { 
				optionalSubType = typeCast(unwrapped_optionalSubType)! 
			}

			if let unwrapped_non_optionalSubType : Any = valuesDict["non_optionalSubType"]  { 
				non_optionalSubType = typeCast(unwrapped_non_optionalSubType)! 
			}

 		} 
	}
} 

extension _TestObjectFive {

    enum _TestObjectFiveSerializationEnum: String { 
		 case _delete		= "delete"
    }
    
    func params(forGroup group : String) -> [String : Any] {
        if let groupType = _TestObjectFiveSerializationEnum(rawValue: group) {
            switch groupType {
			case ._delete:
				return serializeddelete()
            }
        }
        
        print("Group \(group) not defined, check your spelling or define in your mapping for class : TestObjectFive")
        
        return [String : Any]()
    }

	private func serializeddelete() -> [String : Any] { 
		var params = [String : Any]()

		if let instance = optionalSubType { 
			params["optional_subtype"] =  instance.params(forGroup :"delete")
		}

			params["non_optional_subtype"] = non_optionalSubType.params(forGroup :"delete")
		

		return params
	}

}