#!/usr/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
import mappingKeys

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

