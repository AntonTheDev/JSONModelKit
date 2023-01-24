// JMSDKJSONKit Generated Model
// UPDATE LISCENSE HERE

import Foundation

public struct JMStaticMapping
{
    	static let mappingTestObjectTwelve = "{\"optionalString\": {\"key\": \"top_level_key.optional_string\", \"type\": \"String\"}, \"optionalBool\": {\"key\": \"top_level_key.optional_bool\", \"type\": \"Bool\"}, \"non_optionalFloat\": {\"nonoptional\": \"true\", \"key\": \"top_level_key.non_optional_float\", \"default\": \"60.0\", \"type\": \"Float\"}, \"optionalDouble\": {\"key\": \"top_level_key,optional_double\", \"type\": \"Double\"}, \"non_optionalString\": {\"nonoptional\": \"true\", \"key\": \"non_optional_string\", \"default\": \"Non-Optional Hello\", \"type\": \"String\"}, \"non_optionalDouble\": {\"nonoptional\": \"true\", \"key\": \"top_level_key.non_optional_double\", \"default\": \"50.0\", \"type\": \"Double\"}, \"non_optionalBool\": {\"nonoptional\": \"true\", \"key\": \"top_level_key.non_optional_bool\", \"default\": \"true\", \"type\": \"Bool\"}, \"optionalFloat\": {\"key\": \"top_level_key.optional_float\", \"type\": \"Float\"}, \"non_optionalInt\": {\"nonoptional\": \"true\", \"key\": \"non_optional_int\", \"default\": \"500\", \"type\": \"Int\"}, \"optionalInt\": {\"key\": \"top_level_key.optional_int\", \"type\": \"Int\"}}"

		static let mappingTestObjectFour = "{\"optionalString\": {\"key\": \"optional_string\", \"type\": \"String\", \"groups\": [\"update\", \"delete\"]}, \"optionalBool\": {\"key\": \"optional_bool\", \"type\": \"Bool\", \"groups\": [\"update\", \"delete\"]}, \"optionalFloat\": {\"key\": \"optional_float\", \"type\": \"Float\", \"groups\": [\"update\", \"delete\"]}, \"optionalDouble\": {\"key\": \"optional_double\", \"type\": \"Double\", \"groups\": [\"update\", \"delete\"]}, \"optionalInt\": {\"key\": \"optional_int\", \"type\": \"Int\", \"groups\": [\"update\", \"delete\"]}, \"non_optionalString\": {\"nonoptional\": \"true\", \"key\": \"non_optional_string\", \"default\": \"Non-Optional Hello\", \"type\": \"String\", \"groups\": [\"delete\"]}, \"non_optionalBool\": {\"nonoptional\": \"true\", \"key\": \"non_optional_bool\", \"default\": \"true\", \"type\": \"Bool\", \"groups\": [\"delete\"]}, \"non_optionalFloat\": {\"nonoptional\": \"true\", \"key\": \"non_optional_float\", \"default\": \"60.0\", \"type\": \"Float\", \"groups\": [\"delete\"]}, \"non_optionalDouble\": {\"nonoptional\": \"true\", \"key\": \"non_optional_double\", \"default\": \"50.0\", \"type\": \"Double\", \"groups\": [\"delete\"]}, \"non_optionalInt\": {\"nonoptional\": \"true\", \"key\": \"non_optional_int\", \"default\": \"500\", \"type\": \"Int\"}}"

		static let mappingTestObjectSix = "{\"non_optionalCompoundString\": {\"nonoptional\": \"true\", \"key\": [\"non_optional_left_hand_string\", \"non_optional_right_hand_string\"], \"type\": \"String\", \"transformer\": \"JMCompoundValueTransformer\"}, \"optionalCompoundString\": {\"key\": [\"left_hand_string\", \"right_hand_string\"], \"transformer\": \"JMCompoundValueTransformer\", \"type\": \"String\"}}"

