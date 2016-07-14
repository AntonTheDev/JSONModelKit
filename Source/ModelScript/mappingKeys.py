#!/usr/bin/python

NativeTypes       = ["String", "Double", "Float", "Int", "Bool"]
ArrayType         = "Array"
DictionaryType    = "Dictionary"
CollectionTypes   = [ArrayType, DictionaryType]

Templates         = {"optionals" : "var propertyname : datatype ?", "non-optionals" : "var propertyname : datatype "}

DataTypeKey       = "type"
DefaultValueKey   = "default"
MappingKey        = "key"
NonOptionalKey    = "nonoptional"
TransformerKey    = "transformer"
SubTypeKey        = "collection_subtype"