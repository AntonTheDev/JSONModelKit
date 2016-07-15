import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands

from generators import ClassGenerator
from generators import InstantiatorGenerator
from validator  import Validator

def generate_model(plistPaths, output_directory, version, testEnabled):

	for mappingPath in plistPaths:
		classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]
		
		classGenerator = ClassGenerator(mappingPath, output_directory, version, testEnabled)
	
		classPropertyMappings = plistlib.readPlist(mappingPath)
		validator = Validator(classname, classPropertyMappings)
		validator.validateMapping()

		classFileContent = classGenerator.internalGeneratedClass()
		externalFileContent = classGenerator.externalGeneratedClass()
		
		generate_external_file(classGenerator.externalGeneratedClass(), classname, output_directory)
		generate_internal_file(classGenerator.internalGeneratedClass(), classname, output_directory)

	instantiatorGenerator = InstantiatorGenerator(plistPaths, output_directory, version, testEnabled)
	
	generate_instantiator_file(instantiatorGenerator.internalGeneratedClass(), output_directory)


def generate_external_file(content, classname, class_directory):
	
	filename = class_directory + classname + '.swift'
	
	if os.path.exists(filename):   
   		return None
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	outputfile.write(content)

	outputfile.close();

def generate_internal_file(content, classname, class_directory):
	
	filename = class_directory + 'Internal/_'+ classname + '.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")

	fileContent = "" +  content
	outputfile.write(fileContent)
	
	outputfile.write('\n ')
	outputfile.close();

def generate_instantiator_file(content, class_directory):
	
	filename = class_directory + 'Internal/US2Instantiator.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")

	fileContent = "" +  content
	outputfile.write(fileContent)
	
	outputfile.write('\n ')
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

   try:
      opts, args = getopt.getopt(argv,"hv:i:o:t:",["version=","mapdir=","classname=","testing="])
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
   mappinglist = glob.glob(mapdir + "*.plist") 

   generate_model(mappinglist, classdir, currentVersion, testEnabled)
   
   #print 'Input file is "', inputfile
   #print 'Output file is "', outputfile

if __name__ == "__main__":
   main(sys.argv[1:])
