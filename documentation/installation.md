## JSONModelKit - Installation

### Add New Run Script Build Phase
Navigate to the application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” to add the script below. Adjust the order of the Build phases, and Move the script right below the "Target Dependencies" task. Ensure you are using the correct one for your preferred method of installation.

**Carthage && CocoaPods**

```
SCRIPT_LOC=$(find $SRCROOT -name modelgen-swift.py | head -n 1)

if [ ! -z $PODS_ROOT ]; then
	SCRIPT_LOC=$(find ${PODS_ROOT} -name modelgen-swift.py | head -n 1)
fi

python $SCRIPT_LOC -o $PROJECT_DIR
```

**Manual Installation**

```
SCRIPT_LOC=$PROJECT_DIR/Source/ModelScript/modelgen-swift.py
python $SCRIPT_LOC -o $PROJECT_DIR
```

#### CocoaPods

1. Edit the project's podfile

```
pod 'JSONModelKit', :git => 'https://github.com/AntonTheDev/JSONModelKit.git'
```
2. Install JSONModelKit by running

```
pod install
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
3. Navigate to the targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following content:

```
/usr/local/bin/carthage copy-frameworks
```

4. Add the paths to the frameworks you want to use under “Input Files” within the carthage build phase as follows e.g.:

```
$(SRCROOT)/Carthage/Build/iOS/JSONModelKit.framework
```


#### Manual Install

1. Clone the [JSONModelKit](https://github.com/AntonTheDev/JSONModelKit.git) repository, copy the Source Folder into your project's root directory, and add it to your project

2. In the application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following content:

```
	SCRIPT_LOC=$PROJECT_DIR/Source/ModelScript/modelgen-swift.py
	python $SCRIPT_LOC -o $PROJECT_DIR
```
