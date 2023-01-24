import Foundation




@objcMembers public class TestObjectSeven : NSObject  {

	public var non_optionalArrayType : [TestObjectFour]

	public var optionalArrayType : [TestObjectFour]?

	required public  init(non_optionalArrayType  _non_optionalArrayType : [TestObjectFour])  {


			non_optionalArrayType = _non_optionalArrayType
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
			let temp_non_optionalArrayType : [TestObjectFour] = typeCast(valuesDict["non_optionalArrayType"])!

			self.init(non_optionalArrayType : temp_non_optionalArrayType)

			if let unwrapped_optionalArrayType : Any = valuesDict["optionalArrayType"]  { 
				optionalArrayType = typeCast(unwrapped_optionalArrayType)! 
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
			if let unwrapped_optionalArrayType : Any = valuesDict["optionalArrayType"]  { 
				optionalArrayType = typeCast(unwrapped_optionalArrayType)! 
			}

			if let unwrapped_non_optionalArrayType : Any = valuesDict["non_optionalArrayType"]  { 
				non_optionalArrayType = typeCast(unwrapped_non_optionalArrayType)! 
			}

 		}
	}
}

extension TestObjectSeven {

	public override var debugDescription: String {

		var debug_string = "[TestObjectSeven]"

		if let unwrapped_optionalArrayType = optionalArrayType { 
			debug_string += "       \n\n       - optionalArrayType : \n"

			if unwrapped_optionalArrayType.count > 0 {
				for value in unwrapped_optionalArrayType {
					debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
				}
			} 
		} else {
			debug_string += "[ ]"
		}
			
		
		debug_string += "       \n\n       - non_optionalArrayType : \n"

		if non_optionalArrayType.count > 0 {
			for value in non_optionalArrayType {
				debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
			}
		} else {
			debug_string += "[ ]"
		}
		debug_string += "\n"

		return debug_string
	}
}
