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

def generate_model(plistPaths, fullOutputDirectory, version, testEnabled, jsonFormatEnabled, autoImport):

	internal_file_names = []
	external_file_names = []

	print fullOutputDirectory

	instantiatorPath = fullOutputDirectory + 'Model/JMInstantiator.swift'
	instantiatorGenerator = InstantiatorGenerator(plistPaths, instantiatorPath, version, testEnabled, jsonFormatEnabled)

	generate_file(instantiatorGenerator.internalGeneratedClass(), instantiatorPath, True)
	internal_file_names.append('JMInstantiator.swift')

	for mappingPath in plistPaths:
		classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]

		jmsdk_propertyMappings = []

		if jsonFormatEnabled == True:
			jmsdk_propertyMappings = json.load(open(mappingPath))
		else:
			jmsdk_propertyMappings = plistlib.readPlist(mappingPath)

		print fullOutputDirectory

		classGenerator = ClassGenerator(mappingPath, fullOutputDirectory, version, testEnabled, jsonFormatEnabled)

		internalClassPath = fullOutputDirectory + 'Model/'+ classname + '.swift'

		validator = Validator(classname, jmsdk_propertyMappings)
		validator.validateMapping()

		internalClass = classGenerator.internalGeneratedClass()

		internal_file_names.append(classname + '.swift')

		generate_file(internalClass, internalClassPath, True)


def save_files_to_project(project_directory, internal_file_names, external_file_names):

	fileschanged = False
	projectName = ''
	searchDirectory = project_directory + '/../'
	for filepath in filter(lambda x: x.endswith('.xcodeproj'), os.listdir(searchDirectory)):
		projectName = filepath.partition('.')[0]

	project_file_path = project_directory +'../' + projectName + '.xcodeproj'
	backup_project_path = project_file_path + '-backup'

	print '1 - ' + project_directory
	print '2 - ' + project_file_path

	if os.path.exists(os.path.dirname(backup_project_path + '/')):
		shutil.rmtree(backup_project_path + '/')

	shutil.copytree(project_file_path, backup_project_path)

	project = XcodeProject.load(project_file_path + '/project.pbxproj')
	#backup_file = project.backup()

	parent_group = project.get_or_create_group(projectName)
	model_group = project.get_or_create_group('Model', parent=parent_group)
	mapping_group = project.get_or_create_group('Mapping', parent=model_group)
	internal_group = project.get_or_create_group('Internal', parent=model_group)

	#print('Project Name ' + projectName + ' Path ' + project_file_path)
	#print 'Backup File Name ' + backup_file

	for internal_name in internal_file_names:
		found_files = project.get_files_by_name(internal_name)
		if len(found_files) == 0:
			fileschanged = True
			internal_path = project_directory + '/Model/' + internal_name
			print '3 - ' + internal_path
			project.add_file(internal_path, parent=internal_group, force=False)

	for external_name in external_file_names:
		found_files = project.get_files_by_name(external_name)

		if len(found_files) == 0:
			fileschanged = True
			external_path = project_directory + '/Model/' + external_name
			print '4 - ' + external_path
			project.add_file(external_path, parent=model_group, force=False)

	if fileschanged:
		try:
			print('PROJECT SAVED')
			project.save()
		except:
			print('FAILED PROJECT SAVE')
		else:
			os.remove(backup_file)

def getPathForFile(fileName):
	return str.replace(os.path.abspath(__file__), "modelgen-swift.py", fileName)


def generate_file(content, filePath, overwrite):
    print filePath
    fileExists = os.path.exists(filePath)
    if fileExists and overwrite == False:
   		return None

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
	currentVersion = 1.0

	try:
		opts, args = getopt.getopt(argv,"hv:i:o:t:f:m:",["version=","mapdir=","classname=","testing=","format=", "import="])
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


	projectName = ''
	all_txt_files = filter(lambda x: x.endswith('.xcodeproj'), os.listdir(classdir))
	for file in all_txt_files:
		projectName = file.partition('.')[0]

	fullOutputDirectory = classdir + '/'

	if not mapdir:
		print 'Empty Dir' + fullOutputDirectory
		mapdir = fullOutputDirectory + 'Model/Mapping/'
		if not os.path.exists(os.path.dirname(mapdir)):
			os.makedirs(os.path.dirname(mapdir))

	if fileformat == "json":
		mappinglist = glob.glob(mapdir + "*.json")
   		generate_model(mappinglist, fullOutputDirectory, currentVersion, testEnabled, True, autoImport)
	else:
   		mappinglist = glob.glob(mapdir + "*.plist")
   		generate_model(mappinglist, fullOutputDirectory, currentVersion, testEnabled, False, autoImport)

if __name__ == "__main__":
   main(sys.argv[1:])
