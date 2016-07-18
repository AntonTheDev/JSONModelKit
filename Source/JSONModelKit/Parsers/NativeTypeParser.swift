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
    
    class func convertValue(value : AnyObject, dataType : String) -> AnyObject?  {
        switch dataType {
        case JMDataTypeString:
            if value is NSNumber {
                return numericString(value as! NSNumber)
            }
            return "\(value)"
        case JMDataTypeDouble:
            return Double(value.doubleValue)
        case JMDataTypeFloat:
            return Float(value.floatValue)
        case JMDataTypeInt:
            return Int(value.integerValue)
        case JMDataTypeBool:
            return value.boolValue
        default:
            return value
        }
    }
    
    class func numericString(value: NSNumber) -> String {
        switch CFNumberGetType(value){
        case .SInt8Type:
            return String(value.charValue)
        case .SInt16Type:
            return String(value.shortValue)
        case .SInt32Type:
            return String(value.intValue)
        case .SInt64Type:
            return String(value.longLongValue)
        case .Float32Type:
            return String(stringInterpolationSegment: value.floatValue)
        case .Float64Type:
            return String(stringInterpolationSegment: value.doubleValue)
        case .CharType:
            return String(value.charValue)
        case .ShortType:
            return String(value.shortValue)
        case .IntType:
            return String(value.integerValue)
        case .LongType:
            return String(value.longValue)
        case .LongLongType:
            return String(value.longLongValue)
        case .FloatType:
            return String(stringInterpolationSegment: value.floatValue)
        case .DoubleType:
            return String(stringInterpolationSegment: value.doubleValue)
        default:
            return String(stringInterpolationSegment: value.doubleValue)
        }
    }
}
