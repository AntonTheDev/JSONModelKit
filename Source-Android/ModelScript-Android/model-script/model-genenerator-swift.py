import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
import json
import shutil
import time

sys.dont_write_bytecode = True

from generator 	import ClassGenerator
from instantiator import InstantiatorGenerator
from validator 	import Validator
from fileimporter import ProjectFileImporter
from pbxproj import XcodeProject
#from keystroke_generator import KeystrokeGenerator

#from Quartz.CoreGraphics import CGEventCreateKeyboardEvent
#from Quartz.CoreGraphics import CGEventPost

# Python releases things automatically, using CFRelease will result in a scary error
#from Quartz.CoreGraphics import CFRelease

#from Quartz.CoreGraphics import kCGHIDEventTap

# From http://stackoverflow.com/questions/281133/controlling-the-mouse-from-python-in-os-x
# and from https://developer.apple.com/library/mac/documentation/Carbon/Reference/QuartzEventServicesRef/index.html#//apple_ref/c/func/CGEventCreateKeyboardEvent


def generate_model(plistPaths, fullOutputDirectory, version, testEnabled, jsonFormatEnabled, autoImport, instantiatorName):

	adjustedPaths = []

	for path in plistPaths:
		 if 'StyleGuide' not in path:
			 adjustedPaths.append(path)

	internal_file_names = []
	external_file_names = []

	print 'FullOutputDirectory - ' + fullOutputDirectory
	instantiatorPath = fullOutputDirectory + '/' + instantiatorName + '.kt'
	instantiatorGenerator = InstantiatorGenerator(adjustedPaths, instantiatorPath, version, testEnabled, jsonFormatEnabled, instantiatorName)

	generate_file(instantiatorGenerator.internalGeneratedClass(), instantiatorPath, True)
	internal_file_names.append(instantiatorName + '.kt')

	for mappingPath in adjustedPaths:
		classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]

		jmsdk_propertyMappings = []

		if jsonFormatEnabled == True:
			jmsdk_propertyMappings = json.load(open(mappingPath))
		else:
			jmsdk_propertyMappings = plistlib.readPlist(mappingPath)

		print fullOutputDirectory

		classGenerator = ClassGenerator(mappingPath, fullOutputDirectory, version, testEnabled, jsonFormatEnabled, instantiatorName)

		internalClassPath = fullOutputDirectory + '/'+ classname + '.kt'

		validator = Validator(classname, jmsdk_propertyMappings)
		validator.validateMapping()

		internalClass = classGenerator.internalGeneratedClass()

		internal_file_names.append(classname + '.kt')

		generate_file(internalClass, internalClassPath, True)


def getPathForFile(fileName):
	return str.replace(os.path.abspath(__file__), "modelgen-swift.py", fileName)


def generate_file(content, filePath, overwrite):
    #print filePath
    fileExists = os.path.exists(filePath)
    #if fileExists and overwrite == False:
   	#	return None

    if not os.path.exists(os.path.dirname(filePath)):
        os.makedirs(os.path.dirname(filePath))

    outputfile = open(filePath, "wba")

    fileContent = content
    outputfile.write(fileContent)
    outputfile.close();
    return fileExists


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
	autoImport = 1
	mapdir = ''
	instantiatorName = ''
	currentVersion = 1.0

	try:
		opts, args = getopt.getopt(argv,"hv:i:o:t:f:m:g:",["version=","mapdir=","classname=","testing=","format=", "import=", "instantiatorName="])
	except getopt.GetoptError:
		print 'test.py -i <inputfile> -o <outputfile>'
		sys.exit(2)

	for opt, arg in opts:
		if opt == '-h':
			print 'test.py -i <inputfile> -o <outputfile>'
			sys.exit()
		elif opt in ("-v", "--ofile"):
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
		elif opt in ("-g", "--ofile"):
			instantiatorName = arg

	rootDirectory = os.path.dirname(os.path.realpath(sys.argv[0]))
	fullOutputDirectory = rootDirectory + classdir

	if not mapdir:
		#print 'Empty Dir' + fullOutputDirectory
		mapdir = fullOutputDirectory + 'Mapping/'
		if not os.path.exists(os.path.dirname(mapdir)):
			os.makedirs(os.path.dirname(mapdir))

	if fileformat == "json":
		mappinglist = glob.glob(rootDirectory + mapdir + "/*.json")
		#print 'Mapping Directory ' + rootDirectory + mapdir
		#print 'Output Directory' + classdir
		#print 'Mapping ' + json.dumps(mappinglist).replace("\"", "\\\"")
   		generate_model(mappinglist, fullOutputDirectory, currentVersion, testEnabled, True, autoImport, instantiatorName)
	else:
   		mappinglist = glob.glob(mapdir + "*.plist")
   		generate_model(mappinglist, fullOutputDirectory, currentVersion, testEnabled, False, autoImport, instantiatorName)

if __name__ == "__main__":
   main(sys.argv[1:])
