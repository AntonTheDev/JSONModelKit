import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
import json

from generator 	import ClassGenerator
from instantiator import InstantiatorGenerator
from validator 	import Validator

def generate_model(plistPaths, output_directory, version, testEnabled, jsonFormatEnabled):
	
	instantiatorPath = output_directory + 'Internal/US2Instantiator.swift'
	instantiatorGenerator = InstantiatorGenerator(plistPaths, output_directory, version, testEnabled, jsonFormatEnabled)
	
	generate_file(instantiatorGenerator.internalGeneratedClass(), instantiatorPath, True)

	for mappingPath in plistPaths:
		classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]
		
		propertyMappings = []
         

		if jsonFormatEnabled == True:
			propertyMappings = json.load(open(mappingPath))
		else: 
			propertyMappings = plistlib.readPlist(mappingPath)

		classGenerator = ClassGenerator(mappingPath, output_directory, version, testEnabled, jsonFormatEnabled)
		
		internalClassPath = output_directory + 'Internal/_'+ classname + '.swift'
		externalClassPath = output_directory + classname + '.swift'
		
		validator = Validator(classname, propertyMappings)
		validator.validateMapping()

		internalClass = classGenerator.internalGeneratedClass()
		externalClass= classGenerator.externalGeneratedClass()
		
		generate_file(internalClass, internalClassPath, True)
		generate_file(externalClass, externalClassPath, False)


def generate_file(content, filePath, overwrite):
	if os.path.exists(filePath) and overwrite == False:   
   		return None

	if not os.path.exists(os.path.dirname(filePath)):
		os.makedirs(os.path.dirname(filePath))
	
	outputfile = open(filePath, "wba")

	fileContent = content
	outputfile.write(fileContent)
	outputfile.close();


def xcode_version():
	status, xcodeVersionString = commands.getstatusoutput("xcodebuild -version")
	if xcodeVersionString.find("Xcode 7.")  != -1:
		return 7.0
	else:
		return 6.0


def main(argv):
   inputfile = ''
   outputfile = ''
   testEnabled = 0
   fileformat = "json"

   try:
      opts, args = getopt.getopt(argv,"hv:i:o:t:f:",["version=","mapdir=","classname=","testing=","format="])
   except getopt.GetoptError:
      print 'test.py -i <inputfile> -o <outputfile>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'test.py -i <inputfile> -o <outputfile>'
         sys.exit()
      elif opt in ("-v", "--ifile"):
         currentVersion = arg
      elif opt in ("-i", "--ofile"):
         mapdir = arg
      elif opt in ("-o", "--ifile"):
         classdir = arg
      elif opt in ("-t", "--ofile"):
         testEnabled = arg
      elif opt in ("-f", "--ofile"):
         fileformat = arg

   if fileformat == "json":
   	   	mappinglist = glob.glob(mapdir + "*.json") 
   		generate_model(mappinglist, classdir, currentVersion, testEnabled, True)
   else:
   		mappinglist = glob.glob(mapdir + "*.plist") 
   		generate_model(mappinglist, classdir, currentVersion, testEnabled, False)
  

   
   #print 'Input file is "', inputfile
   #print 'Output file is "', outputfile

if __name__ == "__main__":
   main(sys.argv[1:])
