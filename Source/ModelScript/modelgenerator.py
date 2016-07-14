#!/usr/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
import mappingKeys


class ClassGenerator:

   def __init__(self, plistPaths, output_directory, version, testEnabled):
      self.plistPaths = plistPaths
      self.output_directory = output_directory
      self.version = version
      self.testEnabled = testEnabled
      
   def generatedClass(self):
      templatePath = os.getcwd() + "/../../Source/ModelScript/Templates/internal_class_template.txt"
   
      newstring = open(templatePath, 'r').read()
      newstring = str.replace(newstring, '\n', '\r\n')   
   
      for mappingPath in self.plistPaths:
         classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]
      
         propertyMappings = plistlib.readPlist(mappingPath)

         if self.testEnabled == False:
            fileString = str.replace(newstring,  "{ TEST_IMPORT }",                    "import US2MapperKit") 
            newstring = fileString  

         fileString = str.replace(newstring,  "{ CLASSNAME }",                         classname)  
         fileString = str.replace(fileString, "{ OPTIONALS }",                         self.optional_property_definitions(propertyMappings))   
         fileString = str.replace(fileString, "{ NONOPTIONALS }",                      self.non_optional_property_definitions(propertyMappings))
         fileString = str.replace(fileString, "{ REQUIRED_INIT_PARAMS }",              self.required_init_properties_string(propertyMappings))
         fileString = str.replace(fileString, "{ REQUIRED_INIT_SETTERS }",             self.required_init_properties_setters_string(propertyMappings))
         fileString = str.replace(fileString, "{ FAILABLE_INIT_TEMP_NONOPTIONALS }",   self.init_temp_non_optionals(propertyMappings))
         fileString = str.replace(fileString, "{ SELF_NONOPTIONALS_INIT }",            self.non_optional_self_init_parameters(propertyMappings))
         fileString = str.replace(fileString, "{ OPTIONALS_UNWRAP }",                  self.unwrap_optional_parameters(propertyMappings))
         fileString = str.replace(fileString, "{ NONOPTIONALS_UNWRAP }",               self.unwrap_non_optional_parameters(propertyMappings))
        
         print fileString
         
      return fileString


   '''
   Replaces { OPTIONALS } in the template
   '''
   def optional_property_definitions(self, propertyMappings):
      valueTemplate        = "var propertyname : datatype?"
      arrayTemplate        = "var propertyname : [datatype]?"
      dictionatyTemplate   = "var propertyname : [String : datatype]?"
      
      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, True)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t", "\r\n    " ) 


   '''
   Replaces { NONOPTIONALS } in the template
   '''
   def non_optional_property_definitions(self, propertyMappings):
      valueTemplate        = "var propertyname : datatype"
      arrayTemplate        = "var propertyname : [datatype]"
      dictionatyTemplate   = "var propertyname : [String : datatype]"
      
      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)

      if len(filteredMappings) == 0 :
         return ""

      return "\r\n" +  self.generate_template_string(filteredMappings, templateArray, False, "\t", "\r\n    " )  


   '''
   Replaces { REQUIRED_INIT_PARAMS } in the template
   '''
   def required_init_properties_string(self, propertyMappings):
      valueTemplate        = "propertyname  _propertyname : datatype"
      arrayTemplate        = "propertyname  _propertyname : [datatype]"
      dictionatyTemplate   = "propertyname  _propertyname : [String : datatype]"
      
      templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t    ", ",\r\n    " ) 


   '''
   Replaces { REQUIRED_INIT_SETTERS } in the template
   '''
   def required_init_properties_setters_string(self, propertyMappings):
      valueTemplate      = "propertyname = _propertyname"
      
      templateArray = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)
      
      if len(filteredMappings) == 0 :
         return ""
      
      return "\r\n" + self.generate_template_string(filteredMappings, templateArray, False,  "\t\t\t\t\t", "\r\n    " )


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
      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t", "\r\n    " )   


   '''
   Replaces { NONOPTIONALS_UNWRAP } in the template
   '''
   def unwrap_non_optional_parameters(self, propertyMappings):
      valueTemplate  = "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"

      templateArray = [valueTemplate, valueTemplate, valueTemplate]
      filteredMappings = self.filtered_mappings(propertyMappings, False)

      return self.generate_template_string(filteredMappings, templateArray, True, "\t\t\t", "\r\n    " )   

   def generate_template_string(self, propertyMappings, templateArray, skipInitialIndentation, indentation, carriageString):

      if len(propertyMappings) == 0 :
         return ""

      propertyString = ""

      for propertyKey in propertyMappings.keys():
         
         propertyMapping = propertyMappings[propertyKey]
         propertyType = propertyMapping[mappingKeys.DataTypeKey]
         isMappingOptional = self.is_property_mapping_optional(propertyMapping)
         
         templateValues = {}
         templateValues["propertyname"] = propertyKey
         templateValues["datatype"] = propertyType
         
         templateIndex = 0

         if skipInitialIndentation == False or propertyString != "":
            propertyString += indentation

         if propertyType in mappingKeys.CollectionTypes:
            templateValues["datatype"] = propertyMapping[mappingKeys.SubTypeKey]
               
            if propertyType == mappingKeys.ArrayType:
               templateIndex = 1
            elif propertyType == mappingKeys.DictionaryType:
               templateIndex = 2
            
         propertyString += self.dictionaryValueString(templateArray[templateIndex], templateValues)

         if propertyMappings.keys().index(propertyKey) <= len(propertyMappings.keys()) - 2:
            propertyString += carriageString
         else:
            propertyString += ""
            
      return propertyString


   def filtered_mappings(self, propertyMappings, optional):
      filteredMappings = {}

      for propertyKey in propertyMappings.keys():
         
         propertyMapping = propertyMappings[propertyKey]
         
         if self.is_property_mapping_optional(propertyMapping) == optional:
            filteredMappings[propertyKey] = propertyMapping

      return filteredMappings

   def is_property_mapping_optional(self, mapping):
      if mappingKeys.NonOptionalKey in mapping.keys() and mapping[mappingKeys.NonOptionalKey] == 'true':
         return False
      else:
         return True

   def dictionaryValueString(self, templateString, dictionaryValues):
      renderedString = templateString  

      for key in dictionaryValues.keys():
         renderedString = str.replace(renderedString, key, dictionaryValues[key])

      return renderedString
