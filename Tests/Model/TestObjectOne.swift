//
//  TestObjectOne.swift
//  US2Mapper
//
//  Created by Anton Doudarev on 6/25/15.
//  Copyright © 2015 US2Mapper. All rights reserved.
//

import Foundation

class TestObjectOne {
    var optionalString : String?
    
    required init(_optionalString: Any?) {
        optionalString  = typeCast(_optionalString)
    }
    
    convenience init?(_ dictionary: Dictionary<String, AnyObject>) {
        let dynamicTypeString = "\(type(of: self))"
        let className = dynamicTypeString.components(separatedBy:".").last
        
        if let valuesDict = JSONModelKit.mapValues(from: dictionary, forType: className!, employing: JMInstantiator.sharedInstance, defaultsEnabled: true) {
            self.init(_optionalString: valuesDict["optionalString"]!)
        } else {
            self.init(_optionalString : nil)
            return nil
        }
    }
}
