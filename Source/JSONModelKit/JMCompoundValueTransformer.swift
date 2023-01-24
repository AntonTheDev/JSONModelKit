//
//  JMCompoundValueTransformer.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 6/29/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

open class JMCompoundValueTransformer : JMTransformerProtocol {
   
    open func transformValues(_ inputValues : Dictionary<String, Any>?) -> Any? {
        var outputString : String = ""
        
        if let stringDictionary = inputValues as? Dictionary<String, String?> {
            
            if let leftValue = stringDictionary["non_optional_left_hand_string"] {
                outputString += leftValue ?? ""
            }
            
            if let rightValue = stringDictionary["non_optional_right_hand_string"]{
                outputString += rightValue ?? ""
            }
            
            if let leftValue = stringDictionary["left_hand_string"] {
                outputString += leftValue ?? ""
            }
            
            if let rightValue = stringDictionary["right_hand_string"] {
                outputString += rightValue ?? ""
            }
        }
        if outputString.isEmpty { return nil }
        return outputString
    }
}
