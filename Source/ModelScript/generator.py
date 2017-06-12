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

   def __init__(self, mappingPath, output_directory, version, testEnabled, jsonFormatEnabled):
      self.mappingPath = mappingPath
      self.output_directory = output_directory
      self.version = version
      self.testEnabled = testEnabled
      self.jsonFormatEnabled = jsonFormatEnabled

   def internalGeneratedClass(self):
      propertyMappings = self.propertyMappingsArray()

      fileString = self.baseTemplate(self.getPathForFile("internal_class_template.txt"))

      fileString = str.replace(fileString, "{ BASE_CLASS_LIBRARY_IMPORT }",         self.base_class_imports(propertyMappings))
      fileString = str.replace(fileString, "{ BASE_CLASS }",                        self.base_class_extention(propertyMappings))
      fileString = str.replace(fileString, "{ OPTIONALS }",                         self.optional_property_definitions(propertyMappings))
      fileString = str.replace(fileString, "{ NONOPTIONALS }",                      self.non_optional_property_definitions(propertyMappings))
      fileString = str.replace(fileString, "{ REQUIRED_INIT_PARAMS }",              self.required_init_properties_string(propertyMappings))
      fileString = str.replace(fileString, "{ REQUIRED_INIT_SETTERS }",             self.required_init_properties_setters_string(propertyMappings))
      fileString = str.replace(fileString, "{ FAILABLE_INIT_TEMP_NONOPTIONALS }",   self.init_temp_non_optionals(propertyMappings))
      fileString = str.replace(fileString, "{ SELF_NONOPTIONALS_INIT }",            self.non_optional_self_init_parameters(propertyMappings))
      fileString = str.replace(fileString, "{ OPTIONALS_UNWRAP }",                  self.unwrap_optional_parameters(propertyMappings))
      fileString = str.replace(fileString, "{ NONOPTIONALS_UNWRAP }",               self.unwrap_non_optional_parameters(propertyMappings))

      fileString = str.replace(fileString, "{ DEBUG_DESCRIPTION_OPTIONALS }",       self.debug_optional_property_definitions(propertyMappings))
      fileString = str.replace(fileString, "{ DEBUG_DESCRIPTION_NONOPTIONALS }",    self.debug_non_optional_property_definitions(propertyMappings))

      nonOptionalArray = self.filtered_mappings(propertyMappings, True)

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
   def base_class_imports(self, propertyMappings):

      baseClassString = ""

      if MappingKey.ModelConfig in propertyMappings.keys():
          if MappingKey.ModelImport in propertyMappings[MappingKey.ModelConfig].keys():
               for lib in propertyMappings[MappingKey.ModelConfig][MappingKey.ModelImport]:
                   baseClassString = baseClassString + '\n' + 'import ' + str(lib)

      return baseClassString

   '''
   Replaces { BASE_CLASS } in the template
   '''
   def base_class_extention(self, propertyMappings):

      baseClassString = ""

      if MappingKey.ModelConfig in propertyMappings.keys():
          if MappingKey.ModelBaseClass in propertyMappings[MappingKey.ModelConfig].keys():
               baseClassString = ": " + str(propertyMappings[MappingKey.ModelConfig][MappingKey.ModelBaseClass])

      return baseClassString

   '''
   Replaces { OPTIONALS } in the template
   '''
   def optional_property_definitions(self, propertyMappings):
      valueTemplate        = "attributes var propertyname : datatype?"
      arrayTemplate        = "attributes var propertyname : [datatype]?"
      dictionatyTemplate   = "attributes var propertyname : [String : datatype]?"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, True)
      return "\t" + self.generate_template_string(filteredMappings, templateArray, False, "", "\r\n    " )


   '''
   Replaces { NONOPTIONALS } in the template
   '''
   def non_optional_property_definitions(self, propertyMappings):
      valueTemplate        = "attributes var propertyname : datatype"
      arrayTemplate        = "attributes var propertyname : [datatype]"
      dictionatyTemplate   = "attributes var propertyname : [String : datatype]"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)

      if len(filteredMappings) == 0 :
         return ""

      return "\r\n\t" +  self.generate_template_string(filteredMappings, templateArray, False, "", "\r\n    " )


   '''
   Replaces { REQUIRED_INIT_PARAMS } in the template
   '''
   def required_init_properties_string(self, propertyMappings):
      valueTemplate        = "propertyname  _propertyname : datatype"
      arrayTemplate        = "propertyname  _propertyname : [datatype]"
      dictionatyTemplate   = "propertyname  _propertyname : [String : datatype]"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t  ", ",\r\n    " )


   '''
   Replaces { REQUIRED_INIT_SETTERS } in the template
   '''
   def required_init_properties_setters_string(self, propertyMappings):
      valueTemplate      = "propertyname = _propertyname"

      templateArray = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)

      if len(filteredMappings) == 0 :
         return ""

      return "\r\n\t" + self.generate_template_string(filteredMappings, templateArray, False,  "\t\t", "\r\n    " )


   '''
   Replaces { FAILABLE_INIT_TEMP_NONOPTIONALS } in the template
   '''
   def init_temp_non_optionals(self, propertyMappings):
      valueTemplate        = "let temp_propertyname : datatype = typeCast(valuesDict[\"propertyname\"])!"
      arrayTemplate        = "let temp_propertyname : [datatype] = typeCast(valuesDict[\"propertyname\"])!"
      dictionatyTemplate   = "let temp_propertyname : [String : datatype] = typeCast(valuesDict[\"propertyname\"])!"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)

      if len(filteredMappings) == 0 :
         return ""

      return "\r\n\t\t\t" + self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\r\n    " )


   '''
   Replaces { SELF_NONOPTIONALS_INIT } in the template
   '''
   def non_optional_self_init_parameters(self, propertyMappings):
      valueTemplate     = "propertyname : temp_propertyname"

      templateArray = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t\t     ", "\r\n    " )


   '''
   Replaces { SELF_NONOPTIONALS_INIT } in the template
   '''
   def non_optional_self_init_parameters(self, propertyMappings):
      valueTemplate     = "propertyname : temp_propertyname"

      templateArray     = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings  = self.filtered_mappings(propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t      ", ",\r\n    " )


   '''
   Replaces { OPTIONALS_UNWRAP } in the template
   '''
   def unwrap_optional_parameters(self, propertyMappings):
      valueTemplate        = "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"
      arrayTemplate        = "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"
      dictionatyTemplate   = "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, True)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\r\n    " )


   '''
   Replaces { NONOPTIONALS_UNWRAP } in the template
   '''
   def unwrap_non_optional_parameters(self, propertyMappings):
      valueTemplate  = "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"

      templateArray = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)

      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\r\n    " )


   '''
   Replaces { DEBUG_DESCRIPTION_OPTIONALS } in the template
   '''
   def debug_optional_property_definitions(self, propertyMappings):
      valueTemplate        = "if let unwrapped_propertyname = propertyname { \r\n\t\t\t\tdebug_string += \"\\n       - propertyname : \(unwrapped_propertyname)\"\r\n\t\t\t}\r\n"
      dictionatyTemplate   = "if let unwrapped_propertyname = propertyname { \r\n\t\t\t\tif unwrapped_propertyname.keys.count > 0 {\n\t\t\t\t\tfor (key, value) in unwrapped_propertyname {\n\t\t\t\t\t\tdebug_string += \"              - [ \"\n\t\t\t\t\t\tdebug_string += \"\(key)\"\n\t\t\t\t\t\tdebug_string += \" : \"\n\t\t\t\t\t\tdebug_string += \"\(value)\"\n\t\t\t\t\t\tdebug_string += \" ]\"\n\t\t\t\t\t}\n\t\t\t\t} else {\n\t\t\t\t\tdebug_string += \"[ : ]\"\n\t\t\t\t}\n\t\t\t}"
      arrayTemplate        = "if let unwrapped_propertyname = propertyname { \r\n\t\t\t\tif unwrapped_propertyname.count > 0 {\n\t\t\t\t\tfor value in unwrapped_propertyname {\n\t\t\t\t\t\tdebug_string += \"              - [ \"\n\t\t\t\t\t\tdebug_string += \"\(value)\"\n\t\t\t\t\t\tdebug_string += \" ]\"\n\t\t\t\t\t}\n\t\t\t\t} \n\t\t\t} else {\n\t\t\t\tdebug_string += \"[ ]\"\n\t\t\t}\n\t\t\t"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, True)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\r\n    " )

   '''
   Replaces { DEBUG_DESCRIPTION_NONOPTIONALS } in the template
   '''
   def debug_non_optional_property_definitions(self, propertyMappings):
      valueTemplate        = "debug_string += \"\\n       - propertyname : \(propertyname)\""
      dictionatyTemplate   = "\r\n\t\t\tif propertyname.keys.count > 0 {\n\t\t\t\tfor (key, value) in propertyname {\n\t\t\t\t\tdebug_string += \"\\n              - [ \"\n\t\t\t\t\tdebug_string += \"\(key)\"\n\t\t\t\t\tdebug_string += \" : \"\n\t\t\t\t\tdebug_string += \"\(value)\"\n\t\t\t\t\tdebug_string += \" ]\"\n\t\t\t\t}\n\t\t\t} else {\n\t\t\t\tdebug_string += \"[ : ]\"\n\t\t\t}"
      arrayTemplate        = "\r\n\t\t\tif propertyname.count > 0 {\n\t\t\t\tfor value in propertyname {\n\t\t\t\t\tdebug_string += \"\\n              - [ \"\n\t\t\t\t\tdebug_string += \"\(value)\"\n\t\t\t\t\tdebug_string += \" ]\"\n\t\t\t\t}\n\t\t\t} else {\n\t\t\t\tdebug_string += \"[ ]\"\n\t\t\t}"

      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t", "\r    " )



   def generate_template_string(self, propertyMappings, templateArray, skipInitialIndentation, indentation, carriageString):
      if len(propertyMappings) == 0 :
         return ""

      propertyString = ""

      for propertyKey in propertyMappings.keys():

         propertyMapping = propertyMappings[propertyKey]
         propertyType = str(propertyMapping[MappingKey.Type])
         isMappingOptional = self.is_property_mapping_optional(propertyMapping)

         templateValues = {}
         templateValues["propertyname"] = propertyKey
         templateValues["datatype"] = propertyType
         templateValues["attributes "] = ''

         if MappingKey.Attributes in propertyMapping.keys():
             templateValues["attributes "] = str(propertyMapping[MappingKey.Attributes]) + ' '

         templateIndex = 0

         if skipInitialIndentation == False or propertyString != "":
            propertyString += indentation

         if propertyType in Type.CollectionTypes:
            templateValues["datatype"] = str(propertyMapping[MappingKey.SubType])

            if propertyType == Type.ArrayType:
               templateIndex = 1
            elif propertyType == Type.DictionaryType:
               templateIndex = 2

         propertyString += self.dictionaryValueString(templateArray[templateIndex], templateValues)

         if propertyMappings.keys().index(propertyKey) <= len(propertyMappings.keys()) - 2:
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

      return renderedString


   def propertyMappingsArray(self):
      if self.jsonFormatEnabled:
         return json.load(open(self.mappingPath))
      else:
         return plistlib.readPlist(self.mappingPath)


   def filtered_mappings(self, propertyMappings, optional):
      filteredMappings = {}

      for propertyKey in propertyMappings.keys():
          propertyMapping = propertyMappings[propertyKey]

          if MappingKey.ModelConfig == propertyKey:
              continue

          if self.is_property_mapping_optional(propertyMapping) == optional:
               filteredMappings[propertyKey] = propertyMapping

      return filteredMappings


   def getPathForFile(self, fileName):
      return str.replace(os.path.abspath(__file__), "generator.py", fileName)

   def baseTemplate(self, path):
      propertyMappings  = self.propertyMappingsArray()

      fileString = str.replace(open(path, 'r').read(), '\n', '\r\n')
      classname = self.mappingPath[self.mappingPath.rindex('/',0,-1)+1:-1] if self.mappingPath.endswith('/') else self.mappingPath[self.mappingPath.rindex('/')+1:].split('.', 1 )[0]

      if self.testEnabled == 0:
          fileString = str.replace(fileString,  "{ TEST_IMPORT }", "import JSONModelKit\r\n")
      else:
          fileString = str.replace(fileString,  "{ TEST_IMPORT }", '\n')

      fileString = str.replace(fileString, "{ CLASSNAME }",  classname)

      return fileString
