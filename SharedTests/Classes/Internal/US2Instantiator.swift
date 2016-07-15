// US2MapperKit Generated Model
// UPDATE LISCENSE HERE

import Foundation

enum US2MapperClassEnum: String {
	case _None 			= "None"

	func createObject(data : Dictionary<String, AnyObject>) -> AnyObject? {
		switch self {
		
		case ._None:
			return nil
		}
	}
}

enum US2TransformerEnum: String {
		
	case _None = "None"

	func transformer() -> US2TransformerProtocol? {
		switch self {
		
		case ._None:
			return nil		
		}
	} 
}

class US2Instantiator : US2InstantiatorProtocol {
	static let sharedInstance : US2Instantiator = US2Instantiator()

	func newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject? {
		return US2MapperClassEnum(rawValue: classname)?.createObject(data)
	}

	func transformerFromString(classString: String) -> US2TransformerProtocol? {
		return US2TransformerEnum(rawValue: classString)!.transformer()
	}
}