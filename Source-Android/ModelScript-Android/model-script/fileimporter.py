#!/usr/bin/python
from pbxproj import XcodeProject

class ProjectFileImporter:

   def __init__(self, mappingPath, output_directory, version, testEnabled, jsonFormatEnabled):
		self.mappingPath = mappingPath
		self.output_directory = output_directory
		self.version = version
		self.testEnabled = testEnabled
		self.jsonFormatEnabled = jsonFormatEnabled

   def importmodelfiles():
   		instantiatorPath = output_directory + 'Internal/JMInstantiator.swift'
		instantiatorGenerator = InstantiatorGenerator(plistPaths, output_directory, version, testEnabled, jsonFormatEnabled)

		generate_file(instantiatorGenerator.internalGeneratedClass(), instantiatorPath, True)

        # open the project
		project = XcodeProject.load('myapp.xcodeproj/project.pbxproj')

		for mappingPath in plistPaths:
			classname = mappingPath[mappingPath.rindex('/',0,-1)+1:-1] if mappingPath.endswith('/') else mappingPath[mappingPath.rindex('/')+1:].split('.', 1 )[0]

			classGenerator = ClassGenerator(mappingPath, output_directory, version, testEnabled, jsonFormatEnabled)

			internalClassPath = output_directory + 'Internal/_'+ classname + '.swift'
			externalClassPath = output_directory + classname + '.swift'

			# add a file to it, force=false to not add it if it's already in the project
			#project.add_file(internalClassPath, force=False)
			#project.add_file(externalClassPath, force=False)
			#save the project, otherwise your changes won't be picked up by Xcode

		#project.save()
