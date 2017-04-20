//
//  JSONModelKit.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 6/22/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

public protocol JMInstantiatorProtocol {
    func newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject?
    func transformerFromString(_ classString: String) -> JMTransformerProtocol?
}

public protocol JMTransformerProtocol {
    func transformValues(_ inputValues : Dictionary<String, Any>?) -> Any?
}

public func typeCast<U>(_ object: Any?) -> U? {
    if let typed = object as? U {
        return typed
    }
    return nil
}

extension Array {
    func containsValue<T>(_ obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

var propertyMappings : Dictionary<String, Dictionary<String, Dictionary<String, AnyObject>>> = Dictionary()

let JMMapperJSONKey                 = "key"
let JMMapperTypeKey                 = "type"
let JMMapperNonOptionalKey          = "nonoptional"
let JMMapperDefaultKey              = "default"
let JMMapperTransformerKey          = "transformer"
let JMMapperCollectionSubTypeKey    = "subtype"

let JMDataTypeString        = "String"
let JMDataTypeInt           = "Int"
let JMDataTypeDouble        = "Double"
let JMDataTypeFloat         = "Float"
let JMDataTypeBool          = "Bool"
let JMDataTypeArray         = "Array"
let JMDataTypeDictionary    = "Dictionary"

let nativeDataTypes      = [JMDataTypeString, JMDataTypeInt, JMDataTypeDouble, JMDataTypeFloat, JMDataTypeBool]
let collectionTypes      = [JMDataTypeArray, JMDataTypeDictionary]

final public class JSONModelKit {
    
    public class func mapValues(from dictionary : Dictionary<String, AnyObject>, forType classType : String , employing instantiator : JMInstantiatorProtocol, defaultsEnabled : Bool) -> Dictionary<String, Any>? {

        if let mappingConfiguration = retrieveMappingConfiguration(classType) {
       
            // Dictionary to store parsed values to be returned
            var retrievedValueDictionary = Dictionary<String, Any>()
            
            for (propertyKey, propertyMapping) in mappingConfiguration {
                retrievedValueDictionary[propertyKey] = Parser.retrieveValue(from : dictionary, applying : propertyMapping, employing : instantiator, defaultsEnabled : defaultsEnabled)
            }
            
            if defaultsEnabled == false {
                return retrievedValueDictionary
            }
            
            if Validator.validateResponse(forValues: retrievedValueDictionary, mappedTo : mappingConfiguration, forType : classType, withData : dictionary) {
                return retrievedValueDictionary
            }
        }
        
        return nil
    }
    
    class func retrieveMappingConfiguration(_ className : String) -> Dictionary<String, Dictionary<String, AnyObject>>? {
        if let mappingconfiguration = propertyMappings[className] {
            return mappingconfiguration
        } else {
            if let mappingPath = Bundle(for: self).path(forResource: className, ofType: "json") {
                do {
                    let jsonData = try Data(contentsOf: URL(fileURLWithPath: mappingPath), options: NSData.ReadingOptions.mappedIfSafe)
                    do {
                        let jsonMapping: NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        if let mapping = jsonMapping as? Dictionary<String, Dictionary<String, AnyObject>> {
                           
                            if mapping.keys.count > 0 {
                                propertyMappings[className] = mapping
                                return mapping
                            }
                        }
                        
                        return nil
                    } catch {}
                } catch {}

            } else if let mappingPath = Bundle(for: self).path(forResource: className, ofType: "plist") {
                let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, AnyObject>>
                
                if tempMapping!.isEmpty { return nil }
                
                propertyMappings[className] = tempMapping
                return tempMapping!
            }
            
            return nil
        }
    }
}

