//
//  JMCompoundValueTransformer.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 6/29/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

public class JMCompoundValueTransformer : JMTransformerProtocol {
   
    public func transformValues(inputValues : Dictionary<String, Any>?) -> Any? {
        var outputString : String = ""
        
        if let stringDictionary = inputValues as? Dictionary<String, String> {
            for (_, value) in stringDictionary {
                outputString += value
            }
        }
        
        if outputString.isEmpty { return nil }
        return outputString
    }
}
