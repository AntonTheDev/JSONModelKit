// JSONModelKit Generated Model
// UPDATE LISCENSE HERE

import Foundation

enum JMMapperClassEnum: String {
	case _None 			= "None"

	func createObject(data : Dictionary<String, AnyObject>) -> AnyObject? {
		switch self {
		
		case ._None:
			return nil
		}
	}
}

enum JMTransformerEnum: String {
		
	case _None = "None"

	func transformer() -> JMTransformerProtocol? {
		switch self {
		
		case ._None:
			return nil		
		}
	} 
}

class JMInstantiator : JMInstantiatorProtocol {
	static let sharedInstance : JMInstantiator = JMInstantiator()

	func newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject? {
		return JMMapperClassEnum(rawValue: classname)?.createObject(data : data)
	}

	func transformerFromString(_ classString: String) -> JMTransformerProtocol? {
		return JMTransformerEnum(rawValue: classString)!.transformer()
	}
}