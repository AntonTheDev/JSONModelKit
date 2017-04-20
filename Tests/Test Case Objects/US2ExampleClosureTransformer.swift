//
//  JMExampleClosureTransformer.swift
//  JSONModelKit
//
//  Created by Anton on 9/3/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation


public class JMExampleClosureTransformer : JMTransformerProtocol {
    public func transformValues(_ inputValues : Dictionary<String, Any>?) -> Any? {
        if let handlerType = inputValues!["handler_type"] as? String {
            if handlerType == "uppercase" {
              
                func returnCapitalizedString(value: String) -> String {
                    return value.uppercased()
                }
                return returnCapitalizedString
            
            } else if handlerType == "lowercase" {
                func returnLowercaseString(value: String) -> String {
                    return value.lowercased()
                }
                return returnLowercaseString
            }
        }

        return nil
    }
}
