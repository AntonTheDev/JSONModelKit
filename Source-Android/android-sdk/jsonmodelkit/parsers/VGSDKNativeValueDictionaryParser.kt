package com.iagd.jsonmodelkit.parsers

import com.iagd.jsonmodelkit.*
import java.util.*

class JMNativeValueDictionaryParser : JMParser() {

    companion object {

        fun dictionaryRepresentation(collectionSubType : String?,
                                    data : HashMap<String, Any>) : HashMap<String, Any>
        {
            var valueHashMap : HashMap<String, Any> = HashMap<String, Any>()

            for ((key, value) in data) {
                when (collectionSubType) {
                    JMDataTypeFloat -> valueHashMap[key] = value as Float
                    JMDataTypeInt -> valueHashMap[key] = value as Int
                    JMDataTypeBool -> valueHashMap[key] = value as Boolean
                    JMDataTypeDouble -> valueHashMap[key] = value as Double
                    JMDataTypeString -> valueHashMap[key] = value as String
                    else -> valueHashMap[key] = value
                }
            }

            return valueHashMap
        }

        fun dictionaryRepresentation(collectionSubType : String?,
                                     data : Array<Any>) : HashMap<String, Any>
        {
            var valueHashMap : HashMap<String, Any> = HashMap<String, Any>()
            var intKey = 0

            for (subDictValue in data) {

                when (collectionSubType) {
                    JMDataTypeFloat -> valueHashMap[intKey.toString()] = subDictValue as Float
                    JMDataTypeInt -> valueHashMap[intKey.toString()] = subDictValue as Int
                    JMDataTypeBool -> valueHashMap[intKey.toString()] = subDictValue as Boolean
                    JMDataTypeDouble -> valueHashMap[intKey.toString()] = subDictValue as Double
                    JMDataTypeString -> valueHashMap[intKey.toString()] = subDictValue as String
                    else -> valueHashMap[intKey.toString()] = subDictValue
                }

                intKey += 1
            }

            return valueHashMap
        }
    }
}