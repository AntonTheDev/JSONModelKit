package com.iagd.jsonmodelkit.parsers

import com.iagd.jsonmodelkit.*
import java.util.*

class JMNativeValueArrayParser : JMParser() {

    companion object {

        fun arrayRepresentation(collectionSubType : String?,
                                data : HashMap<String, Any>) : Array<Any>
        {
            var valueArray  : ArrayList<Any> = ArrayList()

            for ((_, value) in data) {

                when (collectionSubType) {
                    JMDataTypeFloat -> valueArray.add(value as Float)
                    JMDataTypeInt -> valueArray.add(value as Int)
                    JMDataTypeBool -> valueArray.add(value as Boolean)
                    JMDataTypeDouble -> valueArray.add(value as Double)
                    JMDataTypeString -> valueArray.add(value as String)
                    else -> valueArray.add(value)
                }
            }

            return valueArray.toArray() as Array<Any>
        }

        fun arrayRepresentation(collectionSubType : String?,
                                data : Array<Any>) : Array<Any>
        {
            var valueArray = ArrayList<Any>()

            for (item: Any in data) {

                when (collectionSubType) {
                    JMDataTypeFloat -> valueArray.add(item as Float)
                    JMDataTypeInt -> valueArray.add(item as Int)
                    JMDataTypeBool -> valueArray.add(item as Boolean)
                    JMDataTypeDouble -> valueArray.add(item as Double)
                    JMDataTypeString -> valueArray.add(item as String)
                    else -> valueArray.add(item)
                }
            }

            return valueArray.toArray() as Array<Any>
        }
    }
}