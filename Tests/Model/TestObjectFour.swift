import Foundation



@objcMembers public class TestObjectFour : NSObject  {

	public var non_optionalString : String
    public var non_optionalBool : Bool
    public var non_optionalFloat : Float
    public var non_optionalDouble : Double
    public var non_optionalInt : Int
	public var optionalString : String?
    public var optionalBool : Bool?
    public var optionalFloat : Float?
    public var optionalDouble : Double?
    public var optionalInt : Int?

	required public  init(non_optionalString  _non_optionalString : String,
    			  non_optionalBool  _non_optionalBool : Bool,
    			  non_optionalFloat  _non_optionalFloat : Float,
    			  non_optionalDouble  _non_optionalDouble : Double,
    			  non_optionalInt  _non_optionalInt : Int)  {

			non_optionalString = _non_optionalString
    		non_optionalBool = _non_optionalBool
    		non_optionalFloat = _non_optionalFloat
    		non_optionalDouble = _non_optionalDouble
    		non_optionalInt = _non_optionalInt
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
			let temp_non_optionalString : String = typeCast(valuesDict["non_optionalString"])!
    		let temp_non_optionalBool : Bool = typeCast(valuesDict["non_optionalBool"])!
    		let temp_non_optionalFloat : Float = typeCast(valuesDict["non_optionalFloat"])!
    		let temp_non_optionalDouble : Double = typeCast(valuesDict["non_optionalDouble"])!
    		let temp_non_optionalInt : Int = typeCast(valuesDict["non_optionalInt"])!

			self.init(non_optionalString : temp_non_optionalString,
    			      non_optionalBool : temp_non_optionalBool,
    			      non_optionalFloat : temp_non_optionalFloat,
    			      non_optionalDouble : temp_non_optionalDouble,
    			      non_optionalInt : temp_non_optionalInt)

			if let unwrapped_optionalString : Any = valuesDict["optionalString"]  { 
				optionalString = typeCast(unwrapped_optionalString)! 
			}

    		if let unwrapped_optionalBool : Any = valuesDict["optionalBool"]  { 
				optionalBool = typeCast(unwrapped_optionalBool)! 
			}

    		if let unwrapped_optionalFloat : Any = valuesDict["optionalFloat"]  { 
				optionalFloat = typeCast(unwrapped_optionalFloat)! 
			}

    		if let unwrapped_optionalDouble : Any = valuesDict["optionalDouble"]  { 
				optionalDouble = typeCast(unwrapped_optionalDouble)! 
			}

    		if let unwrapped_optionalInt : Any = valuesDict["optionalInt"]  { 
				optionalInt = typeCast(unwrapped_optionalInt)! 
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
			if let unwrapped_optionalString : Any = valuesDict["optionalString"]  { 
				optionalString = typeCast(unwrapped_optionalString)! 
			}

    		if let unwrapped_optionalBool : Any = valuesDict["optionalBool"]  { 
				optionalBool = typeCast(unwrapped_optionalBool)! 
			}

    		if let unwrapped_optionalFloat : Any = valuesDict["optionalFloat"]  { 
				optionalFloat = typeCast(unwrapped_optionalFloat)! 
			}

    		if let unwrapped_optionalDouble : Any = valuesDict["optionalDouble"]  { 
				optionalDouble = typeCast(unwrapped_optionalDouble)! 
			}

    		if let unwrapped_optionalInt : Any = valuesDict["optionalInt"]  { 
				optionalInt = typeCast(unwrapped_optionalInt)! 
			}

			if let unwrapped_non_optionalString : Any = valuesDict["non_optionalString"]  { 
				non_optionalString = typeCast(unwrapped_non_optionalString)! 
			}

    		if let unwrapped_non_optionalBool : Any = valuesDict["non_optionalBool"]  { 
				non_optionalBool = typeCast(unwrapped_non_optionalBool)! 
			}

    		if let unwrapped_non_optionalFloat : Any = valuesDict["non_optionalFloat"]  { 
				non_optionalFloat = typeCast(unwrapped_non_optionalFloat)! 
			}

    		if let unwrapped_non_optionalDouble : Any = valuesDict["non_optionalDouble"]  { 
				non_optionalDouble = typeCast(unwrapped_non_optionalDouble)! 
			}

    		if let unwrapped_non_optionalInt : Any = valuesDict["non_optionalInt"]  { 
				non_optionalInt = typeCast(unwrapped_non_optionalInt)! 
			}

 		}
	}
}

extension TestObjectFour {

	public override var debugDescription: String {

		var debug_string = "[TestObjectFour]"

		if let unwrapped_optionalString = optionalString { 
			debug_string += "\n       - optionalString : \(unwrapped_optionalString)"
		}
    	if let unwrapped_optionalBool = optionalBool { 
			debug_string += "\n       - optionalBool : \(unwrapped_optionalBool)"
		}
    	if let unwrapped_optionalFloat = optionalFloat { 
			debug_string += "\n       - optionalFloat : \(unwrapped_optionalFloat)"
		}
    	if let unwrapped_optionalDouble = optionalDouble { 
			debug_string += "\n       - optionalDouble : \(unwrapped_optionalDouble)"
		}
    	if let unwrapped_optionalInt = optionalInt { 
			debug_string += "\n       - optionalInt : \(unwrapped_optionalInt)"
		}

		debug_string += "\n       - non_optionalString : \(non_optionalString)"    	debug_string += "\n       - non_optionalBool : \(non_optionalBool)"    	debug_string += "\n       - non_optionalFloat : \(non_optionalFloat)"    	debug_string += "\n       - non_optionalDouble : \(non_optionalDouble)"    	debug_string += "\n       - non_optionalInt : \(non_optionalInt)"
		debug_string += "\n"

		return debug_string
	}
}
