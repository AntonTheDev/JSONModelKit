package com.iagd.jsonmodelkit.parsers

import com.iagd.jsonmodelkit.*

class JMNativeTypeParser : JMParser() {

    companion object {

        fun nativeRepresentation(data : Any, objectType : String) : Any? {
            return convertValue(data, objectType)
        }

        fun convertValue(value : Any, dataType : String) : Any?  {
            when (dataType) {
                JMDataTypeString -> return value as? String
                JMDataTypeDouble -> return value as? Long
                JMDataTypeFloat -> return value as? Float
                JMDataTypeInt -> return value as? Int
                JMDataTypeBool -> return value as? Boolean
                else -> return value
            }
        }
    }
}