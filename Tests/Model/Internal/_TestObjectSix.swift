import Foundation

class _TestObjectSix  {	

	var non_optionalCompoundString : String
	
	var optionalCompoundString : String?

	required init(non_optionalCompoundString  _non_optionalCompoundString : String)  {
 		
						non_optionalCompoundString = _non_optionalCompoundString
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : true) {
			
			let temp_non_optionalCompoundString : String = typeCast(valuesDict["non_optionalCompoundString"])!

			self.init(non_optionalCompoundString : temp_non_optionalCompoundString) 
		
			if let unwrapped_optionalCompoundString : Any = valuesDict["optionalCompoundString"]  { 
				optionalCompoundString = typeCast(unwrapped_optionalCompoundString)! 
			}

		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(self.dynamicType)"
		let className = dynamicTypeString.componentsSeparatedByString(".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : false) {

			if let unwrapped_optionalCompoundString : Any = valuesDict["optionalCompoundString"]  { 
				optionalCompoundString = typeCast(unwrapped_optionalCompoundString)! 
			}

			if let unwrapped_non_optionalCompoundString : Any = valuesDict["non_optionalCompoundString"]  { 
				non_optionalCompoundString = typeCast(unwrapped_non_optionalCompoundString)! 
			}

 		} 
	}
} 