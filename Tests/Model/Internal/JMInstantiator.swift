// JSONModelKit Generated Model
// UPDATE LISCENSE HERE

import Foundation

enum JMMapperClassEnum: String {
	case _TestObjectEight 	= "TestObjectEight"
	case _TestObjectEleven 	= "TestObjectEleven"
	case _TestObjectFive 	= "TestObjectFive"
	case _TestObjectFour 	= "TestObjectFour"
	case _TestObjectNine 	= "TestObjectNine"
	case _TestObjectSeven 	= "TestObjectSeven"
	case _TestObjectSix 	= "TestObjectSix"
	case _TestObjectTen 	= "TestObjectTen"
	case _TestObjectThirteen 	= "TestObjectThirteen"
	case _TestObjectThree 	= "TestObjectThree"
	case _TestObjectTwelve 	= "TestObjectTwelve"
	case _TestObjectTwo 	= "TestObjectTwo"
	case _None 			= "None"

	func createObject(data : Dictionary<String, AnyObject>) -> AnyObject? {
		switch self {
		case ._TestObjectEight:
			return TestObjectEight(data)
		case ._TestObjectEleven:
			return TestObjectEleven(data)
		case ._TestObjectFive:
			return TestObjectFive(data)
		case ._TestObjectFour:
			return TestObjectFour(data)
		case ._TestObjectNine:
			return TestObjectNine(data)
		case ._TestObjectSeven:
			return TestObjectSeven(data)
		case ._TestObjectSix:
			return TestObjectSix(data)
		case ._TestObjectTen:
			return TestObjectTen(data)
		case ._TestObjectThirteen:
			return TestObjectThirteen(data)
		case ._TestObjectThree:
			return TestObjectThree(data)
		case ._TestObjectTwelve:
			return TestObjectTwelve(data)
		case ._TestObjectTwo:
			return TestObjectTwo(data)
		case ._None:
			return nil
		}
	}
}

enum JMTransformerEnum: String {
	case _JMCompoundValueTransformer 	= "JMCompoundValueTransformer"
	case _JMExampleStructTransformer 	= "JMExampleStructTransformer"
	case _JMExampleTupleTransformer 	= "JMExampleTupleTransformer"
	case _JMExampleClosureTransformer 	= "JMExampleClosureTransformer"
	case _JMExampleEnumTransformer 	= "JMExampleEnumTransformer"	
	case _None = "None"

	func transformer() -> JMTransformerProtocol? {
		switch self {
		case ._JMCompoundValueTransformer:
			return JMCompoundValueTransformer()
		case ._JMExampleStructTransformer:
			return JMExampleStructTransformer()
		case ._JMExampleTupleTransformer:
			return JMExampleTupleTransformer()
		case ._JMExampleClosureTransformer:
			return JMExampleClosureTransformer()
		case ._JMExampleEnumTransformer:
			return JMExampleEnumTransformer()
		case ._None:
			return nil		
		}
	} 
}

class JMInstantiator : JMInstantiatorProtocol {
	static let sharedInstance : JMInstantiator = JMInstantiator()

	func newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject? {
		return JMMapperClassEnum(rawValue: classname)?.createObject(data)
	}

	func transformerFromString(classString: String) -> JMTransformerProtocol? {
		return JMTransformerEnum(rawValue: classString)!.transformer()
	}
}