#!/usr/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
import json

from fileimporter import ProjectFileImporter

sys.dont_write_bytecode = True

from constants import Type
from constants import MappingKey

class ClassGenerator:

   def __init__(self, mappingPath, output_directory, version, testEnabled, jsonFormatEnabled, instantiatorName):
      self.mappingPath = mappingPath
      self.output_directory = output_directory
      self.version = version
      self.testEnabled = testEnabled
      self.jsonFormatEnabled = jsonFormatEnabled
      self.instantiatorName = instantiatorName

   def internalGeneratedClass(self):
      jmsdk_propertyMappings = self.propertyMappingsArray()

      fileString = self.baseTemplate(self.getPathForFile("internal_class_template.txt"))

      fileString = str.replace(fileString, "{ BASE_CLASS_LIBRARY_IMPORT }",         self.base_class_imports(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ BASE_CLASS }",                        self.base_class_extention(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ OPTIONALS }",                         self.optional_property_definitions(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ NONOPTIONALS }",                      self.non_optional_property_definitions(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ REQUIRED_INIT_PARAMS }",              self.required_init_properties_string(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ REQUIRED_INIT_SETTERS }",             self.required_init_properties_setters_string(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ FAILABLE_INIT_TEMP_NONOPTIONALS }",   self.init_temp_non_optionals(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ SELF_NONOPTIONALS_INIT }",            self.non_optional_self_init_parameters(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ OPTIONALS_UNWRAP }",                  self.unwrap_optional_parameters(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ UPDATE_UNWRAP }",                     self.unwrap_optional_update_parameters(jmsdk_propertyMappings))

      fileString = str.replace(fileString, "{ NONOPTIONALS_UNWRAP }",               self.unwrap_non_optional_parameters(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ INSTANTIATOR_NAME }",                 self.instantiatorName)
      fileString = str.replace(fileString, "{ DEBUG_DESCRIPTION_OPTIONALS }",       self.debug_optional_property_definitions(jmsdk_propertyMappings))
      fileString = str.replace(fileString, "{ DEBUG_DESCRIPTION_NONOPTIONALS }",    self.debug_non_optional_property_definitions(jmsdk_propertyMappings))

      nonOptionalArray = self.filtered_mappings(jmsdk_propertyMappings, True)

      classname = self.mappingPath[self.mappingPath.rindex('/',0,-1)+1:-1] if self.mappingPath.endswith('/') else self.mappingPath[self.mappingPath.rindex('/')+1:].split('.', 1 )[0]

      fileString = str.replace(fileString, "{ CLASSNAME }",  classname)

      if len(nonOptionalArray) == 0:
         fileString = str.replace(fileString, "let valuesDict", "let _")

      return fileString

   def externalGeneratedClass(self):
      path =  self.baseTemplate(self.getPathForFile("external_class_template.txt"))
      return path


   '''
   Replaces { BASE_CLASS_LIBRARY_IMPORT } in the template
   '''
   def base_class_imports(self, jmsdk_propertyMappings):

      baseClassString = ""

      if MappingKey.ModelConfig in jmsdk_propertyMappings.keys():
          if MappingKey.ModelImport in jmsdk_propertyMappings[MappingKey.ModelConfig].keys():
               for lib in jmsdk_propertyMappings[MappingKey.ModelConfig][MappingKey.ModelImport]:
                   baseClassString = baseClassString + '\n' + 'import ' + str(lib)

      return baseClassString

   '''
   Replaces { BASE_CLASS } in the template
   '''
   def base_class_extention(self, jmsdk_propertyMappings):

      baseClassString = ""

      if MappingKey.ModelConfig in jmsdk_propertyMappings.keys():
          if MappingKey.ModelBaseClass in jmsdk_propertyMappings[MappingKey.ModelConfig].keys():
               baseClassString = ": " + str(jmsdk_propertyMappings[MappingKey.ModelConfig][MappingKey.ModelBaseClass])

      return baseClassString

   '''
   Replaces { OPTIONALS } in the template
   '''
   def optional_property_definitions(self, jmsdk_propertyMappings):
      valueTemplate        = "@IgnoredOnParcel\n\tattributes var propertyname : datatype? = null"
      arrayTemplate        = "@IgnoredOnParcel\n\tattributes var propertyname : Array<datatype>? = null "
      dictionatyTemplate   = "@IgnoredOnParcel\n\tattributes var propertyname : HashMap<String , datatype>? = null"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, True)
      return "\t" + self.generate_template_string(filteredMappings, templateArray, False, "", "\r\n    " )


   '''
   Replaces { NONOPTIONALS } in the template
   '''
   def non_optional_property_definitions(self, jmsdk_propertyMappings):
      valueTemplate        = "attributes lateinit var propertyname : datatype"
      arrayTemplate        = "attributes lateinit var propertyname : Array<datatype>"
      dictionatyTemplate   = "attributes lateinit var propertyname : HashMap<String , datatype>"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, False)

      if len(filteredMappings) == 0 :
         return ""

      return "\r\n\t" +  self.generate_template_string(filteredMappings, templateArray, False, "", "\r\n    " )


   '''
   Replaces { REQUIRED_INIT_PARAMS } in the template
   '''
   def required_init_properties_string(self, jmsdk_propertyMappings):
      valueTemplate        = "propertyname  _propertyname : datatype"
      arrayTemplate        = "propertyname  _propertyname : Array<datatype>"
      dictionatyTemplate   = "propertyname  _propertyname : HashMap<String , datatype>"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t  ", ",\r\n    " )


   '''
   Replaces { REQUIRED_INIT_SETTERS } in the template
   '''
   def required_init_properties_setters_string(self, jmsdk_propertyMappings):
      valueTemplate      = "propertyname = _propertyname"

      templateArray = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, False)

      if len(filteredMappings) == 0 :
         return ""

      return "\r\n\t" + self.generate_template_string(filteredMappings, templateArray, False,  "\t\t", "\r\n    " )


   '''
   Replaces { FAILABLE_INIT_TEMP_NONOPTIONALS } in the template
   '''
   def init_temp_non_optionals(self, jmsdk_propertyMappings):
      valueTemplate        = "let temp_propertyname : datatype = jmsdk_typeCast(valuesDict[\"propertyname\"])!"
      arrayTemplate        = "val propertyname = valuesDict[\"propertyname\"] as? Array<Any>\n\n" + "\t\t\tif (propertyname != null) {\n\t\t\t\tthis.propertyname = propertyname?.map { value ->\n\t\t\t\t\t\t\t\t\t\t\tvalue \n\t\t\t\t\t\t\t\t\t}?.toTypedArray()\r\n\t\t\t}\r\n"
      dictionatyTemplate   = "val propertyname = valuesDict[\"propertyname\"] as? HashMap<String , datatype>\n\n"
      #dictionatyTemplate   = "let temp_propertyname : [String : datatype] = jmsdk_typeCast(valuesDict[\"propertyname\"])!"
      #dictionatyTemplate   = "val propertyNameRaw = valuesDict[\"propertyname\"] as\? HashMap\<\*, \*\>\n\t\t\tthis.propertyname = propertyNameRaw\?.checkItemsAre\<Int, Double>() \r"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, False)

      if len(filteredMappings) == 0 :
         return ""

      return "\r\n\t\t\t" + self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\r\n    " )


   '''
   Replaces { SELF_NONOPTIONALS_INIT } in the template
   '''
   def non_optional_self_init_parameters(self, jmsdk_propertyMappings):
      valueTemplate     = "propertyname : temp_propertyname"

      templateArray = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t\t     ", "\r\n    " )


   '''
   Replaces { SELF_NONOPTIONALS_INIT } in the template
   '''
   def non_optional_self_init_parameters(self, jmsdk_propertyMappings):
      valueTemplate     = "propertyname : temp_propertyname"

      templateArray     = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings  = self.filtered_mappings(jmsdk_propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t      ", ",\r\n    " )


   '''
   Replaces { OPTIONALS_UNWRAP } in the template
   '''
   def unwrap_optional_parameters(self, jmsdk_propertyMappings):

      valueTemplate  = "\x40Suppress(\"UNCHECKED_CAST\")\n\t\t\tthis.propertyname = valuesDict[\"propertyname\"] as? datatype \r\t"

      arrayTemplate        = "\x40Suppress(\"UNCHECKED_CAST\")\n\t\t\tval propertyname = valuesDict[\"propertyname\"] as? Array<Any>\n\n" + "\t\t\tif (propertyname != null)\n\t\t\t{\n\t\t\t\tthis.propertyname = propertyname.map { value ->\n\t\t\t\t\t\t\t\t\t\t\tvalue as datatype \n\t\t\t\t\t\t\t\t\t}.toTypedArray()\r\n\t\t\t}\r\n"
      #arrayTemplate        = "this.propertyname = (valuesDict[\"propertyname\"] as? Array<Object>)?.map { value ->\n\t\t\t\t\t\t\t\t\t\t\tvalue as datatype \n\t\t\t\t\t\t\t\t\t}?.toTypedArray()\r\n\r"
      #arrayTemplate        = "\t\tpropertyname = valuesDict!![\"propertyname\"] as? Array<datatype> \r\n\t\t\r"
      dictionatyTemplate   = "this.propertyname = (valuesDict[\"propertyname\"] as? HashMap<String, datatype>)?.checkItemsAre<String, datatype>() \r\t"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, True)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\n    " )


   '''
   Replaces { OPTIONALS_UNWRAP } in the template
   '''
   def unwrap_optional_update_parameters(self, jmsdk_propertyMappings):

      valueTemplate  = "\x40Suppress(\"UNCHECKED_CAST\")\n\t\t\tval newpropertyname = valuesDict[\"propertyname\"] as? datatype \n\t\t\tif(newpropertyname != null) { this.propertyname = newpropertyname } \r\t"

      arrayTemplate        = "\x40Suppress(\"UNCHECKED_CAST\")\n\t\t\tval newpropertyname = valuesDict[\"propertyname\"] as? Array<Any>\n\n" + "\t\t\tif (newpropertyname != null)\n\t\t\t{\n\t\t\t\tthis.propertyname = newpropertyname.map { value ->\n\t\t\t\t\t\t\t\t\t\t\tvalue as datatype \n\t\t\t\t\t\t\t\t\t}.toTypedArray()\r\n\t\t\t}\r\n"
      #arrayTemplate        = "this.propertyname = (valuesDict[\"propertyname\"] as? Array<Object>)?.map { value ->\n\t\t\t\t\t\t\t\t\t\t\tvalue as datatype \n\t\t\t\t\t\t\t\t\t}?.toTypedArray()\r\n\r"
      #arrayTemplate        = "\t\tpropertyname = valuesDict!![\"propertyname\"] as? Array<datatype> \r\n\t\t\r"
      dictionatyTemplate   = "this.propertyname = (valuesDict[\"propertyname\"] as? HashMap<String, datatype>)?.checkItemsAre<String, datatype>() \r\t"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, True)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\n    " )


   '''
   Replaces { NONOPTIONALS_UNWRAP } in the template
   '''
   def unwrap_non_optional_parameters(self, jmsdk_propertyMappings):
      valueTemplate  = "propertyname = valuesDict[\"propertyname\"] as datatype\r\n\t\t\t\r\n"


      templateArray = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, False)

      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\r\n    " )


   '''
   Replaces { DEBUG_DESCRIPTION_OPTIONALS } in the template
   '''
   def debug_optional_property_definitions(self, jmsdk_propertyMappings):
      valueTemplate        = "if let unwrapped_propertyname = propertyname { \r\n\t\t\tdebug_string += \"\\n       - propertyname : \(unwrapped_propertyname)\"\r\n\t\t}\r\n"
      arrayTemplate        = "if let unwrapped_propertyname = propertyname { \r\n\t\t\tdebug_string += \"       \\n\\n       - propertyname : \\n\"\r\n\n\t\t\tif unwrapped_propertyname.count > 0 {\n\t\t\t\tfor value in unwrapped_propertyname {\n\t\t\t\t\tdebug_string += \"\\n               \(String(describing: value).replacingOccurrences(of: \"       \", with: \"                     \"))\"\n\t\t\t\t}\n\t\t\t} \n\t\t} else {\n\t\t\tdebug_string += \"[ ]\"\n\t\t}\n\t\t\t"
      dictionatyTemplate   = "if let unwrapped_propertyname = propertyname { \r\n\t\t\tdebug_string += \"       \\n\\n       - propertyname : \\n\"\r\n\n\t\t\tif unwrapped_propertyname.count > 0 {\n\t\t\t\tfor (_, value) in unwrapped_propertyname {\n\t\t\t\t\tdebug_string += \"\\n               \(String(describing: value).replacingOccurrences(of: \"       \", with: \"                     \"))\"\n\t\t\t\t}\n\t\t\t} \n\t\t} else {\n\t\t\tdebug_string += \"[ ]\"\n\t\t}\n\t\t\t"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, True)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t", "\r    " )

   '''
   Replaces { DEBUG_DESCRIPTION_NONOPTIONALS } in the template
   '''
   def debug_non_optional_property_definitions(self, jmsdk_propertyMappings):
      valueTemplate        = "debug_string += \"\\n       - propertyname : \(propertyname)\""
      arrayTemplate        = "\t\tdebug_string += \"       \\n\\n       - propertyname : \\n\"\r\n\n\t\tif propertyname.count > 0 {\n\t\t\tfor value in propertyname {\n\t\t\t\tdebug_string += \"\\n               \(String(describing: value).replacingOccurrences(of: \"       \", with: \"                     \"))\"\n\t\t\t}\n\t\t} else {\n\t\t\tdebug_string += \"[ ]\"\n\t\t}"
      dictionatyTemplate   = "\t\tdebug_string += \"       \\n\\n       - propertyname : \\n\"\r\n\n\t\tif propertyname.count > 0 {\n\t\t\tfor (_, value) in propertyname {\n\t\t\t\tdebug_string += \"\\n               \(String(describing: value).replacingOccurrences(of: \"       \", with: \"                     \"))\"\n\t\t\t\tdebug_string += \"\"\n\t\t\t}\n\t\t} else {\n\t\t\tdebug_string += \"[ ]\"\n\t\t}"


      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(jmsdk_propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t", "\r    " )


   def generate_template_string(self, jmsdk_propertyMappings, templateArray, skipInitialIndentation, indentation, carriageString):
      if len(jmsdk_propertyMappings) == 0 :
         return ""

      propertyString = ""

      for propertyKey in jmsdk_propertyMappings.keys():

         propertyMapping = jmsdk_propertyMappings[propertyKey]
         propertyType = str(propertyMapping[MappingKey.Type])
         isMappingOptional = self.is_property_mapping_optional(propertyMapping)

         templateValues = {}
         templateValues["propertyname"] = propertyKey
         templateValues["datatype"] = propertyType
         templateValues["attributes "] = ''



         if templateValues["datatype"] == 'Bool':
           templateValues["datatype"] = 'Boolean'
         if templateValues["datatype"] == 'UIColor':
           templateValues["datatype"] = 'Color'
         if templateValues["datatype"] == 'UIFont':
           templateValues["datatype"] = 'Typeface'

         if MappingKey.Attributes in propertyMapping.keys():
             templateValues["attributes "] = str(propertyMapping[MappingKey.Attributes]) + ' '

         templateIndex = 0

         if skipInitialIndentation == False or propertyString != "":
            propertyString += indentation

         if propertyKey == "stats":
            print templateValues

         if propertyType in Type.CollectionTypes:
            templateValues["datatype"] = str(propertyMapping[MappingKey.SubType])

            if propertyType == Type.ArrayType:
               templateIndex = 1
            elif propertyType == Type.DictionaryType:
               templateIndex = 2

         propertyString += self.dictionaryValueString(templateArray[templateIndex], templateValues)

         if jmsdk_propertyMappings.keys().index(propertyKey) <= len(jmsdk_propertyMappings.keys()) - 2:
            propertyString += carriageString
         else:
            propertyString += ""

      return propertyString


   def is_property_mapping_optional(self, mapping):
      if MappingKey.NonOptional in mapping.keys() and mapping[MappingKey.NonOptional]:
         return False
      else:
         return True


   def dictionaryValueString(self, templateString, dictionaryValues):
      renderedString = templateString

      for key in dictionaryValues.keys():
         renderedString = str.replace(renderedString, key, str(dictionaryValues[key]))

      return renderedString.replace("Dictionary", "HashMap")


   def propertyMappingsArray(self):
      if self.jsonFormatEnabled:
         return json.load(open(self.mappingPath))
      else:
         return plistlib.readPlist(self.mappingPath)


   def filtered_mappings(self, jmsdk_propertyMappings, optional):
      filteredMappings = {}

      for propertyKey in jmsdk_propertyMappings.keys():
          propertyMapping = jmsdk_propertyMappings[propertyKey]

          if MappingKey.ModelConfig == propertyKey:
              continue

          if self.is_property_mapping_optional(propertyMapping) == optional:
               filteredMappings[propertyKey] = propertyMapping

      return filteredMappings


   def getPathForFile(self, fileName):
      return str.replace(os.path.abspath(__file__), "generator.py", fileName)

   def baseTemplate(self, path):
      jmsdk_propertyMappings  = self.propertyMappingsArray()

      fileString = str.replace(open(path, 'r').read(), '\n', '\r\n')
      classname = self.mappingPath[self.mappingPath.rindex('/',0,-1)+1:-1] if self.mappingPath.endswith('/') else self.mappingPath[self.mappingPath.rindex('/')+1:].split('.', 1 )[0]

      if self.testEnabled == 0:
          fileString = str.replace(fileString,  "{ TEST_IMPORT }", "\r\n")
      else:
          fileString = str.replace(fileString,  "{ TEST_IMPORT }", '\n')

      fileString = str.replace(fileString, "{ CLASSNAME }",  classname)

      return fileString