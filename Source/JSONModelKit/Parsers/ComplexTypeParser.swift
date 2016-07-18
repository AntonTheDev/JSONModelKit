//
//  ComplexTypeParser.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

final class ComplexTypeParser {
    
    // MARK Maps a dictionary to a complex type
    
    class func complexObject(fromValue data : Dictionary<String, AnyObject>, ofType objectType : String?, using instantiator : JMInstantiatorProtocol) -> AnyObject? {
        if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: objectType!, withValue: data) {
            return complexTypeValue
        }
        
        return nil
    }
}