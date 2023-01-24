import Foundation




@objcMembers public class TestObjectNine : NSObject  {

	public var non_optionalArrayIntType : [Int]
    public var non_optionalArrayDoubleType : [Double]
    public var non_optionalArrayFloatType : [Float]
    public var non_optionalArrayStringType : [String]

	public var optionalArrayDoubleType : [Double]?
    public var optionalArrayIntType : [Int]?
    public var optionalArrayStringType : [String]?
    public var optionalArrayFloatType : [Float]?

	required public  init(non_optionalArrayIntType  _non_optionalArrayIntType : [Int],
    			  non_optionalArrayDoubleType  _non_optionalArrayDoubleType : [Double],
    			  non_optionalArrayFloatType  _non_optionalArrayFloatType : [Float],
    			  non_optionalArrayStringType  _non_optionalArrayStringType : [String])  {


			non_optionalArrayIntType = _non_optionalArrayIntType
    		non_optionalArrayDoubleType = _non_optionalArrayDoubleType
    		non_optionalArrayFloatType = _non_optionalArrayFloatType
    		non_optionalArrayStringType = _non_optionalArrayStringType
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
			let temp_non_optionalArrayIntType : [Int] = typeCast(valuesDict["non_optionalArrayIntType"])!
    		let temp_non_optionalArrayDoubleType : [Double] = typeCast(valuesDict["non_optionalArrayDoubleType"])!
    		let temp_non_optionalArrayFloatType : [Float] = typeCast(valuesDict["non_optionalArrayFloatType"])!
    		let temp_non_optionalArrayStringType : [String] = typeCast(valuesDict["non_optionalArrayStringType"])!

			self.init(non_optionalArrayIntType : temp_non_optionalArrayIntType,
    			      non_optionalArrayDoubleType : temp_non_optionalArrayDoubleType,
    			      non_optionalArrayFloatType : temp_non_optionalArrayFloatType,
    			      non_optionalArrayStringType : temp_non_optionalArrayStringType)

			if let unwrapped_optionalArrayDoubleType : Any = valuesDict["optionalArrayDoubleType"]  { 
				optionalArrayDoubleType = typeCast(unwrapped_optionalArrayDoubleType)! 
			}

    		if let unwrapped_optionalArrayIntType : Any = valuesDict["optionalArrayIntType"]  { 
				optionalArrayIntType = typeCast(unwrapped_optionalArrayIntType)! 
			}

    		if let unwrapped_optionalArrayStringType : Any = valuesDict["optionalArrayStringType"]  { 
				optionalArrayStringType = typeCast(unwrapped_optionalArrayStringType)! 
			}

    		if let unwrapped_optionalArrayFloatType : Any = valuesDict["optionalArrayFloatType"]  { 
				optionalArrayFloatType = typeCast(unwrapped_optionalArrayFloatType)! 
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
			if let unwrapped_optionalArrayDoubleType : Any = valuesDict["optionalArrayDoubleType"]  { 
				optionalArrayDoubleType = typeCast(unwrapped_optionalArrayDoubleType)! 
			}

    		if let unwrapped_optionalArrayIntType : Any = valuesDict["optionalArrayIntType"]  { 
				optionalArrayIntType = typeCast(unwrapped_optionalArrayIntType)! 
			}

    		if let unwrapped_optionalArrayStringType : Any = valuesDict["optionalArrayStringType"]  { 
				optionalArrayStringType = typeCast(unwrapped_optionalArrayStringType)! 
			}

    		if let unwrapped_optionalArrayFloatType : Any = valuesDict["optionalArrayFloatType"]  { 
				optionalArrayFloatType = typeCast(unwrapped_optionalArrayFloatType)! 
			}

			if let unwrapped_non_optionalArrayIntType : Any = valuesDict["non_optionalArrayIntType"]  { 
				non_optionalArrayIntType = typeCast(unwrapped_non_optionalArrayIntType)! 
			}

    		if let unwrapped_non_optionalArrayDoubleType : Any = valuesDict["non_optionalArrayDoubleType"]  { 
				non_optionalArrayDoubleType = typeCast(unwrapped_non_optionalArrayDoubleType)! 
			}

    		if let unwrapped_non_optionalArrayFloatType : Any = valuesDict["non_optionalArrayFloatType"]  { 
				non_optionalArrayFloatType = typeCast(unwrapped_non_optionalArrayFloatType)! 
			}

    		if let unwrapped_non_optionalArrayStringType : Any = valuesDict["non_optionalArrayStringType"]  { 
				non_optionalArrayStringType = typeCast(unwrapped_non_optionalArrayStringType)! 
			}

 		}
	}
}

extension TestObjectNine {

	public override var debugDescription: String {

		var debug_string = "[TestObjectNine]"

		if let unwrapped_optionalArrayDoubleType = optionalArrayDoubleType { 
			debug_string += "       \n\n       - optionalArrayDoubleType : \n"

			if unwrapped_optionalArrayDoubleType.count > 0 {
				for value in unwrapped_optionalArrayDoubleType {
					debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
				}
			} 
		} else {
			debug_string += "[ ]"
		}
			    	if let unwrapped_optionalArrayIntType = optionalArrayIntType { 
			debug_string += "       \n\n       - optionalArrayIntType : \n"

			if unwrapped_optionalArrayIntType.count > 0 {
				for value in unwrapped_optionalArrayIntType {
					debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
				}
			} 
		} else {
			debug_string += "[ ]"
		}
			    	if let unwrapped_optionalArrayStringType = optionalArrayStringType { 
			debug_string += "       \n\n       - optionalArrayStringType : \n"

			if unwrapped_optionalArrayStringType.count > 0 {
				for value in unwrapped_optionalArrayStringType {
					debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
				}
			} 
		} else {
			debug_string += "[ ]"
		}
			    	if let unwrapped_optionalArrayFloatType = optionalArrayFloatType { 
			debug_string += "       \n\n       - optionalArrayFloatType : \n"

			if unwrapped_optionalArrayFloatType.count > 0 {
				for value in unwrapped_optionalArrayFloatType {
					debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
				}
			} 
		} else {
			debug_string += "[ ]"
		}
			
		
		debug_string += "       \n\n       - non_optionalArrayIntType : \n"

		if non_optionalArrayIntType.count > 0 {
			for value in non_optionalArrayIntType {
				debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
			}
		} else {
			debug_string += "[ ]"
		}    	
		debug_string += "       \n\n       - non_optionalArrayDoubleType : \n"

		if non_optionalArrayDoubleType.count > 0 {
			for value in non_optionalArrayDoubleType {
				debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
			}
		} else {
			debug_string += "[ ]"
		}    	
		debug_string += "       \n\n       - non_optionalArrayFloatType : \n"

		if non_optionalArrayFloatType.count > 0 {
			for value in non_optionalArrayFloatType {
				debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
			}
		} else {
			debug_string += "[ ]"
		}    	
		debug_string += "       \n\n       - non_optionalArrayStringType : \n"

		if non_optionalArrayStringType.count > 0 {
			for value in non_optionalArrayStringType {
				debug_string += "\n               \(String(describing: value).replacingOccurrences(of: "       ", with: "                     "))"
			}
		} else {
			debug_string += "[ ]"
		}
		debug_string += "\n"

		return debug_string
	}
}
