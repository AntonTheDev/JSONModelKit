// VGSDKJSONKit Generated Model
// UPDATE LISCENSE HERE

import Foundation

public struct VGSDKStaticMapping
{
    	static let mappingTestObjectTwelve = "{\"non_optionalDouble\": {\"default\": \"50.0\", \"nonoptional\": \"true\", \"type\": \"Double\", \"key\": \"top_level_key.non_optional_double\"}, \"optionalInt\": {\"type\": \"Int\", \"key\": \"top_level_key.optional_int\"}, \"optionalFloat\": {\"type\": \"Float\", \"key\": \"top_level_key.optional_float\"}, \"non_optionalInt\": {\"default\": \"500\", \"nonoptional\": \"true\", \"type\": \"Int\", \"key\": \"non_optional_int\"}, \"optionalBool\": {\"type\": \"Bool\", \"key\": \"top_level_key.optional_bool\"}, \"optionalString\": {\"type\": \"String\", \"key\": \"top_level_key.optional_string\"}, \"optionalDouble\": {\"type\": \"Double\", \"key\": \"top_level_key,optional_double\"}, \"non_optionalFloat\": {\"default\": \"60.0\", \"nonoptional\": \"true\", \"type\": \"Float\", \"key\": \"top_level_key.non_optional_float\"}, \"non_optionalBool\": {\"default\": \"true\", \"nonoptional\": \"true\", \"type\": \"Bool\", \"key\": \"top_level_key.non_optional_bool\"}, \"non_optionalString\": {\"default\": \"Non-Optional Hello\", \"nonoptional\": \"true\", \"type\": \"String\", \"key\": \"non_optional_string\"}}"

		static let mappingTestObjectFour = "{\"non_optionalDouble\": {\"default\": \"50.0\", \"nonoptional\": \"true\", \"type\": \"Double\", \"groups\": [\"delete\"], \"key\": \"non_optional_double\"}, \"non_optionalInt\": {\"default\": \"500\", \"nonoptional\": \"true\", \"type\": \"Int\", \"key\": \"non_optional_int\"}, \"non_optionalFloat\": {\"default\": \"60.0\", \"nonoptional\": \"true\", \"type\": \"Float\", \"groups\": [\"delete\"], \"key\": \"non_optional_float\"}, \"optionalInt\": {\"type\": \"Int\", \"groups\": [\"update\", \"delete\"], \"key\": \"optional_int\"}, \"optionalBool\": {\"type\": \"Bool\", \"groups\": [\"update\", \"delete\"], \"key\": \"optional_bool\"}, \"optionalString\": {\"type\": \"String\", \"groups\": [\"update\", \"delete\"], \"key\": \"optional_string\"}, \"optionalDouble\": {\"type\": \"Double\", \"groups\": [\"update\", \"delete\"], \"key\": \"optional_double\"}, \"optionalFloat\": {\"type\": \"Float\", \"groups\": [\"update\", \"delete\"], \"key\": \"optional_float\"}, \"non_optionalBool\": {\"default\": \"true\", \"nonoptional\": \"true\", \"type\": \"Bool\", \"groups\": [\"delete\"], \"key\": \"non_optional_bool\"}, \"non_optionalString\": {\"default\": \"Non-Optional Hello\", \"nonoptional\": \"true\", \"type\": \"String\", \"groups\": [\"delete\"], \"key\": \"non_optional_string\"}}"

		static let mappingTestObjectSix = "{\"non_optionalCompoundString\": {\"nonoptional\": \"true\", \"type\": \"String\", \"transformer\": \"JMCompoundValueTransformer\", \"key\": [\"non_optional_left_hand_string\", \"non_optional_right_hand_string\"]}, \"optionalCompoundString\": {\"transformer\": \"JMCompoundValueTransformer\", \"type\": \"String\", \"key\": [\"left_hand_string\", \"right_hand_string\"]}}"

		static let mappingTestObjectSeven = "{\"non_optionalArrayType\": {\"subtype\": \"TestObjectFour\", \"nonoptional\": \"true\", \"type\": \"Array\", \"key\": \"non_optional_sub_object_array\"}, \"optionalArrayType\": {\"subtype\": \"TestObjectFour\", \"type\": \"Array\", \"key\": \"optional_sub_object_array\"}}"

