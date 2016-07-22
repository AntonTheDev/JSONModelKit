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
         return str.replace(open(self.getPathForFile("nil_serialization_template.txt"), 'r').read(), '\n', '\r\n')   

      fileString = str.replace(open(self.getPathForFile("internal_serialization_template.txt"), 'r').read(), '\n', '\r\n')   

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
      runningClassString = ""
        
      for group in uniqueGroups:
         runningClassString += "\tprivate func serialized" + group + "() -> [String : Any] { \r\n\t\tvar params = [String : Any]()\r\n\r\n"

         for propertyKey in propertyMappings.keys():

            propertyMap  = propertyMappings[propertyKey]
            propertyKeys = propertyMap.keys()
           
            optional = self.is_property_mapping_optional(propertyMap)
            
            if MappingKey.Groups in propertyKeys:
                
                if group in propertyMap[MappingKey.Groups]:
               
                  propertyType = propertyMap[MappingKey.Type]
                  propertyJSONKey = propertyMap[MappingKey.Key]
               
                  if propertyType in Type.NativeTypes:
                     runningClassString += "\t\tparams[\"" + propertyJSONKey + "\"] = " + propertyKey + "\r\n" 
                  elif propertyType in Type.CollectionTypes:
                     runningClassString += self.collectionString(propertyKey, propertyMap, group, optional)
                  else:
                     if optional == False:
                        runningClassString += "\t\t\tparams[\"" + propertyJSONKey + "\"] = " + propertyKey + ".params(forGroup :\"" + group + "\")\r\n\t\t\r\n" 
                     else:
                        runningClassString += "\t\tif let instance = " + propertyKey + " { \r\n"
                        runningClassString += "\t\t\tparams[\"" + propertyJSONKey + "\"] =  instance.params(forGroup :\"" + group + "\")\r\n\t\t}\r\n\r\n" 

         runningClassString += "\r\n\t\treturn params\r\n\t}\r\n\r\n" 

      return str(runningClassString)

   def collectionString(self, propertyKey, propertyMap, group, optional):
      
      runningString = ""
      
      propertyType = propertyMap[MappingKey.Type]
      propertyJSONKey = propertyMap[MappingKey.Key]         
      propertySubType = propertyMap[MappingKey.SubType]
      
      if propertySubType in Type.NativeTypes:
         runningString += "\t\tparams[\"" + propertyJSONKey + "\"] = " + propertyKey  + "\r\n" 
                 
      elif propertyType == Type.ArrayType:
         if propertySubType in Type.CollectionTypes:
            print "RECURSIVE TIME"
         else:
            if optional == False:
                runningString += "\t\tparams[\"" + propertyJSONKey + "\"] = " + propertyKey + ".map { $0.params(forGroup :\"" + group + "\")" + " }\r\n\r\n"
            else:   
               runningString += "\t\tif let array = " + propertyKey + " { \r\n"
               runningString += "\t\t\tparams[\"" + propertyJSONKey + "\"] = array.map { $0.params(forGroup :\"" + group + "\") }" + "\r\n\t\t}\r\n\r\n"
                           
      elif propertyType == Type.DictionaryType:   
         if propertySubType in Type.CollectionTypes:
            print "RECURSIVE TIME"
         else:
            if optional == True:
               runningString += "\r\n\t\tif let dictionary = " + propertyKey + " { \r\n"
               runningString += "\t\t\tvar newDict = [String : Any]()\r\n\r\n\t\t\tfor (key, value) in dictionary {\r\n\t\t\t\tnewDict[key] = value.params(forGroup :\"" + group+   "\")  \r\n\t\t\t}\r\n"
               runningString += "\r\n\t\t\tparams[\"" + propertyJSONKey + "\"] = newDict\r\n\t\t}\r\n"
            else:
               runningString += "\t\tvar new"+ propertyKey +"Dict = [String : Any]()\r\n\r\n\t\tfor (key, value) in "+ propertyKey + " {\r\n\t\t\tnew"+ propertyKey +"Dict[key] = value.params(forGroup :\"" + group+   "\")  \r\n\t\t\t}\r\n"
               runningString += "\r\n\t\tparams[\"" + propertyJSONKey + "\"] = new"+ propertyKey +"Dict\r\n\t\t\r\n"
            
               #runningString += "\r\n\t\t\tparams[\"" + propertyJSONKey + "\"] = " + propertyKey + ".params(forGroup :\"" + group + "\")" + "\r\n\r\"\r\n\t\t\r\n"
            
      return runningString
                    
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

