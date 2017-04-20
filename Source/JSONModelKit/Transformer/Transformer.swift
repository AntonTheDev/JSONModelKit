//
//  Transformer.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

var transformerInstances : Dictionary<String, JMTransformerProtocol> = Dictionary<String, JMTransformerProtocol> ()

final class Transformer : Parser {
    
    class func transformedValue(from data : Dictionary<String, AnyObject>, applying propertyMapping : Dictionary<String, AnyObject>, employing instantiator : JMInstantiatorProtocol) -> Any? {
        
        if let transformClass = propertyMapping[JMMapperTransformerKey] as? String {
            if let jsonKeys = propertyMapping[JMMapperJSONKey] as? [String] {
                if let transformedValue: Any = transformedValueRepresentation(transformClass, jsonKeys : jsonKeys, data: data, instantiator: instantiator) {
                    return transformedValue
                }
            }
        }
        return nil
    }

    class func transformedValueRepresentation(_ mapperClass : String, jsonKeys : [String], data : Dictionary<String, AnyObject>, instantiator : JMInstantiatorProtocol) -> Any? {
        
        var valueDictionary : Dictionary<String, Any> = Dictionary<String, Any>()
        
        for jsonKey in jsonKeys {
            if let jsonValue: AnyObject = dictionaryValueForKey(jsonKey, dictionary: data) {
                valueDictionary[jsonKey] = jsonValue
            }
        }
        
        if let customTransformer = customTransformer(mapperClass, instantiator: instantiator) {
            if let transformedValue: Any = customTransformer.transformValues(valueDictionary) {
                return transformedValue;
            }
        }
        
        return nil
    }

    
    class func customTransformer(_ className : String, instantiator : JMInstantiatorProtocol) -> JMTransformerProtocol? {
        if let transformer = transformerInstances[className] {
            return transformer
        } else {
            if let transformer = instantiator.transformerFromString(className) {
                transformerInstances[className] = transformer
                return transformer
            } else {
                return nil
            }
        }
    }
}