		static let mappingTestObjectThirteen = "{\"optionalLowercaseCompletionHandler\": {\"transformer\": \"JMExampleClosureTransformer\", \"type\": \"((_ value : String) -> String)\", \"key\": [\"handler_type\"]}, \"optionalTuple\": {\"transformer\": \"JMExampleTupleTransformer\", \"type\": \"(val1 : Double, val2 : Double)\", \"key\": [\"value_one\", \"value_two\"]}, \"optionalUppercaseCompletionHandler\": {\"transformer\": \"JMExampleClosureTransformer\", \"type\": \"((_ value : String) -> String)\", \"key\": [\"handler_type\"]}, \"optionalEnum\": {\"transformer\": \"JMExampleEnumTransformer\", \"type\": \"EnumExample\", \"key\": [\"enumValue\"]}, \"optionalStruct\": {\"transformer\": \"JMExampleStructTransformer\", \"type\": \"StructExample\", \"key\": [\"string1\", \"string2\"]}}"

		static let mappingTestObjectTwo = "{}"

		static let mappingTestObjectThree = "{\"non_optionalDouble\": {\"default\": \"50.0\", \"nonoptional\": \"true\", \"type\": \"Double\", \"groups\": [\"delete\"], \"key\": \"non_optional_double\"}, \"optionalInt\": {\"default\": \"10\", \"type\": \"Int\", \"groups\": [\"delete\"], \"key\": \"optional_int\"}, \"optionalFloat\": {\"default\": \"30.0\", \"type\": \"Float\", \"groups\": [\"delete\"], \"key\": \"optional_float\"}, \"non_optionalInt\": {\"default\": \"40\", \"nonoptional\": \"true\", \"type\": \"Int\", \"groups\": [\"delete\"], \"key\": \"non_optional_int\"}, \"optionalBool\": {\"default\": \"true\", \"type\": \"Bool\", \"groups\": [\"delete\"], \"key\": \"optional_bool\"}, \"optionalString\": {\"default\": \"Hello\", \"type\": \"String\", \"key\": \"optional_string\"}, \"optionalDouble\": {\"default\": \"20.0\", \"type\": \"Double\", \"groups\": [\"delete\"], \"key\": \"optional_double\"}, \"non_optionalFloat\": {\"default\": \"60.0\", \"nonoptional\": \"true\", \"type\": \"Float\", \"groups\": [\"delete\"], \"key\": \"non_optional_float\"}, \"non_optionalBool\": {\"default\": \"false\", \"nonoptional\": \"true\", \"type\": \"Bool\", \"groups\": [\"delete\"], \"key\": \"non_optional_bool\"}, \"non_optionalString\": {\"default\": \"Non-Optional Hello\", \"nonoptional\": \"true\", \"type\": \"String\", \"groups\": [\"delete\"], \"key\": \"non_optional_string\"}}"

		static let mappingTestObjectNine = "{\"optionalArrayIntType\": {\"subtype\": \"Int\", \"type\": \"Array\", \"groups\": [\"update\"], \"key\": \"optional_array_int_type\"}, \"optionalArrayStringType\": {\"subtype\": \"String\", \"type\": \"Array\", \"groups\": [\"update\"], \"key\": \"optional_array_string_type\"}, \"non_optionalArrayFloatType\": {\"subtype\": \"Float\", \"nonoptional\": \"true\", \"type\": \"Array\", \"groups\": [\"update\"], \"key\": \"non_optional_array_float_type\"}, \"non_optionalArrayDoubleType\": {\"subtype\": \"Double\", \"nonoptional\": \"true\", \"type\": \"Array\", \"groups\": [\"update\"], \"key\": \"non_optional_array_double_type\"}, \"non_optionalArrayIntType\": {\"subtype\": \"Int\", \"nonoptional\": \"true\", \"type\": \"Array\", \"groups\": [\"update\"], \"key\": \"non_optional_array_int_type\"}, \"non_optionalArrayStringType\": {\"subtype\": \"String\", \"nonoptional\": \"true\", \"type\": \"Array\", \"groups\": [\"update\"], \"key\": \"non_optional_array_string_type\"}, \"optionalArrayDoubleType\": {\"subtype\": \"Double\", \"type\": \"Array\", \"groups\": [\"update\"], \"key\": \"optional_array_double_type\"}, \"optionalArrayFloatType\": {\"subtype\": \"Float\", \"type\": \"Array\", \"groups\": [\"update\"], \"key\": \"optional_array_float_type\"}}"

		static let mappingTestObjectFive = "{\"optionalSubType\": {\"type\": \"TestObjectThree\", \"key\": \"optional_subtype\"}, \"non_optionalSubType\": {\"nonoptional\": \"true\", \"type\": \"TestObjectThree\", \"key\": \"non_optional_subtype\"}}"

