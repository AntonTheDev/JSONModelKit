#!/usr/bin/python
import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands

sys.dont_write_bytecode = True

from constants import Type
from constants import MappingKey

class Validator:
   
   def __init__(self, classname, mapping):
      self.classname = classname
      self.mapping = mapping

   def validateMapping(self):
      for propertyKey in self.mapping.keys():
         if MappingKey.Type not in self.mapping[propertyKey].keys():
            if MappingKey.Transformer not in self.mapping[propertyKey].keys():
               self.throw_missing_type_error(MappingKey.Transformer, self.mapping[propertyKey])
         
         if MappingKey.Key not in self.mapping[propertyKey].keys():
            if MappingKey.Transformer not in self.mapping[propertyKey].keys():
               self.throw_missing_json_key_error(MappingKey.MappingKey, self.mapping[propertyKey])
            
            else:
               propertyType = self.mapping[propertyKey][MappingKey.Key]
               if xcode_version() == 6.0 and propertyType not in Type.NativeTypes:
                  if MappingKey.NonOptional in self.mapping[propertyKey].keys():
                     if self.mapping[propertyKey][MappingKey.NonOptional] == 'true':
                        self.throw_missing_nonoptional_error(MappingKey.Key, self.mapping[propertyKey])

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
      print "\r\nJMMapper Error: Invalid Configuration (" + self.classname + ".plist)\r\n"
      print "Mapping : \t\t"
      print mapping
      print "\r\n"

