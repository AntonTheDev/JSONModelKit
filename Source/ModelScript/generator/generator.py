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

   def __init__(self, mappingPath, output_directory, version, testEnabled):
      self.mappingPath = mappingPath
      self.output_directory = output_directory
      self.version = version
      self.testEnabled = testEnabled
      
   def internalGeneratedClass(self):
      templatePath = os.getcwd() + "/../../Source/ModelScript/Templates/internal_class_template.txt"
   
      internalTemplate = open(templatePath, 'r').read()
      internalTemplate = str.replace(internalTemplate, '\n', '\r\n')   
      fileString = ""

      classname = self.mappingPath[self.mappingPath.rindex('/',0,-1)+1:-1] if self.mappingPath.endswith('/') else self.mappingPath[self.mappingPath.rindex('/')+1:].split('.', 1 )[0]
      
      propertyMappings = plistlib.readPlist(self.mappingPath)

      if self.testEnabled == 0:
         fileString = str.replace(internalTemplate,  "{ TEST_IMPORT }", "import US2MapperKit") 
         internalTemplate = fileString 
      else:
         fileString = str.replace(internalTemplate,  "{ TEST_IMPORT }", "") 

      fileString = str.replace(fileString, "{ CLASSNAME }",                         classname)  
      fileString = str.replace(fileString, "{ OPTIONALS }",                         self.optional_property_definitions(propertyMappings))   
      fileString = str.replace(fileString, "{ NONOPTIONALS }",                      self.non_optional_property_definitions(propertyMappings))
      fileString = str.replace(fileString, "{ REQUIRED_INIT_PARAMS }",              self.required_init_properties_string(propertyMappings))
      fileString = str.replace(fileString, "{ REQUIRED_INIT_SETTERS }",             self.required_init_properties_setters_string(propertyMappings))
      fileString = str.replace(fileString, "{ FAILABLE_INIT_TEMP_NONOPTIONALS }",   self.init_temp_non_optionals(propertyMappings))
      fileString = str.replace(fileString, "{ SELF_NONOPTIONALS_INIT }",            self.non_optional_self_init_parameters(propertyMappings))
      fileString = str.replace(fileString, "{ OPTIONALS_UNWRAP }",                  self.unwrap_optional_parameters(propertyMappings))
      fileString = str.replace(fileString, "{ NONOPTIONALS_UNWRAP }",               self.unwrap_non_optional_parameters(propertyMappings))

      return fileString

   def externalGeneratedClass(self):
      templatePath = os.getcwd() + "/../../Source/ModelScript/Templates/external_class_template.txt"
   
      externalTemplate = open(templatePath, 'r').read()
      externalTemplate = str.replace(externalTemplate, '\n', '\r\n')   
      fileString = ""

      classname = self.mappingPath[self.mappingPath.rindex('/',0,-1)+1:-1] if self.mappingPath.endswith('/') else self.mappingPath[self.mappingPath.rindex('/')+1:].split('.', 1 )[0]
      
      propertyMappings = plistlib.readPlist(self.mappingPath)

      if self.testEnabled == 0:
         fileString = str.replace(externalTemplate,  "{ TEST_IMPORT }", "import US2MapperKit") 
         internalTemplate = fileString 
      else:
         fileString = str.replace(externalTemplate,  "{ TEST_IMPORT }", "") 

      fileString = str.replace(fileString, "{ CLASSNAME }",  classname)  

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