		static let mappingTestObjectEleven = "{\"non_optionalDouble\": {\"default\": \"50.0\", \"nonoptional\": \"true\", \"type\": \"Double\", \"key\": \"top_level_key.non_optional_double\"}, \"optionalInt\": {\"type\": \"Int\", \"key\": \"top_level_key.optional_int\"}, \"optionalFloat\": {\"type\": \"Float\", \"key\": \"top_level_key.optional_float\"}, \"non_optionalInt\": {\"default\": \"500\", \"nonoptional\": \"true\", \"type\": \"Int\", \"key\": \"top_level_key.non_optional_int\"}, \"optionalBool\": {\"type\": \"Bool\", \"key\": \"top_level_key.optional_bool\"}, \"optionalString\": {\"type\": \"String\", \"key\": \"top_level_key.optional_string\"}, \"optionalDouble\": {\"type\": \"Double\", \"key\": \"top_level_key,optional_double\"}, \"non_optionalFloat\": {\"default\": \"60.0\", \"nonoptional\": \"true\", \"type\": \"Float\", \"key\": \"top_level_key.non_optional_float\"}, \"non_optionalBool\": {\"default\": \"true\", \"nonoptional\": \"true\", \"type\": \"Bool\", \"key\": \"top_level_key.non_optional_bool\"}, \"non_optionalString\": {\"default\": \"Non-Optional Hello\", \"nonoptional\": \"true\", \"type\": \"String\", \"key\": \"top_level_key.non_optional_string\"}}"

		static let mappingTestObjectTen = "{\"non_optionalDictionaryDoubleType\": {\"subtype\": \"Double\", \"nonoptional\": \"true\", \"type\": \"Dictionary\", \"groups\": [\"update\"], \"key\": \"non_optional_dictionary_double_type\"}, \"optionalDictionaryFloatType\": {\"subtype\": \"Float\", \"type\": \"Dictionary\", \"groups\": [\"update\"], \"key\": \"optional_dictionary_float_type\"}, \"optionalDictionaryStringType\": {\"subtype\": \"String\", \"type\": \"Dictionary\", \"groups\": [\"update\"], \"key\": \"optional_dictionary_string_type\"}, \"optionalDictionaryIntType\": {\"subtype\": \"Int\", \"type\": \"Dictionary\", \"groups\": [\"update\"], \"key\": \"optional_dictionary_int_type\"}, \"non_optionalDictionaryIntType\": {\"subtype\": \"Int\", \"nonoptional\": \"true\", \"type\": \"Dictionary\", \"groups\": [\"update\"], \"key\": \"non_optional_dictionary_int_type\"}, \"non_optionalDictionaryFloatType\": {\"subtype\": \"Float\", \"nonoptional\": \"true\", \"type\": \"Dictionary\", \"groups\": [\"update\"], \"key\": \"non_optional_dictionary_float_type\"}, \"non_optionalDictionaryStringType\": {\"subtype\": \"String\", \"nonoptional\": \"true\", \"type\": \"Dictionary\", \"groups\": [\"update\"], \"key\": \"non_optional_dictionary_string_type\"}, \"optionalDictionaryDoubleType\": {\"subtype\": \"Double\", \"type\": \"Dictionary\", \"groups\": [\"update\"], \"key\": \"optional_dictionary_double_type\"}}"

		static let mappingTestObjectEight = "{\"non_optionalDictionaryType\": {\"subtype\": \"TestObjectFour\", \"nonoptional\": \"true\", \"type\": \"Dictionary\", \"groups\": [\"delete\"], \"key\": \"non_optional_sub_object_dictionary\"}, \"optionalDictionaryType\": {\"subtype\": \"TestObjectFour\", \"type\": \"Dictionary\", \"groups\": [\"delete\"], \"key\": \"optional_sub_object_dictionary\"}}"

}


public struct VGSDKStaticTransformers
{
    	static let jMCompoundValueTransformer 	= JMCompoundValueTransformer()
	
	static let jMExampleClosureTransformer 	= JMExampleClosureTransformer()
	
	static let jMExampleTupleTransformer 	= JMExampleTupleTransformer()
	
	static let jMExampleEnumTransformer 	= JMExampleEnumTransformer()
	
	static let jMExampleStructTransformer 	= JMExampleStructTransformer()
	
}



