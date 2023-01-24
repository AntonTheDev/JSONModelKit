package com.iagd.jsonmodelkit.parsers

import com.iagd.jsonmodelkit.JMInstantiatorProtocol
import com.iagd.jsonmodelkit.checkItemsAre
import java.util.*

class JMComplexValueArrayParser : JMParser() {

    companion object {

        fun arrayRepresentation(
            instantiator : JMInstantiatorProtocol?,
            collectionSubType: String,
            data: HashMap<String, HashMap<String, Any>>
        ): Array<Any> {
            var valueArray: ArrayList<Any> = ArrayList()

            for ((_, value) in data) {

                var complexTypeValue = instantiator?.newInstance(collectionSubType, value)

                if (complexTypeValue != null) {
                    valueArray.add(complexTypeValue)
                }
            }

            return valueArray.toArray() as Array<Any>
        }

        // MARK Maps HashMap representation of complex objects from an Array of HashMap objects

        fun arrayRepresentation(
            instantiator : JMInstantiatorProtocol?,
            collectionSubType: String,
            data: Array<Any>
        ): Array<Any> {
            var valueArray: ArrayList<Any> = ArrayList()

            for (subDictValue in data)
            {
                val rawKeys = subDictValue as?  HashMap<*, *>
                val subDictTypeCastValue = rawKeys?.checkItemsAre<String, Any>()

                if (subDictTypeCastValue != null) {

                    val complexTypeValue = instantiator?.newInstance(collectionSubType, subDictTypeCastValue)

                    if (complexTypeValue != null) {
                        valueArray.add(complexTypeValue)
                    }
                }
            }

            return valueArray.toArray() as Array<Any>
        }
    }
}
