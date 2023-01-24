package com.iagd.jsonmodelkit

import android.content.Context
import android.util.Log
import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import com.iagd.jsonmodelkit.parsers.JMParser
import java.util.*

var jmsdk_propertyMappings: HashMap<String, Any> = HashMap()

const val JMMapperJSONKey = "key"
const val JMMapperTypeKey = "type"
const val JMMapperNonOptionalKey = "nonoptional"
const val JMMapperDefaultKey = "default"
const val JMMapperTransformerKey = "transformer"
const val JMMapperCollectionSubTypeKey = "subtype"

const val JMDataTypeString = "String"
const val JMDataTypeInt = "Int"
const val JMDataTypeDouble = "Double"
const val JMDataTypeFloat = "Float"
const val JMDataTypeBool = "Bool"
const val JMDataTypeArray = "Array"
const val JMDataTypeDictionary = "Dictionary"

val jmsdk_nativeDataTypes =
    listOf(JMDataTypeString, JMDataTypeInt, JMDataTypeDouble, JMDataTypeFloat, JMDataTypeBool)

val jmsdk_collectionTypes = listOf(JMDataTypeArray, JMDataTypeDictionary)

interface JMInstantiatorProtocol {
    fun transformerFromString(classString: String): JMTransformerProtocol?
    fun newInstance(classname: String, withValue: HashMap<String, Any>): Any?
    fun mappingConfiguration(className: String): HashMap<String, Any>?
}

interface JMTransformerProtocol {
    fun transformValues(inputValues: HashMap<String, Any>?): Any?
}

@Suppress("UNCHECKED_CAST")
inline fun <reified T : Any, reified R : Any> HashMap<*,*>.checkItemsAre() =
    if (all { it.key is  T } && (all { it.key is  T }))
        this as HashMap<T, R>
    else null

@Suppress("UNCHECKED_CAST")
inline fun <reified T : Any> Array<*>.checkItemsAre() =
    if (all { it is T })
        this as Array<T>
    else null

@Suppress("UNCHECKED_CAST")
inline fun <reified T : Any> ArrayList<*>.checkItemsAre() =
    if (all { it is T })
        this as ArrayList<T>
    else null

class JMJSONKit
{
    companion object
    {
        var context: Context? = null

        fun mapDictValues(
            instantiator: JMInstantiatorProtocol?,
            from: HashMap<String, Any>?,
            forType: String,
            defaultsEnabled: Boolean
        ): HashMap<String, Any>? {

            val mappingConfiguration = instantiator?.mappingConfiguration(forType)

            var retrievedValueDictionary = HashMap<String, Any>()

            if (mappingConfiguration != null) {

                for ((key, value) in mappingConfiguration) {

                    val rawKeys = value as?  HashMap<*, *>
                    val propertyDict = rawKeys?.checkItemsAre<String, Any>() ?: return null

                    val transformedValue =
                        JMParser.retrieveValue(instantiator, from!!, propertyDict, defaultsEnabled)

                    if (transformedValue != null) {
                        retrievedValueDictionary[key] = transformedValue
                    }
                }
            }

            //if defaultsEnabled == false {
            //    return retrievedValueDictionary
            // }

            //   if JMValidator.validateResponse(forValues: retrievedValueDictionary, mappedTo : mappingConfiguration, forType : classType, withData : dictionary) {
            //       return retrievedValueDictionary
            //   }


            return retrievedValueDictionary
        }
    }
}

fun getJsonAsMap(json: String): HashMap<String, Any> {
    try {
        val mapper = ObjectMapper()
        val typeRef = object : TypeReference<Map<String, Any>>() { }

        return mapper.readValue(json, typeRef)
    } catch (e: Exception) {
        throw RuntimeException("Couldn't parse json:$json", e)
    }
}