public enum VGSDKMapperClassEnum: String {
	case _TestObjectTwelve 	= "TestObjectTwelve"
	case _TestObjectFour 	= "TestObjectFour"
	case _TestObjectSix 	= "TestObjectSix"
	case _TestObjectSeven 	= "TestObjectSeven"
	case _TestObjectThirteen 	= "TestObjectThirteen"
	case _TestObjectTwo 	= "TestObjectTwo"
	case _TestObjectThree 	= "TestObjectThree"
	case _TestObjectNine 	= "TestObjectNine"
	case _TestObjectFive 	= "TestObjectFive"
	case _TestObjectEleven 	= "TestObjectEleven"
	case _TestObjectTen 	= "TestObjectTen"
	case _TestObjectEight 	= "TestObjectEight"
	case _None 			= "None"

	func createObject(data : Dictionary<String, AnyObject>) -> AnyObject? {
		switch self {
		case ._TestObjectTwelve:
			return TestObjectTwelve(data)
		case ._TestObjectFour:
			return TestObjectFour(data)
		case ._TestObjectSix:
			return TestObjectSix(data)
		case ._TestObjectSeven:
			return TestObjectSeven(data)
		case ._TestObjectThirteen:
			return TestObjectThirteen(data)
		case ._TestObjectTwo:
			return TestObjectTwo(data)
		case ._TestObjectThree:
			return TestObjectThree(data)
		case ._TestObjectNine:
			return TestObjectNine(data)
		case ._TestObjectFive:
			return TestObjectFive(data)
		case ._TestObjectEleven:
			return TestObjectEleven(data)
		case ._TestObjectTen:
			return TestObjectTen(data)
		case ._TestObjectEight:
			return TestObjectEight(data)
		case ._None:
			return nil
		}
	}

	var mapping : String? {
		switch self {
		case ._TestObjectTwelve:
			return VGSDKStaticMapping.mappingTestObjectTwelve

		case ._TestObjectFour:
			return VGSDKStaticMapping.mappingTestObjectFour

		case ._TestObjectSix:
			return VGSDKStaticMapping.mappingTestObjectSix

		case ._TestObjectSeven:
			return VGSDKStaticMapping.mappingTestObjectSeven

		case ._TestObjectThirteen:
			return VGSDKStaticMapping.mappingTestObjectThirteen

		case ._TestObjectTwo:
			return VGSDKStaticMapping.mappingTestObjectTwo

		case ._TestObjectThree:
			return VGSDKStaticMapping.mappingTestObjectThree

		case ._TestObjectNine:
			return VGSDKStaticMapping.mappingTestObjectNine

		case ._TestObjectFive:
			return VGSDKStaticMapping.mappingTestObjectFive

		case ._TestObjectEleven:
			return VGSDKStaticMapping.mappingTestObjectEleven

		case ._TestObjectTen:
			return VGSDKStaticMapping.mappingTestObjectTen

		case ._TestObjectEight:
			return VGSDKStaticMapping.mappingTestObjectEight

		case ._None:
			return nil
		}
	 }
}

public enum VGSDKTransformerEnum: String {
	case _JMCompoundValueTransformer 	= "JMCompoundValueTransformer"
	case _JMExampleClosureTransformer 	= "JMExampleClosureTransformer"
	case _JMExampleTupleTransformer 	= "JMExampleTupleTransformer"
	case _JMExampleEnumTransformer 	= "JMExampleEnumTransformer"
	case _JMExampleStructTransformer 	= "JMExampleStructTransformer"
	case _None = "None"

	func transformer() -> VGSDKTransformerProtocol? {
		switch self {
		case ._JMCompoundValueTransformer:
			return VGSDKStaticTransformers.jMCompoundValueTransformer
		case ._JMExampleClosureTransformer:
			return VGSDKStaticTransformers.jMExampleClosureTransformer
		case ._JMExampleTupleTransformer:
			return VGSDKStaticTransformers.jMExampleTupleTransformer
		case ._JMExampleEnumTransformer:
			return VGSDKStaticTransformers.jMExampleEnumTransformer
		case ._JMExampleStructTransformer:
			return VGSDKStaticTransformers.jMExampleStructTransformer
		case ._None:
			return nil
		}
	}
}

public class VGSDKInstantiator : VGSDKInstantiatorProtocol {
	static public let sharedInstance : VGSDKInstantiator = VGSDKInstantiator()

	public func newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject? {
		return VGSDKMapperClassEnum(rawValue: classname)?.createObject(data : data)
	}

	static public func mappingFor(classType classname : String) -> String? {
        return VGSDKMapperClassEnum(rawValue: classname)?.mapping
  }

	public func transformerFromString(_ classString: String) -> VGSDKTransformerProtocol? {
		return VGSDKTransformerEnum(rawValue: classString)!.transformer()
	}
}
