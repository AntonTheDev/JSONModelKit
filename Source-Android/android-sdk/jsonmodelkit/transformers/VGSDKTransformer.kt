package com.iagd.jsonmodelkit
import com.iagd.jsonmodelkit.parsers.JMParser
import java.util.*

class JMTransformer : JMParser() {
    @Suppress("UNCHECKED_CAST")



    companion object {

        var jmsdk_transformerInstances : HashMap<String, JMTransformerProtocol> = HashMap<String, JMTransformerProtocol> ()

        fun transformedValueRepresentation(
            mapperClass : String,
            jsonKeys : Array<String>,
            fromData : HashMap<String, Any>,
            instantiator : JMInstantiatorProtocol) : Any?
        {
            var valueDictionary : HashMap<String, Any> = HashMap<String, Any>()

            for (jsonKey in jsonKeys) {

                val jsonValue = dictionaryValueForKey(jsonKey, fromData)

                if ( jsonValue != null) {
                    valueDictionary[jsonKey] = jsonValue
                }
            }

            val customTransformer = customTransformer(mapperClass, instantiator)

            return customTransformer?.transformValues(valueDictionary)

        }

        fun transformedValue(
            fromDictionary: HashMap<String, Any>,
            propertyMapping: HashMap<String, Any>,
            instantiator: JMInstantiatorProtocol): Any?
        {
            val transformClass = propertyMapping[JMMapperTransformerKey] as? String

            if (transformClass != null) {

                val rawKeys = propertyMapping[JMMapperJSONKey] as? Array<*>
                val keys = rawKeys?.checkItemsAre<String>() ?: return null

                return JMTransformer.transformedValueRepresentation(transformClass, keys!!, fromDictionary, instantiator)
            }

            return null
        }

        private fun customTransformer(className : String,
                                      instantiator : JMInstantiatorProtocol) : JMTransformerProtocol?
        {
            val transformer = jmsdk_transformerInstances[className]

            return if(transformer != null) {
                transformer
            } else {
                val newTransformerInstance = instantiator.transformerFromString(className)

                if (newTransformerInstance != null) {
                    this.jmsdk_transformerInstances[className] = newTransformerInstance
                    newTransformerInstance
                } else {
                    null
                }
            }
        }
    }
}