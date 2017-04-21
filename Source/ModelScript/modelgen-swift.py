import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
import json

sys.dont_write_bytecode = True

from generator 	import ClassGenerator
from instantiator import InstantiatorGenerator
from validator 	import Validator
from fileimporter import ProjectFileImporter
from pbxproj import XcodeProject

def generate_model(plistPaths, output_directory, version, testEnabled, jsonFormatEnabled, autoImport):
	
	fileschanged = False

	the_dir = output_directory
	projectName = ''
	all_txt_files = filter(lambda x: x.endswith('.xcodeproj'), os.listdir(the_dir))
	for file in all_txt_files:
		projectName = file.partition('.')[0]
		the_dir = the_dir + file + '/project.pbxproj'
		print(the_dir)

	print('Project Name ' + projectName + ' Directory ' + the_dir)
	project = XcodeProject.load(the_dir)
	parentGroup = project.get_or_create_group(projectName)
	group = project.get_or_create_group('Model', parent=parentGroup)
	internal_group = project.get_or_create_group('Internal', parent=group)

	fullOutputDirectory = output_directory + projectName + '/Model/'

	instantiatorPath = fullOutputDirectory + 'Internal/JMInstantiator.swift'
	instantiatorGenerator = InstantiatorGenerator(plistPaths, instantiatorPath, version, testEnabled, jsonFormatEnabled)
	
	generate_file(instantiatorGenerator.internalGeneratedClass(), instantiatorPath, True)
	project.add_file(instantiatorPath, parent=internal_group, force=False)
		
	for mappingPath in plistPaths:
		classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]
		
		propertyMappings = []
         
		if jsonFormatEnabled == True:
			propertyMappings = json.load(open(mappingPath))
		else: 
			propertyMappings = plistlib.readPlist(mappingPath)

		classGenerator = ClassGenerator(mappingPath, fullOutputDirectory, version, testEnabled, jsonFormatEnabled)
		
		internalClassPath = fullOutputDirectory + 'Internal/_'+ classname + '.swift'
		externalClassPath = fullOutputDirectory +  classname + '.swift'
		
		validator = Validator(classname, propertyMappings)
		validator.validateMapping()

		internalClass = classGenerator.internalGeneratedClass()
		externalClass= classGenerator.externalGeneratedClass()
		
		i_files = project.get_files_by_name('_' + classname + '.swift')
		e_files = project.get_files_by_name(classname + '.swift')

		generate_file(internalClass, internalClassPath, True)
		generate_file(externalClass, externalClassPath, False)

		if len(i_files) == 0:
			fileschanged = True
			project.add_file(internalClassPath, parent=internal_group, force=False)
		if len(e_files) == 0:
			fileschanged = True
			project.add_file(externalClassPath, parent=group, force=False)

		print 'Internal Class Path "', internalClassPath
		print 'External Class Path "', externalClassPath
	
	if fileschanged:
		project.save()


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
   autoImport = 0

   try:
      opts, args = getopt.getopt(argv,"hv:i:o:t:f:m:",["version=","mapdir=","classname=","testing=","format=", "import="])
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
      elif opt in ("-m", "--ofile"):
         autoImport = arg

   if fileformat == "json":
   	   	mappinglist = glob.glob(mapdir + "*.json") 
   		generate_model(mappinglist, classdir, currentVersion, testEnabled, True, autoImport)
   else:
   		mappinglist = glob.glob(mapdir + "*.plist") 
   		generate_model(mappinglist, classdir, currentVersion, testEnabled, False, autoImport)
 
   #print 'Input file is "', inputfile
   #print 'Output file is "', outputfile

if __name__ == "__main__":
   main(sys.argv[1:])
