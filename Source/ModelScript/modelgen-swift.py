import plistlib
import os
import sys
import getopt
import dircache
import glob
import commands

NativeTypes 		= ["String", "Double", "Float", "Int", "Bool"]
ArrayType			= "Array"
DictionaryType		= "Dictionary"
CollectionTypes 	= [ArrayType, DictionaryType]

Templates			= {"optionals" : "var propertyname : datatype ?", "non-optionals" : "var propertyname : datatype "}

DataTypeKey 		= "type"
DefaultValueKey 	= "default"
MappingKey 			= "key"
NonOptionalKey 		= "nonoptional"
TransformerKey		= "transformer"
SubTypeKey			= "collection_subtype"

def generate_model(plistPaths, output_directory, version, testEnabled):
	
	templatePath = os.getcwd() + "/../../Source/ModelScript/internal_class_template.txt"
	
	templates = {}
	templates["optionals"] = "var propertyname : datatype ?"
	templates["non-optionals"] = "var propertyname : datatype"
	
	newstring = open(templatePath, 'r').read()
	newstring = str.replace(newstring, '\n', '\r\n')	
	
	for mappingPath in plistPaths:
		classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]
		
		propertyMappings = plistlib.readPlist(mappingPath)
		
		validate_class_mapping_configuration(classname, propertyMappings)
		
		fileString = str.replace(newstring,  "{ CLASSNAME }", 						classname)	
		fileString = str.replace(fileString, "{ OPTIONALS }", 						optional_property_definitions(propertyMappings))	
		fileString = str.replace(fileString, "{ NONOPTIONALS }", 					non_optional_property_definitions(propertyMappings))
		fileString = str.replace(fileString, "{ REQUIRED_INIT_PARAMS }", 			required_init_properties_string(propertyMappings))
		fileString = str.replace(fileString, "{ REQUIRED_INIT_SETTERS }", 			required_init_properties_setters_string(propertyMappings))
		fileString = str.replace(fileString, "{ FAILABLE_INIT_TEMP_NONOPTIONALS }", init_temp_non_optionals(propertyMappings))
		fileString = str.replace(fileString, "{ SELF_NONOPTIONALS_INIT }", 			non_optional_self_init_parameters(propertyMappings))
		fileString = str.replace(fileString, "{ OPTIONALS_UNWRAP }",				unwrap_optional_parameters(propertyMappings))
		fileString = str.replace(fileString, "{ NONOPTIONALS_UNWRAP }", 			unwrap_non_optional_parameters(propertyMappings))

		generate_external_file_if_needed(classname, output_directory, testEnabled)
		generate_internal_file(fileString, classname, output_directory)
	
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



def optional_property_definitions(propertyMappings):
	valueTemplate 			= "var propertyname : datatype?"
	arrayTemplate 			= "var propertyname : [datatype]?"
	dictionatyTemplate 		= "var propertyname : [String : datatype]?"
	
	templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
	filteredMappings = filtered_mappings(propertyMappings, True)
	return generate_template_string(filteredMappings, templateArray, True, "\t", "\r\n    " )	

def non_optional_property_definitions(propertyMappings):
	valueTemplate 			= "var propertyname : datatype"
	arrayTemplate 			= "var propertyname : [datatype]"
	dictionatyTemplate 		= "var propertyname : [String : datatype]"
	
	templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
	filteredMappings = filtered_mappings(propertyMappings, False)

	if len(filteredMappings) == 0 :
		return ""

	return "\r\n" +  generate_template_string(filteredMappings, templateArray, False, "\t", "\r\n    " )	

def required_init_properties_string(propertyMappings):
	valueTemplate 		= "propertyname  _propertyname : datatype"
	arrayTemplate 		= "propertyname  _propertyname : [datatype]"
	dictionatyTemplate 	= "propertyname  _propertyname : [String : datatype]"
	
	templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
	filteredMappings = filtered_mappings(propertyMappings, False)
	return generate_template_string(filteredMappings, templateArray, True, "\t\t\t    ", ",\r\n    " )	

def required_init_properties_setters_string(propertyMappings):
	nonOptionalValueTemplate 		= "propertyname = _propertyname"
	
	templateArray = [nonOptionalValueTemplate, nonOptionalValueTemplate, nonOptionalValueTemplate]
	filteredMappings = filtered_mappings(propertyMappings, False)
	
	if len(filteredMappings) == 0 :
		return ""
	
	return "\r\n" + generate_template_string(filteredMappings, templateArray, False,  "\t\t\t\t\t", "\r\n    " )

def init_temp_non_optionals(propertyMappings):
	valueTemplate 		= "let temp_propertyname : datatype = typeCast(valuesDict[\"propertyname\"])!"
	arrayTemplate 		= "let temp_propertyname : [datatype] = typeCast(valuesDict[\"propertyname\"])!"
	dictionatyTemplate 	= "let temp_propertyname : [String : datatype] = typeCast(valuesDict[\"propertyname\"])!"
	
	templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
	filteredMappings = filtered_mappings(propertyMappings, False)
	
	if len(filteredMappings) == 0 :
		return ""

	return "\r\n\t\t\t" + generate_template_string(filteredMappings, templateArray, True, "\t\t", "\r\n    " )	

