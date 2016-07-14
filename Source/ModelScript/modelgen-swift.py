import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands
import mappingKeys

from modelgenerator import ClassGenerator

def generate_model(plistPaths, output_directory, version, testEnabled):
	
	classGenerator = ClassGenerator(plistPaths, output_directory, version, testEnabled)

	for mappingPath in plistPaths:
		
		classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]
		classPropertyMappings = plistlib.readPlist(mappingPath)

		validate_class_mapping_configuration(classname, classPropertyMappings)
		
		generate_external_file_if_needed(classname, output_directory, testEnabled)
		generate_internal_file(classGenerator.generatedClass(), classname, output_directory)
	
	#generate_internal_instantiator_file(mapping, output_directory, testEnabled)

# External Model File Generation

def generate_external_file_if_needed(classname, class_directory, testEnabled):
	
	filename = class_directory + classname + '.swift'
	
	if os.path.exists(filename):   
   		return None
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	
	if testEnabled == 1:
		print 'TEST ENABLED'
		outputfile.write(STRING_IMPORT_FOUNDATION_TEST + '\nclass ' + classname + ' : _' + classname + ' {\n\n}')
	else:
		print 'TEST DISABLED'
		outputfile.write(STRING_IMPORT_FOUNDATION + '\nclass ' + classname + ' : _' + classname + ' {\n\n}')
	
	outputfile.close();

def generate_internal_file(content, classname, class_directory):
	
	filename = class_directory + 'Internal/_'+ classname + '.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")
	outputfile.write(content)
	
	#if testEnabled is '1':
	#	print 'TEST ENABLED'
	#	outputfile.write(content)
	#else:
	#	print 'TEST DISABLED'
	#	outputfile.write(STRING_IMPORT_FOUNDATION + STRING_USMAPPER_IMPORT + '\nclass _' + classname + ' {\n')

	outputfile.close();

'''
Create External US2Mapper Inherited File
'''
def generate_internal_instantiator_file(mappingPlist, output_directory, testEnabled):
	filename = output_directory + 'Internal/US2Instantiator.swift'
	
	if not os.path.exists(os.path.dirname(filename)):
		os.makedirs(os.path.dirname(filename))
	
	outputfile = open(filename, "wba")

	if testEnabled == 1:
		outputfile.write(STRING_FILE_INTRO + STRING_IMPORT_FOUNDATION_TEST + STRING_USMAPPER_IMPORT)
	else:
		outputfile.write(STRING_FILE_INTRO + STRING_IMPORT_FOUNDATION + STRING_USMAPPER_IMPORT)
	
	classnames = []

	for mapping in mappingPlist:
		filename = mapping[mapping.rindex('/',0,-1)+1:-1] if mapping.endswith('/') else mapping[mapping.rindex('/')+1:]
		classname = filename.split('.', 1 )[0]
		classnames.append(classname)

	outputfile.write('enum US2MapperClassEnum: String {')
	
	for classname in classnames:
		outputfile.write('\n\tcase _' + classname + ' \t= "'+ classname + '"' )

	outputfile.write('\n\tcase _None\t\t\t\t= "None"')
	outputfile.write('\n\n\tfunc createObject(data : Dictionary<String, AnyObject>) -> AnyObject? {\n\t\tswitch self {')

	for classname in classnames:
		outputfile.write('\n\t\tcase ._' + classname + ':\n\t\t\treturn '+ classname + '(data)' )

	outputfile.write('\n\t\tcase ._None:\n\t\t\treturn nil' )
	
	outputfile.write('\n\t\t}\n\t}\n}\n\n')

	append_mapper_method_definitions(outputfile, mappingPlist)

	outputfile.write('\n\nclass US2Instantiator : US2InstantiatorProtocol {\n\n\tstatic let sharedInstance : US2Instantiator = US2Instantiator()\n\n\tfunc newInstance(ofType classname : String, withValue data : Dictionary<String, AnyObject>) -> AnyObject? {\n\t\treturn US2MapperClassEnum(rawValue: classname)?.createObject(data)\n\t}\n\n' )

	outputfile.write('\tfunc transformerFromString(classString: String) -> US2TransformerProtocol? {\n\t\treturn US2TransformerEnum(rawValue: classString)!.transformer()\n\t}\n}')
	outputfile.close();

def validate_class_mapping_configuration(classname, mapping):
	for propertyKey in mapping.keys():
		if mappingKeys.MappingKey not in mapping[propertyKey].keys():
			if TransformerKey not in mapping[propertyKey].keys():
				#throw_missing_type_error(classname, MAPPING_KEY_TYPE, mappingPlist[propertyKey])
				print "Missing Type"

		if mappingKeys.MappingKey not in mapping[propertyKey].keys():
			if TransformerKey not in mapping[propertyKey].keys():
				#throw_missing_json_key_error(classname, MAPPING_KEY_KEY, mappingPlist[propertyName])
				print "Missing Key"
			else:
				propertyType = mapping[propertyKey][mappingKeys.MappingKey]
				if xcode_version() == 6.0 and propertyType not in mappingKeys.NativeTypes:
					if mappingKeys.NonOptionalKey in mapping[propertyKey].keys():
						if mapping[propertyKey][mappingKeys.NonOptionalKey] == 'true':
							print "Missing Non Optional"
							#throw_missing_nonoptional_error(classname, MAPPING_KEY_KEY, mappingPlist[propertyName])

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
   
   print 'Input file is "', inputfile
   print 'Output file is "', outputfile

if __name__ == "__main__":
   main(sys.argv[1:])
