#!/usr/bin/python
import sys

sys.dont_write_bytecode = True

class MetaConst(type):
    def __getattr__(cls, key):
        return cls[key]

    def __setattr__(cls, key, value):
        raise TypeError

class Const(object):
    __metaclass__ = MetaConst

    def __getattr__(self, name):
        return self[name]

    def __setattr__(self, name, value):
        raise TypeError

class MappingKey(Const):
    Key   			    = "key"
    Type 			    = "type"
    DefaultValue 	    = "default"
    NonOptional    	    = "nonoptional"
    Attributes          = "attributes"
    JMSDKTransformer    	    = "transformer"
    SubType      	    = "subtype"
    Groups              = "groups"
    ModelConfig         = "model_config"
    ModelImport         = "import"
    ModelBaseClass      = "extends"

class Type(Const):
	NativeTypes       = ["String", "Double", "Float", "Int", "Bool"]
	ArrayType         = "Array"
	DictionaryType    = "Dictionary"
	CollectionTypes   = ["Array", "Dictionary"]