def non_optional_self_init_parameters(propertyMappings):
	valueTemplate 		= "propertyname : temp_propertyname"

	templateArray = [valueTemplate, valueTemplate, valueTemplate]
	filteredMappings = filtered_mappings(propertyMappings, False)
	return generate_template_string(filteredMappings, templateArray, True, "\t\t\t\t     ", "\r\n    " )	

def non_optional_self_init_parameters(propertyMappings):
	valueTemplate 		= "propertyname : temp_propertyname"

	templateArray = [valueTemplate, valueTemplate, valueTemplate]
	filteredMappings = filtered_mappings(propertyMappings, False)
	return generate_template_string(filteredMappings, templateArray, True, "\t\t\t      ", ",\r\n    " )	

def unwrap_optional_parameters(propertyMappings):
	valueTemplate 		= "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"
	arrayTemplate 		= "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"
	dictionatyTemplate 	= "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"

	templateArray = [valueTemplate, arrayTemplate, dictionatyTemplate]
	filteredMappings = filtered_mappings(propertyMappings, True)
	return generate_template_string(filteredMappings, templateArray, True, "\t\t\t", "\r\n    " )	

def unwrap_non_optional_parameters(propertyMappings):
	valueTemplate 	= "if let unwrapped_propertyname : Any = valuesDict[\"propertyname\"]  { \r\n\t\t\t\tpropertyname = typeCast(unwrapped_propertyname)! \r\n\t\t\t}\r\n"

	templateArray = [valueTemplate, valueTemplate, valueTemplate]
	filteredMappings = filtered_mappings(propertyMappings, False)

	return generate_template_string(filteredMappings, templateArray, True, "\t\t\t", "\r\n    " )	

def generate_template_string(propertyMappings, templateArray, skipInitialIndentation, indentation, carriageString):

	if len(propertyMappings) == 0 :
		return ""

	propertyString = ""

	for propertyKey in propertyMappings.keys():
		
		propertyMapping = propertyMappings[propertyKey]
		propertyType = propertyMapping[DataTypeKey]
		isMappingOptional = is_property_mapping_optional(propertyMapping)
		
		templateValues = {}
		templateValues["propertyname"] = propertyKey
		templateValues["datatype"] = propertyType
		
		if skipInitialIndentation == False or propertyString != "":
			propertyString += indentation

		if propertyType in NativeTypes: 
			propertyString += dictionaryValueString(templateArray[0], templateValues)

		elif propertyType in CollectionTypes:
			templateValues["datatype"] = propertyMapping[SubTypeKey]
				
			if propertyType == ArrayType:
				propertyString += dictionaryValueString(templateArray[1], templateValues)

			elif propertyType == DictionaryType:
				propertyString += dictionaryValueString(templateArray[2], templateValues)
		
		else:
			propertyString += dictionaryValueString(templateArray[0], templateValues)

		if propertyMappings.keys().index(propertyKey) <= len(propertyMappings.keys()) - 2:
			propertyString += carriageString
		else:
			propertyString += ""
			
	return propertyString


def filtered_mappings(propertyMappings, optional):
	filteredMappings = {}

	for propertyKey in propertyMappings.keys():
		
		propertyMapping = propertyMappings[propertyKey]
		
		if is_property_mapping_optional(propertyMapping) == optional:
			filteredMappings[propertyKey] = propertyMapping

	return filteredMappings

def is_property_mapping_optional(mapping):
	if NonOptionalKey not in mapping.keys():
		return True
	elif mapping[NonOptionalKey] == 'true':
		return False

	return True

def dictionaryValueString(templateString, dictionaryValues):
	renderedString = templateString	

	for key in dictionaryValues.keys():
		renderedString = str.replace(renderedString, key, dictionaryValues[key])

	return renderedString


def validate_class_mapping_configuration(classname, mapping):
	for propertyKey in mapping.keys():
		if MappingKey not in mapping[propertyKey].keys():
			if TransformerKey not in mapping[propertyKey].keys():
				#throw_missing_type_error(classname, MAPPING_KEY_TYPE, mappingPlist[propertyKey])
				print "Missing Type"

		if MappingKey not in mapping[propertyKey].keys():
			if TransformerKey not in mapping[propertyKey].keys():
				#throw_missing_json_key_error(classname, MAPPING_KEY_KEY, mappingPlist[propertyName])
				print "Missing Key"
			else:
				propertyType = mapping[propertyKey][MappingKey]
				if xcode_version() == 6.0 and propertyType not in NativeTypes:
					if NonOptionalKey in mapping[propertyKey].keys():
						if mapping[propertyKey][NonOptionalKey] == 'true':
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
