package com.iagd.jsonmodelkit.parsers

import com.iagd.jsonmodelkit.JMInstantiatorProtocol
import com.iagd.jsonmodelkit.checkItemsAre
import com.iagd.jsonmodelkit.jmsdk_nativeDataTypes
import java.util.*
import kotlin.collections.HashMap

class JMCollectionParser : JMParser() {

    companion object {

        fun arrayRepresentation(instantiator : JMInstantiatorProtocol?, data : Any, collectionSubType : String?) : Array<Any> {

            if (collectionSubType != null) if (jmsdk_nativeDataTypes.contains(collectionSubType))
            {
                val rawData =  data as? HashMap<*, *>
                val dictData = rawData?.checkItemsAre<String, Any>()

                if (dictData != null)
                {
                    return JMNativeValueArrayParser.arrayRepresentation(collectionSubType, dictData)
                }
            }
            else
            {
                val rawHashMapData =  data as? HashMap<*, *>
                val dictionaryData = rawHashMapData?.checkItemsAre<String, HashMap<String, Any>>()

                if (dictionaryData != null)
                {
                    return JMComplexValueArrayParser.arrayRepresentation(instantiator, collectionSubType, dictionaryData)
                }

                val rawData =  data as? ArrayList<*>
                val arrayData = rawData?.checkItemsAre<Any>()? as? ArrayList<Any>

                return if (jmsdk_nativeDataTypes.contains(collectionSubType)) {
                    JMNativeValueArrayParser.arrayRepresentation(collectionSubType, arrayData)
                } else {
                    JMComplexValueArrayParser.arrayRepresentation(instantiator, collectionSubType, arrayData)
                }
            }

            var valueArray  : ArrayList<Any> = ArrayList()
            return valueArray.toArray() as Array<Any>
        }

        // MARK Determines the type of representation to be mapped to a Dictionary

        fun dictionaryRepresentation(instantiator : JMInstantiatorProtocol?, data : Any, collectionSubType : String?) : HashMap<String, Any> {

            if (jmsdk_nativeDataTypes.contains(collectionSubType))
            {
                val rawHashMapData =  data as? HashMap<*, *>
                val dictData = rawHashMapData?.checkItemsAre<String,Any>()

                if (dictData != null)
                {
                    return JMNativeValueDictionaryParser.dictionaryRepresentation(collectionSubType, dictData)
                }
            }
            else
            {
                val rawHashMapData =  data as? HashMap<*, *>
                val dictionaryData = rawHashMapData?.checkItemsAre<String, HashMap<String, Any>>()

                if (dictionaryData != null)
                {
                    return JMComplexValueDictionaryParser.dictionaryRepresentationOfDictionaries(instantiator, collectionSubType, dictionaryData)
                }

                val rawArrayOfDictData =  data as? Array<*>
                val arrayOfDictionariesData = rawArrayOfDictData?.checkItemsAre<HashMap<String, Any>>()

                if (arrayOfDictionariesData != null)
                {
                    return JMComplexValueDictionaryParser.dictionaryRepresentationOfArrayOfDictionaries(instantiator, collectionSubType, arrayOfDictionariesData)
                }
            }

            return HashMap()
        }

    }

}
