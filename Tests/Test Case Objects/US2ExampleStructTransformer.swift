//
//  JMExampleStructTransformer.swift
//  JSONModelKit
//
//  Created by Anton on 9/2/15.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

import Foundation

public class JMExampleStructTransformer : JMTransformerProtocol {
    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {
       
        if let stringDictionary = inputValues as? Dictionary<String, String> {
            if let string1 = stringDictionary["string1"] {
                if let string2 = stringDictionary["string2"] {
                   return StructExample(string1 : string1, string2 : string2)
                }
            }
        }
        
        return nil
    }
}