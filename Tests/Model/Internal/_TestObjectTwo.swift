import Foundation

class _TestObjectTwo  {	

	


	required init()  {
 	
	}

	convenience init?(_ dictionary: Dictionary<String, AnyObject>)  {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let _ = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : true) {
			

			self.init() 
		
			
		} else {
			return nil
		}
	}

	func updateWithDictionary(dictionary: Dictionary<String, AnyObject>) {

		let dynamicTypeString = "\(type(of: self))"
		let className = dynamicTypeString.components(separatedBy: ".").last

		if let _ = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled : false) {

			
			
 		} 
	}
} 