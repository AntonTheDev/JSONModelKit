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

class InstantiatorGenerator:

   def __init__(self, plistPaths, output_directory, version, testEnabled, jsonFormatEnabled, instantiatorName):
      self.plistPaths = plistPaths
      self.output_directory = output_directory
      self.version = version
      self.testEnabled = testEnabled
      self.jsonFormatEnabled = jsonFormatEnabled
      self.instantiatorName = instantiatorName

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

      #fileString = str.replace(internalTemplate,     "{ CASE_ENUM_DEFINITION }",                 self.class_case_statements(classnames))
      fileString = str.replace(internalTemplate,       "{ SWITCH_CASE_ENUM_INSTANTIATE }",         self.class_case_statements(classnames))
      fileString = str.replace(fileString,             "{ INSTANTIATOR_NAME }",                    self.instantiatorName)
      fileString = str.replace(fileString,             "{ CASE_ENUM_DEFINITION }",                 self.class_switch_mapping(classnames))
      fileString = str.replace(fileString,             "{ CASE_TRANSAFORMER_ENUM_DEFINITION }",    self.transformer_case_statements())
      fileString = str.replace(fileString,             "{ CASE_TRANSAFORMER_ENUM_RETURN }",        self.transformer_switch_statements())
      return fileString


   '''
   Replaces { CASE_ENUM_DEFINITION } in the template
   '''
   def class_case_statements(self, classnames):
      caseString = ""
      for classname in classnames:
         if caseString != '':
           caseString = caseString + ',\n'

         caseString = caseString + '\t\t' + classname.upper() + '{ \n\t\t\t\toverride fun createObject(data: HashMap<String, Any>): Any? { \n\t\t\t\t\t\treturn ' + classname + '(data)\n\t\t\t\t}\n\t\t\n\t\t\toverride fun mapping(): HashMap<String, Any>? { \n\t\t\t\t\treturn ' + classname + '(data)\n\t\t\t}\n\t\t}'


      caseString = caseString + ';'
      return caseString

   def class_switch_statements(self, classnames):


      caseString = ""
      for classname in classnames:
         caseString = caseString + 'case ._' + classname + ':\n\t\t\treturn '+ classname + '(data)'
         if classnames.index(classname) <= len(classnames) - 2:
            caseString = caseString + '\n\t\t'

      return caseString

   def class_switch_mapping(self, classnames):

      caseString = ""

      for mapping in self.plistPaths:
        filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
        classname = filename.split('.', 1 )[0]
        propertyMapping = self.propertyMappingDictionary(mapping)
        if caseString != '':
          caseString = caseString + ','
        #caseString = caseString + classname + ' -> \n\t\t\treturn \"'+ json.dumps(propertyMapping).replace("\"", "\\\"") + '\"'
        caseString = caseString + '\n\t\t' + classname.upper() + ' { \n\t\t\toverride fun createObject(data: HashMap<String, Any>): Any? { \n\t\t\t\t\t\n\t\t\tvar new'+ classname + ' = ' + classname + '(data)\n\t\t\tnew' + classname + '.mapData()\n\t\t\treturn new'+ classname + '\n\t\t\t}\n\t\t\n\t\t\toverride fun mapping(): String? { \n\t\t\t\t\treturn \"' + json.dumps(propertyMapping).encode('unicode-escape').replace("\"", "\\\"")  + '\"\n\t\t\t}\n\t\t}'

      caseString = caseString + ';'
      return caseString

   def transformer_case_statements(self):

      distinctMapperClassDefinitions = []

      caseString = ""

      for mappingPath in self.plistPaths:
         propertyMapping = self.propertyMappingDictionary(mappingPath)

         for propertyKey in propertyMapping.keys():

            if MappingKey.JMTransformer in propertyMapping[propertyKey].keys():
               mapperClass = propertyMapping[propertyKey][MappingKey.JMTransformer]
               if mapperClass not in distinctMapperClassDefinitions:
                  distinctMapperClassDefinitions.append(mapperClass)

      for mapperClass in distinctMapperClassDefinitions:
         if caseString != '':
           caseString = caseString + ','

         caseString = caseString + '\n\t\t' + mapperClass.upper() + '{ \n\t\t\toverride fun transformer(): JMTransformerProtocol? { \n\t\t\t\t\treturn ' + mapperClass + '()\n\t\t\t}\n\t\t}'


         if distinctMapperClassDefinitions.index(mapperClass) <= len(distinctMapperClassDefinitions) - 2:
            caseString = caseString + ''

      caseString = caseString + ';'
      return  str(caseString)

   def transformer_switch_statements(self):

      distinctMapperClassDefinitions = []

      caseString = ""

      for mappingPath in self.plistPaths:

         propertyMapping = self.propertyMappingDictionary(mappingPath)

         for propertyKey in propertyMapping.keys():

            if MappingKey.JMTransformer in propertyMapping[propertyKey].keys():
               mapperClass = propertyMapping[propertyKey][MappingKey.JMTransformer]
               if mapperClass not in distinctMapperClassDefinitions:
                  distinctMapperClassDefinitions.append(mapperClass)

      for mapperClass in distinctMapperClassDefinitions:
         caseString = caseString + 'case ._' + mapperClass + ':\n\t\t\treturn '+ mapperClass + '()'

         if distinctMapperClassDefinitions.index(mapperClass) <= len(distinctMapperClassDefinitions) - 2:
            caseString = caseString + '\n\t\t'

      return str(caseString)

   def propertyMappingDictionary(self, mappingPath):
      if self.jsonFormatEnabled == True:
         #print mappingPath
         return json.load(open(mappingPath))
      return plistlib.readPlist(mappingPath)


   def getPathForFile(self, fileName):
      return str.replace(os.path.abspath(__file__), "instantiator.py", fileName)
