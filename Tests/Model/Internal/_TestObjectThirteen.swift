import Foundation

class _TestObjectThirteen  {	

	
var optionalLowercaseCompletionHandler : ((value : String) -> String)?
    var optionalTuple : (val1 : Double, val2 : Double)?
    var optionalUppercaseCompletionHandler : ((value : String) -> String)?
    var optionalStruct : StructExample?
    var optionalEnum : EnumExample?

	required init()  {
 	
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : true) {
			

			self.init() 
		
			if let unwrapped_optionalLowercaseCompletionHandler : Any = valuesDict["optionalLowercaseCompletionHandler"]  { 
				optionalLowercaseCompletionHandler = typeCast(unwrapped_optionalLowercaseCompletionHandler)! 
			}

    		if let unwrapped_optionalTuple : Any = valuesDict["optionalTuple"]  { 
				optionalTuple = typeCast(unwrapped_optionalTuple)! 
			}

    		if let unwrapped_optionalUppercaseCompletionHandler : Any = valuesDict["optionalUppercaseCompletionHandler"]  { 
				optionalUppercaseCompletionHandler = typeCast(unwrapped_optionalUppercaseCompletionHandler)! 
			}

    		if let unwrapped_optionalStruct : Any = valuesDict["optionalStruct"]  { 
				optionalStruct = typeCast(unwrapped_optionalStruct)! 
			}

    		if let unwrapped_optionalEnum : Any = valuesDict["optionalEnum"]  { 
				optionalEnum = typeCast(unwrapped_optionalEnum)! 
			}

		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : false) {

			if let unwrapped_optionalLowercaseCompletionHandler : Any = valuesDict["optionalLowercaseCompletionHandler"]  { 
				optionalLowercaseCompletionHandler = typeCast(unwrapped_optionalLowercaseCompletionHandler)! 
			}

    		if let unwrapped_optionalTuple : Any = valuesDict["optionalTuple"]  { 
				optionalTuple = typeCast(unwrapped_optionalTuple)! 
			}

    		if let unwrapped_optionalUppercaseCompletionHandler : Any = valuesDict["optionalUppercaseCompletionHandler"]  { 
				optionalUppercaseCompletionHandler = typeCast(unwrapped_optionalUppercaseCompletionHandler)! 
			}

    		if let unwrapped_optionalStruct : Any = valuesDict["optionalStruct"]  { 
				optionalStruct = typeCast(unwrapped_optionalStruct)! 
			}

    		if let unwrapped_optionalEnum : Any = valuesDict["optionalEnum"]  { 
				optionalEnum = typeCast(unwrapped_optionalEnum)! 
			}

			
 		} 
	}
} 

extension _TestObjectThirteen {
    func params(forGroup group : String) -> [String : Any] {
        return [String : Any]()
    }
}