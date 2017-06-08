//
//  JSONModelKit.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 6/22/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

public struct JMConfig {
    
    public enum JMMappingFormat: String {
        case json = "json"
        case plist = "plist"
    }

    static public var debugEnabled : Bool = false
    static public var logLevel : JMLogLevel = .none
    static public var fileFormat : JMMappingFormat = .json
}

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

let JMDataTypeString                = "String"
let JMDataTypeInt                   = "Int"
let JMDataTypeDouble                = "Double"
let JMDataTypeFloat                 = "Float"
let JMDataTypeBool                  = "Bool"
let JMDataTypeArray                 = "Array"
let JMDataTypeDictionary            = "Dictionary"

let nativeDataTypes                 = [JMDataTypeString, JMDataTypeInt, JMDataTypeDouble, JMDataTypeFloat, JMDataTypeBool]
let collectionTypes                 = [JMDataTypeArray, JMDataTypeDictionary]

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
            if JMConfig.fileFormat == .json {
                if let mapping = self.loadMappingJSONInMainBundle(forClassName : className, ofType : "json") {
                    propertyMappings[className] = mapping
                } else if let mapping = self.loadMappingJSONFromResourceBundle(forClassName : className, ofType : "json") {
                    propertyMappings[className] = mapping
                }
            } else if JMConfig.fileFormat == .plist {
                if let mapping = self.loadMappingPLISTInMainBundle(forClassName : className, ofType : "plist") {
                    propertyMappings[className] = mapping
                } else if let mapping = self.loadMappingPLISTFromResourceBundle(forClassName : className, ofType : "plist") {
                    propertyMappings[className] = mapping
                }
            }
        }
        
        return propertyMappings[className]
    }

    fileprivate class func loadMappingPLISTInMainBundle(forClassName className : String,
                                                       ofType type : String) -> Dictionary<String, Dictionary<String, AnyObject>>? {
        
        if let mappingPath = Bundle.main.path(forResource: className, ofType: type),
            let mappingDictionary = loadPLISTMapping(atPath: mappingPath) {
            return mappingDictionary
        }
        
        return nil
    }
    
    fileprivate class func loadMappingPLISTFromResourceBundle(forClassName className : String,
                                                             ofType type : String) -> Dictionary<String, Dictionary<String, AnyObject>>? {
        
        if let mappingPath = Bundle(for: self).path(forResource: className, ofType: type),
            let mappingDictionary = loadPLISTMapping(atPath: mappingPath) {
            return mappingDictionary
        }
        
        return nil
    }

    fileprivate class func loadMappingJSONInMainBundle(forClassName className : String,
                                                   ofType type : String) -> Dictionary<String, Dictionary<String, AnyObject>>? {
        
        if let mappingPath = Bundle.main.path(forResource: className, ofType: type),
            let mappingDictionary = loadJSONMapping(atPath: mappingPath) {
            return mappingDictionary
        }
        
        return nil
    }
    
    fileprivate class func loadMappingJSONFromResourceBundle(forClassName className : String,
                                                         ofType type : String) -> Dictionary<String, Dictionary<String, AnyObject>>? {
        
        if let mappingPath = Bundle(for: self).path(forResource: className, ofType: type),
            let mappingDictionary = loadJSONMapping(atPath: mappingPath) {
            return mappingDictionary
        }
        
        return nil
    }
    
    fileprivate class func loadJSONMapping(atPath mappingPath : String) -> Dictionary<String, Dictionary<String, AnyObject>>? {
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: mappingPath), options: NSData.ReadingOptions.mappedIfSafe)
            
            do {
                let jsonMapping: NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if let mapping = jsonMapping as? Dictionary<String, Dictionary<String, AnyObject>> {
                    
                    if mapping.keys.count > 0 {
                        return mapping
                    }
                }
                
                return nil
            } catch {}
        } catch {}
        
        return nil
    }
    
    fileprivate class func loadPLISTMapping(atPath mappingPath : String) -> Dictionary<String, Dictionary<String, AnyObject>>? {
       
        guard let tempMapping = NSDictionary(contentsOfFile: mappingPath) as? Dictionary<String, Dictionary<String, AnyObject>>,
               tempMapping.isEmpty == false else {
            return nil
        }
        
        return tempMapping
    }
}
