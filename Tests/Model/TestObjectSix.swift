import Foundation



@objcMembers public class TestObjectSix : NSObject  {

	public var non_optionalCompoundString : String
	public var optionalCompoundString : String?

	required public  init(non_optionalCompoundString  _non_optionalCompoundString : String)  {

			non_optionalCompoundString = _non_optionalCompoundString
            super.init()
	}

	convenience public init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary,
												   forType: className!,
												   employing: JMInstantiator.sharedInstance,
												   defaultsEnabled : true)
		{
			let temp_non_optionalCompoundString : String = typeCast(valuesDict["non_optionalCompoundString"])!

			self.init(non_optionalCompoundString : temp_non_optionalCompoundString)

			if let unwrapped_optionalCompoundString : Any = valuesDict["optionalCompoundString"]  { 
				optionalCompoundString = typeCast(unwrapped_optionalCompoundString)! 
			}

		} else {
			return nil
		}
	}

	public func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let valuesDict = JSONModelKit.mapValues(from: dictionary,
												   forType: className!,
												   employing: JMInstantiator.sharedInstance,
												   defaultsEnabled : false)
		{
			if let unwrapped_optionalCompoundString : Any = valuesDict["optionalCompoundString"]  { 
				optionalCompoundString = typeCast(unwrapped_optionalCompoundString)! 
			}

			if let unwrapped_non_optionalCompoundString : Any = valuesDict["non_optionalCompoundString"]  { 
				non_optionalCompoundString = typeCast(unwrapped_non_optionalCompoundString)! 
			}

 		}
	}
}

extension TestObjectSix {

	public override var debugDescription: String {

		var debug_string = "[TestObjectSix]"

		if let unwrapped_optionalCompoundString = optionalCompoundString { 
			debug_string += "\n       - optionalCompoundString : \(unwrapped_optionalCompoundString)"
		}

		debug_string += "\n       - non_optionalCompoundString : \(non_optionalCompoundString)"
		debug_string += "\n"

		return debug_string
	}
}
