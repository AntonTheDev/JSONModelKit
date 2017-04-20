import Foundation

class _TestObjectSeven  {	

	var non_optionalArrayType : [TestObjectFour]
	
var optionalArrayType : [TestObjectFour]?

	required init(non_optionalArrayType  _non_optionalArrayType : [TestObjectFour])  {
 	
						non_optionalArrayType = _non_optionalArrayType
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

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

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

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