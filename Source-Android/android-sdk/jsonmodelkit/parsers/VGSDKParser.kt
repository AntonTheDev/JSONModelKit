package com.iagd.jsonmodelkit.parsers

import com.iagd.jsonmodelkit.*

open class JMParser
{
    companion object {

        fun retrieveValue(instantiator : JMInstantiatorProtocol?, fromDictionary: HashMap<String, Any>, propertyMapping: HashMap<String, Any>, defaultsEnabled: Boolean): Any?
        {
            val jsonKey = propertyMapping[JMMapperJSONKey] as? String

            if (jsonKey != null) {

                val dataType = propertyMapping[JMMapperTypeKey]  as? String

                if (dataType != null)
                {
                    val subType = propertyMapping[JMMapperCollectionSubTypeKey] as? String

                    val retrievedValue = dictionaryValueForKey(jsonKey, fromDictionary)

                    if (retrievedValue !=  null)
                        return parsedValue(instantiator, retrievedValue, dataType, subType)
                    else
                    {
                        val retrievedDefaultValue: Any? = propertyMapping[JMMapperDefaultKey]

                        return if (defaultsEnabled && retrievedDefaultValue !=null)
                        {
                            parsedValue(instantiator, retrievedDefaultValue, dataType, subType)
                        }
                        else
                        {
                            null
                        }
                    }
                }
            }

            return null
        }

        private fun parsedValue(instantiator : JMInstantiatorProtocol?, value : Any, dataType : String, subType: String?) : Any?
        {
            if (jmsdk_nativeDataTypes.contains(dataType)) {

                return JMNativeTypeParser.nativeRepresentation( value, dataType)

            } else {

                when (dataType) {
                    JMDataTypeFloat -> return value as? Float
                    JMDataTypeInt -> return value as? Int
                    JMDataTypeBool -> return value as? Boolean
                    JMDataTypeArray -> if (subType != null) return JMCollectionParser.arrayRepresentation(instantiator, value,  subType)
                    JMDataTypeDictionary -> if (subType != null) return JMCollectionParser.dictionaryRepresentation(instantiator, value,  subType)
                    else -> if (value is HashMap<*, *>) {

                        val propertyDict = value.checkItemsAre<String, Any>()

                        if (propertyDict != null) {
                            return JMComplexTypeParser.complexObject(instantiator, propertyDict, dataType)
                        }
                    }
                }
            }

            return null
        }


        fun dictionaryValueForKey(key : String, dictionary : HashMap<String, Any>) : Any? {

            @Suppress("UNCHECKED_CAST")
            var keys = key.split(".")

            @Suppress("UNCHECKED_CAST")
            var nestedDictionary = dictionary as? HashMap<String, HashMap<String, Any>>

            if (nestedDictionary != null ) {
                var x = 0

                do {
                    if (x >= (keys.count() - 1))
                    {
                        var newValue = nestedDictionary!![keys[x]] as? Any

                        if (newValue != null)
                        {
                            return newValue
                        }
                    }
                    else
                    {
                        val rawKeys = nestedDictionary!![keys[x]] as? HashMap<*, *>
                        val nextDict = rawKeys?.checkItemsAre<String, HashMap<String, Any>>()

                        if (nextDict != null) {
                            nestedDictionary = nextDict
                        }
                    }

                    x += 1

                } while (x < keys.count())
            }
            return null
        }
    }
}