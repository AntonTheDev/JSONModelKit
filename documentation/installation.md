## JSONModelKit - Installation

#### CocoaPods

1. Edit the project's podfile

```
pod 'JSONModelKit', :git => 'https://github.com/AntonTheDev/JSONModelKit.git' 
```
2. Install JSONModelKit by running

```
pod install
```
3. Navigate to the application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” to add the script below. Adjust the order of the Build phases, and Move the script right below the "Target Dependencies" task.

	NOTE: The script below differs for installation via Carthage
```	
SCRIPT_LOCATION=$(find ${PODS_ROOT} -name modelgen-swift.py | head -n 1)
PROJ_DIR=$PROJECT_DIR/$PROJECT_NAME/JSONModel
MAPPING_DIR=$PROJ_DIR/Mappings/
MODEL_DIR=$PROJ_DIR/Model/
python $SCRIPT_LOCATION -v 0.1 -i $MAPPING_DIR -o $MODEL_DIR
```
	
#### Carthage

The installation instruction below are a for OSX and iOS, follow the extra steps documented when installing for iOS.

##### Installation

1. Create/Update the Cartfile with with the following
	
```
#JSONModelKit
git "https://github.com/AntonTheDev/JSONModelKit.git"
```
2. Run the update, and fetch dependencies into a [Carthage/Checkouts][] folder, then in the application targets’ “General” settings tab, within the “Embedded Binaries” section, drag and drop each framework for use from the Carthage/Build folder on disk.
	
```
$ carthage update
```

3. Navigate to the application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” to add the script below. Adjust the order of the Build phases, and Move the script right below the "Target Dependencies" task.

**NOTE**: The script below differs for installation via Cocoapods
```
SCRIPT_LOCATION=$(find $SRCROOT -name modelgen-swift.py | head -n 1)
PROJ_DIR=$PROJECT_DIR/$PROJECT_NAME/JSONModel
MAPPING_DIR=$PROJ_DIR/Mappings/
MODEL_DIR=$PROJ_DIR/Model/
python $SCRIPT_LOCATION -v 0.8 -i $MAPPING_DIR -o $MODEL_DIR
```


##### iOS Installation

1. Follow the installation instruction above. Once complete, perform the following steps
(If you have setup a carthage build task for iOS already skip to Step 3) 
2. Navigate to the targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following content:

```
/usr/local/bin/carthage copy-frameworks
```
  	
3. Add the paths to the frameworks you want to use under “Input Files” within the carthage build phase as follows e.g.:

```
$(SRCROOT)/Carthage/Build/iOS/JSONModelKit.framework	
```
  	
  	
#### Manual Install

1. Clone the [JSONModelKit](https://github.com/AntonTheDev/JSONModelKit.git) repository 
2. Add the contents of the Source Directory to the project
3. In the Project's Root Folder create a new folder that will contain all the mapping plist files
4. In the application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following content:
	
``` 
	TBD

```
	
4. Move the newly created Run Script phase to the second listing right below the "Target Dependencies" task


