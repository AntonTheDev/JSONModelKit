#!/usr/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
import json

sys.dont_write_bytecode = True

from constants import Type
from constants import MappingKey

class Serializer:
  
   def __init__(self, mappingPath, output_directory, version, testEnabled, jsonFormatEnabled):
      self.mappingPath = mappingPath
      self.output_directory = output_directory
      self.version = version
      self.testEnabled = testEnabled
      self.jsonFormatEnabled = jsonFormatEnabled

   def serializerString(self):
      propertyMappings = self.propertyMappingsArray()
      uniqueGroups = self.uniqueGroups(propertyMappings)

      if len(uniqueGroups) == 0:
         return ""

      fileString = self.baseTemplate(self.getPathForFile("internal_serialization_template.txt"))
     
      fileString = str.replace(fileString, "{ CREATE_SERIALIZATION_ENUM }",         self.serialization_enum(propertyMappings, uniqueGroups))
      fileString = str.replace(fileString, "{ SERIALIZATION_SWITCH }",              self.serialization_switch(propertyMappings, uniqueGroups))
      fileString = str.replace(fileString, "{ SERIALIZATION_FUNCTIONS }",           self.serialization_functions(propertyMappings, uniqueGroups))
      
      return fileString

   '''
   Replaces { CREATE_SERIALIZATION_ENUM } in the template
   '''
   def serialization_enum(self, propertyMappings, uniqueGroups):
      propertyString = ""
     
      for group in uniqueGroups:
         propertyString += "\r\n\t\t case _" + group + "\t\t= \"" + group + "\""

      return str(propertyString) 

   '''
   Replaces { SERIALIZATION_SWITCH } in the template
   '''
   def serialization_switch(self, propertyMappings, uniqueGroups):
      propertyString = ""
     
      for group in uniqueGroups:
         propertyString += "\r\n\t\t\tcase ._" + group + ":\r\n\t\t\t\treturn serialized" + group + "()"

      return str(propertyString)

   '''
   Replaces { SERIALIZATION_FUNCTIONS } in the template
   '''
   def serialization_functions(self, propertyMappings, uniqueGroups):

      propertyString = ""

      for group in uniqueGroups:

         optionalPropertyString = ""
         nonOptionalPropertyString = ""
         propertyString += "\tprivate func serialized" + group + "() -> [String : Any] { \r\n\t\tvar params = [String : Any]()\r\n"
     
         for propertyKey in propertyMappings.keys():
            if MappingKey.Groups in propertyMappings[propertyKey].keys():
                if group in propertyMappings[propertyKey][MappingKey.Groups]:
                  mappingOptional = self.is_property_mapping_optional(propertyMappings[propertyKey])
                
                  if mappingOptional == False:
                        nonOptionalPropertyString += "\r\n\t\tparams[\"" + propertyMappings[propertyKey][MappingKey.Key] + "\"] = " + propertyKey
                  else:
                        optionalPropertyString += "\r\n\r\n\t\tif let unwrapped_" + propertyMappings[propertyKey][MappingKey.Key] + " = " + propertyKey + " { "
                        optionalPropertyString += "\r\n\t\t\tparams[\"" + propertyMappings[propertyKey][MappingKey.Key] + "\"] =  unwrapped_" +  propertyMappings[propertyKey][MappingKey.Key] + "\r\n\t\t}"

         propertyString += nonOptionalPropertyString
         propertyString += optionalPropertyString
                
         propertyString += "\r\n\r\n\t\treturn params\r\n\t}\r\n\r\n\r\n" 
      
      return str(propertyString)


   def baseTemplate(self, path):
      propertyMappings = self.propertyMappingsArray()
      
      fileString = str.replace(open(path, 'r').read(), '\n', '\r\n')   
   
      return fileString


   '''
   Finds all the unique groups
   '''
   def uniqueGroups(self, propertyMappings):      
      uniqueGroups = []

      for propertyKey in propertyMappings.keys():
         if MappingKey.Groups in propertyMappings[propertyKey].keys():
            for group in propertyMappings[propertyKey][MappingKey.Groups]:
               if group not in uniqueGroups:
                  uniqueGroups.append(group)

      return uniqueGroups


   def propertyMappingsArray(self):
      if self.jsonFormatEnabled:
         return json.load(open(self.mappingPath))
      else: 
         return plistlib.readPlist(self.mappingPath)

   def getPathForFile(self, fileName):
      return str.replace(os.path.abspath(__file__), "serializer.py", fileName)

   def is_property_mapping_optional(self, mapping):
      if MappingKey.NonOptional in mapping.keys() and mapping[MappingKey.NonOptional]:
         return False
      else:
         return True

