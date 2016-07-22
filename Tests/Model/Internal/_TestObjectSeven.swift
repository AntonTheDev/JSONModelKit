import Foundation

class _TestObjectSeven  {	

	var non_optionalArrayType : [TestObjectFour]
	
var optionalArrayType : [TestObjectFour]?

	required init(non_optionalArrayType  _non_optionalArrayType : [TestObjectFour])  {
 	
						non_optionalArrayType = _non_optionalArrayType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : true) {
			
			let temp_non_optionalArrayType : [TestObjectFour] = typeCast(valuesDict["non_optionalArrayType"])!

			self.init(non_optionalArrayType : temp_non_optionalArrayType) 
		
			if let unwrapped_optionalArrayType : Any = valuesDict["optionalArrayType"]  { 
				optionalArrayType = typeCast(unwrapped_optionalArrayType)! 
			}

		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : false) {

			if let unwrapped_optionalArrayType : Any = valuesDict["optionalArrayType"]  { 
				optionalArrayType = typeCast(unwrapped_optionalArrayType)! 
			}

			if let unwrapped_non_optionalArrayType : Any = valuesDict["non_optionalArrayType"]  { 
				non_optionalArrayType = typeCast(unwrapped_non_optionalArrayType)! 
			}

 		} 
	}
} 

extension _TestObjectSeven {
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
        
        print("Group \(group) not defined, check your spelling or define in your mapping for class : TestObjectSeven")
        
        return [String : Any]()
    }

	private func serializeddelete() -> [String : Any] { 
		var params = [String : Any]()

		if let array = params["non_optional_sub_object_array"] as?  [TestObjectFour] { 
			return ["non_optional_sub_object_array" : array.map { $0.params(forGroup :"delete") }]
		}

		if let array = params["optional_sub_object_array"] as?  [TestObjectFour] { 
			return ["optional_sub_object_array" : array.map { $0.params(forGroup :"delete") }]
		}


		return params
	}

}