class InstantiatorGenerator:

   def __init__(self, plistPaths, output_directory, version, testEnabled):
      self.plistPaths = plistPaths
      self.output_directory = output_directory
      self.version = version
      self.testEnabled = testEnabled
   
   def internalGeneratedClass(self):
      templatePath = os.getcwd() + "/../../Source/ModelScript/Templates/instantiator_template.txt"

      internalTemplate = open(templatePath, 'r').read()
      internalTemplate = str.replace(internalTemplate, '\n', '\r\n')
      
      if self.testEnabled == 0:
         internalTemplate = str.replace(internalTemplate,  "{ TEST_IMPORT }", "import US2MapperKit") 
      else:
         internalTemplate = str.replace(internalTemplate,  "{ TEST_IMPORT }", "")
         
      classnames = []

      for mapping in self.plistPaths:
         filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
         classname = filename.split('.', 1 )[0]
         classnames.append(classname)


      fileString = internalTemplate

      #classname = self.mappingPath[self.mappingPath.rindex('/',0,-1)+1:-1] if self.mappingPath.endswith('/') else self.mappingPath[self.mappingPath.rindex('/')+1:].split('.', 1 )[0]

      #propertyMappings = plistlib.readPlist(self.mappingPath)

      fileString = str.replace(fileString, "{ CASE_ENUM_DEFINITION }",           self.class_case_statements(classnames))
      fileString = str.replace(fileString, "{ SWITCH_CASE_ENUM_INSTANTIATE }",      self.class_switch_statements(classnames))
      fileString = str.replace(fileString, "{ CASE_TRANSAFORMER_ENUM_DEFINITION }",   self.transformer_case_statements())
      fileString = str.replace(fileString, "{ CASE_TRANSAFORMER_ENUM_RETURN }",     self.transformer_switch_statements())
      print fileString
      return fileString


   '''
   Replaces { CASE_ENUM_DEFINITION } in the template
   '''

   def class_case_statements(self, classnames):
      caseString = ""
      for classname in classnames:
         caseString = caseString + 'case _' + classname + ' \t= "'+ classname + '"\n\t'

      caseString = caseString + 'case _None \t\t\t= \"None\"'

      return caseString

   def class_switch_statements(self, classnames):
      
      caseString = ""
      for classname in classnames:
         caseString = caseString + 'case ._' + classname + ':\n\t\t\treturn '+ classname + '(data)' 
         if classnames.index(classname) <= len(classnames) - 2:
            caseString = caseString + '\n\t\t'
      return caseString

   def transformer_case_statements(self):
      
      distinctMapperClassDefinitions = []
      
      caseString = ""
      
      for mappingPath in self.plistPaths:
         propertyMapping = plistlib.readPlist(mappingPath)

         for propertyKey in propertyMapping.keys():
            
            if mappingKeys.TransformerKey in propertyMapping[propertyKey].keys():
               mapperClass = propertyMapping[propertyKey][mappingKeys.TransformerKey]
               if mapperClass not in distinctMapperClassDefinitions:
                  distinctMapperClassDefinitions.append(mapperClass)

      for mapperClass in distinctMapperClassDefinitions:
         caseString = caseString + 'case _' + mapperClass + ' \t= "'+ mapperClass + '"'
         if distinctMapperClassDefinitions.index(mapperClass) <= len(distinctMapperClassDefinitions) - 2:
            caseString = caseString + '\n\t'
      
      return caseString

   def transformer_switch_statements(self):
      
      distinctMapperClassDefinitions = []
      
      caseString = ""
      
      for mappingPath in self.plistPaths:
         propertyMapping = plistlib.readPlist(mappingPath)

         for propertyKey in propertyMapping.keys():
            
            if mappingKeys.TransformerKey in propertyMapping[propertyKey].keys():
               mapperClass = propertyMapping[propertyKey][mappingKeys.TransformerKey]
               if mapperClass not in distinctMapperClassDefinitions:
                  distinctMapperClassDefinitions.append(mapperClass)

      for mapperClass in distinctMapperClassDefinitions:
         caseString = caseString + 'case ._' + mapperClass + ':\n\t\t\treturn '+ mapperClass + '()'
         
         if distinctMapperClassDefinitions.index(mapperClass) <= len(distinctMapperClassDefinitions) - 2:
            caseString = caseString + '\n\t\t'
      
      return caseString


class Validator:
   
   def __init__(self, classname, mapping):
      self.classname = classname
      self.mapping = mapping

   def validateMapping(self):
      for propertyKey in self.mapping.keys():
         if mappingKeys.DataTypeKey not in self.mapping[propertyKey].keys():
            if mappingKeys.TransformerKey not in self.mapping[propertyKey].keys():
               self.throw_missing_type_error(mappingKeys.TransformerKey, self.mapping[propertyKey])
         
         if mappingKeys.MappingKey not in self.mapping[propertyKey].keys():
            if mappingKeys.TransformerKey not in self.mapping[propertyKey].keys():
               self.throw_missing_json_key_error(mappingKeys.MappingKey, self.mapping[propertyKey])
            
            else:
               propertyType = self.mapping[propertyKey][mappingKeys.MappingKey]
               if xcode_version() == 6.0 and propertyType not in mappingKeys.NativeTypes:
                  if mappingKeys.NonOptionalKey in self.mapping[propertyKey].keys():
                     if self.mapping[propertyKey][mappingKeys.NonOptionalKey] == 'true':
                        self.throw_missing_nonoptional_error(mappingKeys.MappingKey, self.mapping[propertyKey])

   def throw_missing_type_error(self, propertykey, mapping):
      self.print_default_error_header(mapping)
      print "The mapping configuration for the " + propertykey + " property is missing the type configuration.\r\nAll properties must specify a 'type' value.\r\n\r\n\r\n\r\n"
      raise Exception('Invalid Configuration')

   def throw_missing_nonoptional_error(self, propertykey, mapping):
      self.print_default_error_header(mapping)
      print "The mapping configuration for the " + propertykey + " cannot be performed. Transformed properties have to be optional when not defined as a native datatype (String, Int, Float, Double, Bool, Array, Dictionary).\r\n\r\n\r\n\r\n"
      raise Exception('Invalid Configuration')

   def throw_missing_json_key_error(self, propertykey, mapping):
      self.print_default_error_header(mapping)
      print "The mapping configuration for the " + propertykey + " property is missing the \"key\" configuration.\r\nAll properties must specify a 'key' value to map against value in a dictionary.\r\n\r\n\r\n\r\n"
      raise Exception('Invalid Configuration')

   def print_default_error_header(self, mapping):
      print "\r\nUS2Mapper Error: Invalid Configuration (" + self.classname + ".plist)\r\n"
      print "Mapping : \t\t"
      print mapping
      print "\r\n"

