//
//  ComplexValueDictionaryParser.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

final class ComplexValueDictionaryParser {
    
    // MARK Maps dictionary representation of complex objects from a Dictionary of Dictionary objects
   
    class func dictionaryRepresentation(_ collectionSubType : String?, data : Dictionary<String, Dictionary<String, AnyObject>>, instantiator : JMInstantiatorProtocol) ->  Dictionary<String, AnyObject> {
       
        var valueDictionary : Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        
        for (key, subDictValue) in data {
            if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: collectionSubType!, withValue: subDictValue) {
                valueDictionary["\(key)"] = complexTypeValue
            }
        }
        return valueDictionary
    }
    
    // MARK Maps dictionary representation of complex objects from an Array of Dictionary objects
    
    class func dictionaryRepresentation(_ collectionSubType : String?, data : [Dictionary<String, AnyObject>], instantiator : JMInstantiatorProtocol) ->  Dictionary<String, AnyObject> {
       
        var valueDictionary : Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        var intKey = 0
        for subDictValue in data {
            if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: collectionSubType!, withValue: subDictValue) {
                valueDictionary["\(intKey)"] = complexTypeValue
                intKey += 1
            }
        }
        return valueDictionary
    }
    
    // MARK Maps dictionary representation of complex objects from a single dictionary instance returned
   
    class func dictionaryRepresentation(_ collectionSubType : String?, data : Dictionary<String, AnyObject>, instantiator : JMInstantiatorProtocol) ->  Dictionary<String, AnyObject> {
        
        var valueDictionary : Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        
        if let complexTypeValue: AnyObject = instantiator.newInstance(ofType: collectionSubType!, withValue: data) {
            valueDictionary["0"] = complexTypeValue
        }
        
        return valueDictionary
    }
}
