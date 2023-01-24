package com.iagd.jsonmodelkit.parsers

import com.iagd.jsonmodelkit.JMInstantiatorProtocol

class JMComplexTypeParser : JMParser() {

    companion object {

        fun complexObject(instantiator : JMInstantiatorProtocol?, fromValue : HashMap<String, Any>,  objectType : String?) : Any? {
            return instantiator?.newInstance(objectType!!, fromValue)
        }
    }

}