		static let mappingTestObjectSeven = "{\"non_optionalArrayType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_sub_object_array\", \"type\": \"Array\", \"subtype\": \"TestObjectFour\"}, \"optionalArrayType\": {\"key\": \"optional_sub_object_array\", \"type\": \"Array\", \"subtype\": \"TestObjectFour\"}}"

		static let mappingTestObjectThirteen = "{\"optionalUppercaseCompletionHandler\": {\"key\": [\"handler_type\"], \"transformer\": \"JMExampleClosureTransformer\", \"type\": \"((_ value : String) -> String)\"}, \"optionalLowercaseCompletionHandler\": {\"key\": [\"handler_type\"], \"transformer\": \"JMExampleClosureTransformer\", \"type\": \"((_ value : String) -> String)\"}, \"optionalStruct\": {\"key\": [\"string1\", \"string2\"], \"transformer\": \"JMExampleStructTransformer\", \"type\": \"StructExample\"}, \"optionalTuple\": {\"key\": [\"value_one\", \"value_two\"], \"transformer\": \"JMExampleTupleTransformer\", \"type\": \"(val1 : Double, val2 : Double)\"}, \"optionalEnum\": {\"key\": [\"enumValue\"], \"transformer\": \"JMExampleEnumTransformer\", \"type\": \"EnumExample\"}}"

		static let mappingTestObjectTwo = "{}"

		static let mappingTestObjectThree = "{\"optionalString\": {\"key\": \"optional_string\", \"type\": \"String\", \"default\": \"Hello\"}, \"optionalBool\": {\"key\": \"optional_bool\", \"type\": \"Bool\", \"default\": \"true\", \"groups\": [\"delete\"]}, \"non_optionalFloat\": {\"nonoptional\": \"true\", \"key\": \"non_optional_float\", \"default\": \"60.0\", \"type\": \"Float\", \"groups\": [\"delete\"]}, \"optionalDouble\": {\"key\": \"optional_double\", \"type\": \"Double\", \"default\": \"20.0\", \"groups\": [\"delete\"]}, \"non_optionalString\": {\"nonoptional\": \"true\", \"key\": \"non_optional_string\", \"default\": \"Non-Optional Hello\", \"type\": \"String\", \"groups\": [\"delete\"]}, \"non_optionalDouble\": {\"nonoptional\": \"true\", \"key\": \"non_optional_double\", \"default\": \"50.0\", \"type\": \"Double\", \"groups\": [\"delete\"]}, \"non_optionalBool\": {\"nonoptional\": \"true\", \"key\": \"non_optional_bool\", \"default\": \"false\", \"type\": \"Bool\", \"groups\": [\"delete\"]}, \"optionalFloat\": {\"key\": \"optional_float\", \"type\": \"Float\", \"default\": \"30.0\", \"groups\": [\"delete\"]}, \"non_optionalInt\": {\"nonoptional\": \"true\", \"key\": \"non_optional_int\", \"default\": \"40\", \"type\": \"Int\", \"groups\": [\"delete\"]}, \"optionalInt\": {\"key\": \"optional_int\", \"type\": \"Int\", \"default\": \"10\", \"groups\": [\"delete\"]}}"

		static let mappingTestObjectNine = "{\"optionalArrayFloatType\": {\"key\": \"optional_array_float_type\", \"type\": \"Array\", \"subtype\": \"Float\", \"groups\": [\"update\"]}, \"non_optionalArrayDoubleType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_array_double_type\", \"type\": \"Array\", \"subtype\": \"Double\", \"groups\": [\"update\"]}, \"optionalArrayDoubleType\": {\"key\": \"optional_array_double_type\", \"type\": \"Array\", \"subtype\": \"Double\", \"groups\": [\"update\"]}, \"optionalArrayStringType\": {\"key\": \"optional_array_string_type\", \"type\": \"Array\", \"subtype\": \"String\", \"groups\": [\"update\"]}, \"optionalArrayIntType\": {\"key\": \"optional_array_int_type\", \"type\": \"Array\", \"subtype\": \"Int\", \"groups\": [\"update\"]}, \"non_optionalArrayStringType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_array_string_type\", \"type\": \"Array\", \"subtype\": \"String\", \"groups\": [\"update\"]}, \"non_optionalArrayFloatType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_array_float_type\", \"type\": \"Array\", \"subtype\": \"Float\", \"groups\": [\"update\"]}, \"non_optionalArrayIntType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_array_int_type\", \"type\": \"Array\", \"subtype\": \"Int\", \"groups\": [\"update\"]}}"

