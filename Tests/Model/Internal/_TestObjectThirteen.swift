import Foundation


class _TestObjectThirteen   {


	var optionalLowercaseCompletionHandler : ((_ value : String) -> String)?
    var optionalTuple : (val1 : Double, val2 : Double)?
    var optionalUppercaseCompletionHandler : ((_ value : String) -> String)?
    var optionalStruct : StructExample?
    var optionalEnum : EnumExample?

	required init()  {

	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary,
												   forType: className!,
												   employing: JMInstantiator.sharedInstance,
												   defaultsEnabled : true)
		{

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

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary,
												   forType: className!,
												   employing: JMInstantiator.sharedInstance,
												   defaultsEnabled : false)
		{
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

extension _TestObjectThirteen : CustomDebugStringConvertible {

	var debugDescription: String {

		var debug_string = "[TestObjectThirteen]"

		if let unwrapped_optionalLowercaseCompletionHandler = optionalLowercaseCompletionHandler { 
			debug_string += "\n       - optionalLowercaseCompletionHandler : \(unwrapped_optionalLowercaseCompletionHandler)"
		}
    	if let unwrapped_optionalTuple = optionalTuple { 
			debug_string += "\n       - optionalTuple : \(unwrapped_optionalTuple)"
		}
    	if let unwrapped_optionalUppercaseCompletionHandler = optionalUppercaseCompletionHandler { 
			debug_string += "\n       - optionalUppercaseCompletionHandler : \(unwrapped_optionalUppercaseCompletionHandler)"
		}
    	if let unwrapped_optionalStruct = optionalStruct { 
			debug_string += "\n       - optionalStruct : \(unwrapped_optionalStruct)"
		}
    	if let unwrapped_optionalEnum = optionalEnum { 
			debug_string += "\n       - optionalEnum : \(unwrapped_optionalEnum)"
		}

		
		debug_string += "\n"

		return debug_string
	}
}
