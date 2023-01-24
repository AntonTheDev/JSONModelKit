import Foundation




@objcMembers public class TestObjectFive : NSObject  {

	public var non_optionalSubType : TestObjectThree

	public var optionalSubType : TestObjectThree?

	required public  init(non_optionalSubType  _non_optionalSubType : TestObjectThree)  {


			non_optionalSubType = _non_optionalSubType
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
			let temp_non_optionalSubType : TestObjectThree = typeCast(valuesDict["non_optionalSubType"])!

			self.init(non_optionalSubType : temp_non_optionalSubType)

			if let unwrapped_optionalSubType : Any = valuesDict["optionalSubType"]  { 
				optionalSubType = typeCast(unwrapped_optionalSubType)! 
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
			if let unwrapped_optionalSubType : Any = valuesDict["optionalSubType"]  { 
				optionalSubType = typeCast(unwrapped_optionalSubType)! 
			}

			if let unwrapped_non_optionalSubType : Any = valuesDict["non_optionalSubType"]  { 
				non_optionalSubType = typeCast(unwrapped_non_optionalSubType)! 
			}

 		}
	}
}

extension TestObjectFive {

	public override var debugDescription: String {

		var debug_string = "[TestObjectFive]"

		if let unwrapped_optionalSubType = optionalSubType { 
			debug_string += "\n       - optionalSubType : \(unwrapped_optionalSubType)"
		}

		debug_string += "\n       - non_optionalSubType : \(non_optionalSubType)"
		debug_string += "\n"

		return debug_string
	}
}