		static let mappingTestObjectFive = "{\"optionalSubType\": {\"key\": \"optional_subtype\", \"type\": \"TestObjectThree\"}, \"non_optionalSubType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_subtype\", \"type\": \"TestObjectThree\"}}"

		static let mappingTestObjectEleven = "{\"optionalString\": {\"key\": \"top_level_key.optional_string\", \"type\": \"String\"}, \"optionalBool\": {\"key\": \"top_level_key.optional_bool\", \"type\": \"Bool\"}, \"non_optionalFloat\": {\"nonoptional\": \"true\", \"key\": \"top_level_key.non_optional_float\", \"default\": \"60.0\", \"type\": \"Float\"}, \"optionalDouble\": {\"key\": \"top_level_key,optional_double\", \"type\": \"Double\"}, \"non_optionalString\": {\"nonoptional\": \"true\", \"key\": \"top_level_key.non_optional_string\", \"default\": \"Non-Optional Hello\", \"type\": \"String\"}, \"non_optionalDouble\": {\"nonoptional\": \"true\", \"key\": \"top_level_key.non_optional_double\", \"default\": \"50.0\", \"type\": \"Double\"}, \"non_optionalBool\": {\"nonoptional\": \"true\", \"key\": \"top_level_key.non_optional_bool\", \"default\": \"true\", \"type\": \"Bool\"}, \"optionalFloat\": {\"key\": \"top_level_key.optional_float\", \"type\": \"Float\"}, \"non_optionalInt\": {\"nonoptional\": \"true\", \"key\": \"top_level_key.non_optional_int\", \"default\": \"500\", \"type\": \"Int\"}, \"optionalInt\": {\"key\": \"top_level_key.optional_int\", \"type\": \"Int\"}}"

		static let mappingTestObjectTen = "{\"non_optionalDictionaryStringType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_dictionary_string_type\", \"type\": \"Dictionary\", \"subtype\": \"String\", \"groups\": [\"update\"]}, \"non_optionalDictionaryDoubleType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_dictionary_double_type\", \"type\": \"Dictionary\", \"subtype\": \"Double\", \"groups\": [\"update\"]}, \"optionalDictionaryFloatType\": {\"key\": \"optional_dictionary_float_type\", \"type\": \"Dictionary\", \"subtype\": \"Float\", \"groups\": [\"update\"]}, \"optionalDictionaryIntType\": {\"key\": \"optional_dictionary_int_type\", \"type\": \"Dictionary\", \"subtype\": \"Int\", \"groups\": [\"update\"]}, \"optionalDictionaryStringType\": {\"key\": \"optional_dictionary_string_type\", \"type\": \"Dictionary\", \"subtype\": \"String\", \"groups\": [\"update\"]}, \"optionalDictionaryDoubleType\": {\"key\": \"optional_dictionary_double_type\", \"type\": \"Dictionary\", \"subtype\": \"Double\", \"groups\": [\"update\"]}, \"non_optionalDictionaryFloatType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_dictionary_float_type\", \"type\": \"Dictionary\", \"subtype\": \"Float\", \"groups\": [\"update\"]}, \"non_optionalDictionaryIntType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_dictionary_int_type\", \"type\": \"Dictionary\", \"subtype\": \"Int\", \"groups\": [\"update\"]}}"

