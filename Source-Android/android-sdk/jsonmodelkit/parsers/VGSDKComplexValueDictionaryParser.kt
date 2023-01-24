package com.iagd.jsonmodelkit.parsers

import com.iagd.jsonmodelkit.JMInstantiatorProtocol
import com.iagd.jsonmodelkit.checkItemsAre
import com.iagd.jsonmodelkit.jmsdk_propertyMappings


class JMComplexValueDictionaryParser : JMParser() {

    companion object {

        fun dictionaryRepresentationOfDictionaries(instantiator : JMInstantiatorProtocol?, collectionSubType : String?,
                                     data : HashMap<String,  HashMap<String, Any>>) :  HashMap<String, Any>
        {
            var valueHashMap : HashMap<String, Any> = HashMap<String, Any>()

            for ((key, value) in data) {

                if (collectionSubType != null)
                {
                    var complexTypeValue = instantiator?.newInstance(collectionSubType, value)

                    if (complexTypeValue != null)
                    {
                        valueHashMap[key] = complexTypeValue
                    }
                }
            }

            return valueHashMap
        }

        // MARK Maps HashMap representation of complex objects from an Array of HashMap objects

       fun dictionaryRepresentationOfArrayOfDictionaries(instantiator : JMInstantiatorProtocol?, collectionSubType : String?,
                                           data : Array<HashMap<String, Any>>) :  HashMap<String, Any>
       {
           var valueHashMap : HashMap<String, Any> = HashMap<String, Any>()
           var intKey = 0

           for (subDictValue in data)
           {
               val rawKeys = subDictValue as?  HashMap<*, *>
               val subDictTypeCastValue = rawKeys?.checkItemsAre<String, Any>()

               if (subDictTypeCastValue != null && collectionSubType != null) {

                   val complexTypeValue = instantiator?.newInstance(collectionSubType, subDictTypeCastValue)

                   if (complexTypeValue != null)
                       valueHashMap[intKey.toString()] = complexTypeValue
               }

               intKey += 1
            }
            return valueHashMap
        }
    }

}