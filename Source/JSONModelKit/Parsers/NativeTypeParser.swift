//
//  NativeTypeParser.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

final class NativeTypeParser {
    
    class func nativeRepresentation(fromValue data : AnyObject, asType objectType : String?) -> AnyObject? {
        return convertValue(data, dataType : objectType!)
    }
    
    class func convertValue(_ value : AnyObject, dataType : String) -> AnyObject?  {
        switch dataType {
        case JMDataTypeString:
            if value is NSNumber {
                return numericString(value as! NSNumber) as AnyObject
            }
            return "\(value)" as AnyObject
        case JMDataTypeDouble:
            return Double(value.doubleValue) as AnyObject
        case JMDataTypeFloat:
            return Float(value.floatValue) as AnyObject
        case JMDataTypeInt:
            return Int(value.int64Value) as AnyObject
        case JMDataTypeBool:
            return value.boolValue as AnyObject
        default:
            return value
        }
    }
    
    class func numericString(_ value: NSNumber) -> String {
        switch CFNumberGetType(value){
        case .sInt8Type:
            return String(value.int8Value)
        case .sInt16Type:
            return String(value.int16Value)
        case .sInt32Type:
            return String(value.int32Value)
        case .sInt64Type:
            return String(value.int64Value)
        case .float32Type:
            return String(stringInterpolationSegment: value.floatValue)
        case .float64Type:
            return String(stringInterpolationSegment: value.doubleValue)
        case .charType:
            return String(value.int8Value)
        case .shortType:
            return String(value.int16Value)
        case .intType:
            return String(value.intValue)
        case .longType:
            return String(value.intValue)
        case .longLongType:
            return String(value.int64Value)
        case .floatType:
            return String(stringInterpolationSegment: value.floatValue)
        case .doubleType:
            return String(stringInterpolationSegment: value.doubleValue)
        default:
            return String(stringInterpolationSegment: value.doubleValue)
        }
    }
}