		static let mappingTestObjectEight = "{\"optionalDictionaryType\": {\"key\": \"optional_sub_object_dictionary\", \"type\": \"Dictionary\", \"subtype\": \"TestObjectFour\", \"groups\": [\"delete\"]}, \"non_optionalDictionaryType\": {\"nonoptional\": \"true\", \"key\": \"non_optional_sub_object_dictionary\", \"type\": \"Dictionary\", \"subtype\": \"TestObjectFour\", \"groups\": [\"delete\"]}}"

}


public struct JMStaticTransformers
{
    	static let jMCompoundValueTransformer 	= JMCompoundValueTransformer()
	
	static let jMExampleClosureTransformer 	= JMExampleClosureTransformer()
	
	static let jMExampleStructTransformer 	= JMExampleStructTransformer()
	
	static let jMExampleTupleTransformer 	= JMExampleTupleTransformer()
	
	static let jMExampleEnumTransformer 	= JMExampleEnumTransformer()
	
}



public enum JMSDKMapperClassEnum: String {
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
			return JMStaticMapping.mappingTestObjectTwelve

		case ._TestObjectFour:
			return JMStaticMapping.mappingTestObjectFour

		case ._TestObjectSix:
			return JMStaticMapping.mappingTestObjectSix

		case ._TestObjectSeven:
			return JMStaticMapping.mappingTestObjectSeven

		case ._TestObjectThirteen:
			return JMStaticMapping.mappingTestObjectThirteen

		case ._TestObjectTwo:
			return JMStaticMapping.mappingTestObjectTwo

		case ._TestObjectThree:
			return JMStaticMapping.mappingTestObjectThree

		case ._TestObjectNine:
			return JMStaticMapping.mappingTestObjectNine

		case ._TestObjectFive:
			return JMStaticMapping.mappingTestObjectFive

		case ._TestObjectEleven:
			return JMStaticMapping.mappingTestObjectEleven

		case ._TestObjectTen:
			return JMStaticMapping.mappingTestObjectTen

		case ._TestObjectEight:
			return JMStaticMapping.mappingTestObjectEight

		case ._None:
			return nil
		}
	 }
}

public enum JMSDKTransformerEnum: String {
	case _JMCompoundValueTransformer 	= "JMCompoundValueTransformer"
	case _JMExampleClosureTransformer 	= "JMExampleClosureTransformer"
	case _JMExampleStructTransformer 	= "JMExampleStructTransformer"
	case _JMExampleTupleTransformer 	= "JMExampleTupleTransformer"
	case _JMExampleEnumTransformer 	= "JMExampleEnumTransformer"
	case _None = "None"

	func transformer() -> JMTransformerProtocol? {
		switch self {
		case ._JMCompoundValueTransformer:
			return JMStaticTransformers.jMCompoundValueTransformer
		case ._JMExampleClosureTransformer:
			return JMStaticTransformers.jMExampleClosureTransformer
		case ._JMExampleStructTransformer:
			return JMStaticTransformers.jMExampleStructTransformer
		case ._JMExampleTupleTransformer:
			return JMStaticTransformers.jMExampleTupleTransformer
		case ._JMExampleEnumTransformer:
			return JMStaticTransformers.jMExampleEnumTransformer
		case ._None:
			return nil
		}
	}
}

public class JMInstantiator : JMInstantiatorProtocol {
	static public let sharedInstance : JMInstantiator = JMInstantiator()

	public func newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject? {
		return JMSDKMapperClassEnum(rawValue: classname)?.createObject(data : data)
	}

	static public func mappingFor(classType classname : String) -> String? {
        return JMSDKMapperClassEnum(rawValue: classname)?.mapping
  }

	public func transformerFromString(_ classString: String) -> JMTransformerProtocol? {
		return JMSDKTransformerEnum(rawValue: classString)!.transformer()
	}
}
