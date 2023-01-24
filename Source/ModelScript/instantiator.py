#!/usr/bin/python
import plistlib
import os
import sys
import getopt
import glob
import subprocess
import json

sys.dont_write_bytecode = True

from constants import Type
from constants import MappingKey

class InstantiatorGenerator:

   def __init__(self, plistPaths, output_directory, version, testEnabled, jsonFormatEnabled):
      self.plistPaths = plistPaths
      self.output_directory = output_directory
      self.version = version
      self.testEnabled = testEnabled
      self.jsonFormatEnabled = jsonFormatEnabled

   def internalGeneratedClass(self):
      templatePath = self.getPathForFile("instantiator_template.txt")

      internalTemplate = open(templatePath, 'r').read()
      internalTemplate = str.replace(internalTemplate, '\n', '\r\n')

      if self.testEnabled == 0:
         internalTemplate = str.replace(internalTemplate,  "{ PROD_IMPORT }", "")
      else:
         internalTemplate = str.replace(internalTemplate,  "{ PROD_IMPORT }", "")

      classnames = []

      for mapping in self.plistPaths:
         filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
         classname = filename.split('.', 1 )[0]
         classnames.append(classname)

      fileString = str.replace(internalTemplate, "{ CASE_ENUM_DEFINITION }",                 self.class_case_statements(classnames))
      fileString = str.replace(fileString,       "{ SWITCH_CASE_STATIC_MAPPING }",           self.class_switch_static_mapping(classnames))
      fileString = str.replace(fileString,       "{ SWITCH_CASE_ENUM_INSTANTIATE }",         self.class_switch_statements(classnames))
      fileString = str.replace(fileString,       "{ SWITCH_CASE_MAPPING }",                  self.class_switch_mapping(classnames))
      fileString = str.replace(fileString,       "{ CASE_TRANSAFORMER_ENUM_DEFINITION }",    self.transformer_case_statements())
      fileString = str.replace(fileString,       "{ SWITCH_CASE_STATIC_TRANSFORMERS }",      self.transformer_static_instances())
      fileString = str.replace(fileString,       "{ CASE_TRANSAFORMER_ENUM_RETURN }",        self.transformer_switch_statements())
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


   def class_switch_static_mapping(self, classnames):

      caseString = ""

      for mapping in self.plistPaths:
        filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
        classname = filename.split('.', 1 )[0]
        propertyMapping = self.propertyMappingDictionary(mapping)

        caseString = caseString + 'static let mapping' + classname + ' = "' + json.dumps(propertyMapping).replace("\"", "\\\"") + '\"\n'

        if classnames.index(classname) <= len(classnames) - 2:
          caseString = caseString + '\n\t\t'

      return caseString

   def class_switch_mapping(self, classnames):

      caseString = ""

      for mapping in self.plistPaths:
        filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
        classname = filename.split('.', 1 )[0]
        propertyMapping = self.propertyMappingDictionary(mapping)

        caseString = caseString + 'case ._' + classname + ':\n\t\t\treturn JMStaticMapping.mapping'+ classname + "\n"

        if classnames.index(classname) <= len(classnames) - 2:
          caseString = caseString + '\n\t\t'

      return caseString

   def transformer_case_statements(self):

      distinctMapperClassDefinitions = []

      caseString = ""

      for mappingPath in self.plistPaths:
         propertyMapping = self.propertyMappingDictionary(mappingPath)

         for propertyKey in list(propertyMapping.keys()):

            if MappingKey.JMSDKTransformer in list(propertyMapping[propertyKey].keys()):
               mapperClass = propertyMapping[propertyKey][MappingKey.JMSDKTransformer]
               if mapperClass not in distinctMapperClassDefinitions:
                  distinctMapperClassDefinitions.append(mapperClass)

      for mapperClass in distinctMapperClassDefinitions:
         caseString = caseString + 'case _' + mapperClass + ' \t= "'+ mapperClass + '"'
         if distinctMapperClassDefinitions.index(mapperClass) <= len(distinctMapperClassDefinitions) - 2:
            caseString = caseString + '\n\t'

      return  str(caseString)

   def transformer_static_instances(self):

      distinctMapperClassDefinitions = []

      caseString = ""

      for mappingPath in self.plistPaths:
         propertyMapping = self.propertyMappingDictionary(mappingPath)

         for propertyKey in list(propertyMapping.keys()):

            if MappingKey.JMSDKTransformer in list(propertyMapping[propertyKey].keys()):
               mapperClass = propertyMapping[propertyKey][MappingKey.JMSDKTransformer]
               if mapperClass not in distinctMapperClassDefinitions:
                  distinctMapperClassDefinitions.append(mapperClass)

      for mapperClass in distinctMapperClassDefinitions:
         lowercasedString = mapperClass[:1].lower() + mapperClass[1:]
         caseString = caseString + 'static let ' + lowercasedString + ' \t= '+ mapperClass + '()\n\t'
         if distinctMapperClassDefinitions.index(mapperClass) <= len(distinctMapperClassDefinitions) - 2:
            caseString = caseString + '\n\t'

      return  str(caseString)

   def transformer_switch_statements(self):

      distinctMapperClassDefinitions = []

      caseString = ""

      for mappingPath in self.plistPaths:

         propertyMapping = self.propertyMappingDictionary(mappingPath)

         for propertyKey in list(propertyMapping.keys()):

            if MappingKey.JMSDKTransformer in list(propertyMapping[propertyKey].keys()):
               mapperClass = propertyMapping[propertyKey][MappingKey.JMSDKTransformer]
               if mapperClass not in distinctMapperClassDefinitions:
                  distinctMapperClassDefinitions.append(mapperClass)

      for mapperClass in distinctMapperClassDefinitions:
         lowercasedString = mapperClass[:1].lower() + mapperClass[1:]
         caseString = caseString + 'case ._' + mapperClass + ':\n\t\t\treturn JMStaticTransformers.'+ lowercasedString + ''

         if distinctMapperClassDefinitions.index(mapperClass) <= len(distinctMapperClassDefinitions) - 2:
            caseString = caseString + '\n\t\t'

      return str(caseString)


   def propertyMappingDictionary(self, mappingPath):
      if self.jsonFormatEnabled == True:
         print(mappingPath)
         return json.load(open(mappingPath))
      return plistlib.readPlist(mappingPath)


   def getPathForFile(self, fileName):
      return str.replace(os.path.abspath(__file__), "instantiator.py", fileName)
