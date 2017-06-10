//
//  Validator.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

final class Validator {
    
    // MARK Validates that all the non-optional values were received or defaulted
    
    final class func validateResponse(forValues retrievedValues :  Dictionary<String, Any>,
                                      mappedTo mappingConfiguration : Dictionary<String, Dictionary<String, AnyObject>>,
                                      forType className : String,
                                      withData data : Dictionary<String, AnyObject>) -> Bool {
        
        var missingPropertyKeyArray = Array<String>()
        
        // Validate that all non-optional properties have a value assigned
       
        for (propertyKey, propertyMapping) in mappingConfiguration {
            if let isPropertyNonOptional : AnyObject = propertyMapping[JMMapperNonOptionalKey] {
                if isPropertyNonOptional.boolValue == true {
                    if let _ = retrievedValues[propertyKey] {
                        // If value was mapped, continue with validation
                        continue
                    } else {
                        if JMConfig.debugEnabled {
                            missingPropertyKeyArray.append(propertyKey)
                        } else {
                            return false
                        }
                    }
                }
            }
        }
        
        
        if JMConfig.debugEnabled {
            
            if missingPropertyKeyArray.count > 0 {
                
                print("\n\n\(className) instance could not be parsed, missing values for the following non-optional properties:")
                
                for propertyKey in missingPropertyKeyArray {
                    print("\n- \(propertyKey)")
                }
                
                print("\n\nResponse:\n\(data)\n\n")
                return false
            }
        }
        
        return true
    }
}
