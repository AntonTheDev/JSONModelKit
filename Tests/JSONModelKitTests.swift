//
//  JMMapper2iOSScenarioTests.swift
//  JMMapper2
//
//  Created by Anton Doudarev on 7/8/15.
//  Copyright © 2015 ustwo. All rights reserved.
//

import XCTest

#if TARGET_OS_IPHONE
    import UIKit
    #else
    // OSX code
#endif

class JSONModelKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        #if JMMAPPER_FORMAT_PLIST
            JMConfig.fileFormat = .plist
        #else
            JMConfig.fileFormat = .json
        #endif
    }
    
    /**
     *  TestObjectOne is completely missing a mapping file
     **/
    func testMissingConfiguration() {
        
        let testObject = TestObjectOne([String : AnyObject]())
       
        XCTAssertNil(testObject, "Failable initializer should have returned nil")
    }
    
    /**
     *  TestObjectTwo does not have default values defined for non-optional values
     **/
    func testFailableInitializer() {
        
        let testObject = TestObjectTwo([String : AnyObject]())
        
        XCTAssertNil(testObject, "Failable initializer should have returned nil")
    }
    
    /**
     *  TestObjectThree has all the default values defined
     **/
    func testDefaultMapping() {
        
        let testObject = TestObjectThree([String : AnyObject]())
        
        XCTAssertEqual(testObject!.optionalString!, "Hello",        "Optional String Value should default to 'Hello'")
        XCTAssertEqual(testObject!.optionalInt!, Int(10),           "Optional Int value should default to 10")
        XCTAssertEqual(testObject!.optionalDouble!, Double(20.0),   "Optional Double value should default to 20.0")
        XCTAssertEqual(testObject!.optionalFloat!, Float(30.0),     "Optional Float value should default to 30.0")
        XCTAssertEqual(testObject!.optionalBool!, true,             "Optional Bool value should default to true")
        
        XCTAssertEqual(testObject!.non_optionalString, "Non-Optional Hello",    "Non-Optional String Value should default to 'Non-Optional Hello'")
        XCTAssertEqual(testObject!.non_optionalInt, Int(40),                    "Non-Optional Int value should be 0.0")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(50.0),            "Non-Optional Double value should be 0.0")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(60.0),              "Non-Optional Float value should be 0.0")
        XCTAssertEqual(testObject!.non_optionalBool, false,                     "Non-Optional Bool value should be false")
    }
    
    /**
     *  TestObjectFour has defaults only for non-optional values the optional values should all be nil
     **/
    func testBasicMappingForDictionaryWithoutOptionalValues() {
        
        let testObject = TestObjectFour([String : AnyObject]())
        
        XCTAssertNil(testObject!.optionalInt,       "Optional Int Value should be nil")
        XCTAssertNil(testObject!.optionalString,    "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalDouble,    "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalFloat,     "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalBool,      "Optional String Value should be nil")
        
        XCTAssertEqual(testObject!.non_optionalInt, Int(500),                   "Non-Optional Int does not equal the defined default value")
        XCTAssertEqual(testObject!.non_optionalString, "Non-Optional Hello",    "Non-Optional String value does not equal the defined default value")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(50.0),            "Non-Optional Double value does not equal the defined default value")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(60.0),              "Non-Optional Float value does not equal the defined default value")
        XCTAssertEqual(testObject!.non_optionalBool, true,                      "Non-Optional Bool value does not equal the defined default value")
    }
    
    /**
     *  TestObjectFive has defaults only for non-optional values the optional values should all be nil
     *  All while the non optional values will be overriden to a value not set to a default
     **/
    func testBasicMappingForDictionaryWithNonOptionalValues() {

        let dictionary = ["non_optional_int"    : 50,
                          "non_optional_string" : "TestString",
                          "non_optional_double" : 70.0,
                          "non_optional_float"  : 80.0,
                          "non_optional_bool"   : false] as [String : AnyObject]
        
        let testObject = TestObjectFour(dictionary)
        
        XCTAssertNil(testObject!.optionalInt,       "Optional Int Value should be nil")
        XCTAssertNil(testObject!.optionalString,    "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalDouble,    "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalFloat,     "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalBool,      "Optional String Value should be nil")
        
        XCTAssertEqual(testObject!.non_optionalInt, Int(50),            "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalString, "TestString",    "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(70.0),    "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(80.0),      "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalBool, false,             "Non-Optional Bool value was parsed incorrectly")
    }
    
    /**
     *  TestObjectFour has defaults only for non-optional values the optional values should all be nil
     **/
    func testNumericValueReturnedAsStrings() {
        
        let dictionary = ["non_optional_int"    : "50",
                          "non_optional_double" : "70.0",
                          "non_optional_float"  : "80.0"] as [String : AnyObject]
        
        let testObject = TestObjectFour(dictionary)
        
        XCTAssertEqual(testObject!.non_optionalInt, Int(50),            "Non-Optional Int was parsed incorrectly from a String value")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(70.0),    "Non-Optional Double was parsed incorrectly from a String value")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(80.0),      "Non-Optional Float value was parsed incorrectly from a String value")
    }
    
    /**
     *  TestObjectFour has default set to true for the non_optionalBool property
     *  This is a test to ensure that all the different iterations of false are indeed false
     **/
    func testBoolFalseMapping() {

        let testBoolInstance            = TestObjectFour(["non_optional_bool" : false] as [String : AnyObject])
        let testStringZeroInstance      = TestObjectFour(["non_optional_bool" : "0"] as [String : AnyObject])
        let testStringFalseInstance     = TestObjectFour(["non_optional_bool" : "false"] as [String : AnyObject])
        let testStringFalseCapsInstance = TestObjectFour(["non_optional_bool" : "FALSE"] as [String : AnyObject])
        
        XCTAssertFalse(testBoolInstance!.non_optionalBool,               "Non-Optional Bool value should be false (default is true)")
        XCTAssertFalse(testStringZeroInstance!.non_optionalBool,         "Non-Optional Bool value should be false (default is true)")
        XCTAssertFalse(testStringFalseInstance!.non_optionalBool,        "Non-Optional Bool value should be false (default is true)")
        XCTAssertFalse(testStringFalseCapsInstance!.non_optionalBool,    "Non-Optional Bool value should be false (default is true)")
    }
    
    /**
     *  TestObjectThree has default set to false for the non_optionalBool property
     *  This is a test to ensure that all the different iterations of true are indeed true
     **/
    func testBoolTrueMapping() {
        
        let testBoolInstance            = TestObjectThree(["non_optional_bool" : true] as [String : AnyObject])
        let testStringOneInstance       = TestObjectThree(["non_optional_bool" : "1"] as [String : AnyObject])
        let testStringTrueInstance      = TestObjectThree( ["non_optional_bool" : "true"] as [String : AnyObject])
        let testStringTrueCapsInstance  = TestObjectThree(["non_optional_bool" : "TRUE"] as [String : AnyObject])
        
        XCTAssertTrue(testBoolInstance!.non_optionalBool,           "Non-Optional Bool value should be true (default is false)")
        XCTAssertTrue(testStringOneInstance!.non_optionalBool,      "Non-Optional Bool value should be true (default is false)")
        XCTAssertTrue(testStringTrueInstance!.non_optionalBool,     "Non-Optional Bool value should be true (default is false)")
        XCTAssertTrue(testStringTrueCapsInstance!.non_optionalBool, "Non-Optional Bool value should be true (default is false)")
    }
    
    /**
     *  TestObjectThree has default set to true for the non_optionalBool property
     **/
    func testNumericStringMapping() {
    
        let numericStringInstance = TestObjectThree(["non_optional_string" : 70.0] as [String : AnyObject])
        
        XCTAssertEqual(numericStringInstance!.non_optionalString, "70.0", "Non-Optional String value was not parsed correctly from a numeric value")
    }
    
    /**
     *  TestObjectFive contains an instance of a non-optional TestObjectThree, 
     *  this test ensures the sutype is mapped correctly
     **/
    func testSubTypeMapping() {
        
        let subtypeDictionary = ["non_optional_int"     : 50,
                                 "non_optional_string"  : "TestString",
                                 "non_optional_double"  : 70.0,
                                 "non_optional_float"   : 80.0,
                                 "non_optional_bool"    : false] as [String : Any]
        
        let dictionaryBoolValue = ["optional_subtype"       : subtypeDictionary,
                                   "non_optional_subtype"   : subtypeDictionary] as [String : AnyObject]
        
        let testObject = TestObjectFive(dictionaryBoolValue)
        
        XCTAssertEqual(testObject!.optionalSubType!.non_optionalInt, Int(50),               "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalSubType!.non_optionalString, "TestString",       "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalSubType!.non_optionalDouble, Double(70.0),       "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalSubType!.non_optionalFloat, Float(80.0),         "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalSubType!.non_optionalBool, false,                "Non-Optional Bool value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalSubType.non_optionalInt, Int(50),            "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalSubType.non_optionalString, "TestString",    "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalSubType.non_optionalDouble, Double(70.0),    "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalSubType.non_optionalFloat, Float(80.0),      "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalSubType.non_optionalBool, false,             "Non-Optional Bool value was parsed incorrectly")
    }
    
    /**
     * TestObjectFive contains an instance of a non-optional TestObjectThree, the data
     * for TestObjectThree ensure is missing a non-opnal value, should return nil
     **/
    func testFailableWithComplexTypesInitializer() {
        
        let subtypeDictionary = ["non_optional_int"     : 50,
                                 "non_optional_string"  : "TestString",
                                 "non_optional_double"  : 70.0,
                                 "non_optional_float"   : 80.0,
                                 "non_optional_bool"    : false] as [String : AnyObject]
        
        let dictionaryBoolValue = ["optional_subtype" : subtypeDictionary] as [String : AnyObject]

        let testObject = TestObjectFive(dictionaryBoolValue)
        
        XCTAssertNil(testObject, "Failable initializer should have returned nil, non-optinal values are missing")
    }
    
    /**
     *  TestObjectSix should have compound values mapped for the optinal and non optional values
     **/
    func testCompoundValueMapper() {
        
        let dataDictionary = ["left_hand_string"  : "Left-String-",
                              "right_hand_string" : "Right-String",
                              "non_optional_left_hand_string"  : "NONOP-Left-String-",
                              "non_optional_right_hand_string" : "NONOP-Right-String"] as [String : AnyObject]
        
        let testObject = TestObjectSix(dataDictionary)
        print(testObject!.non_optionalCompoundString)
        XCTAssertEqual(testObject!.optionalCompoundString!, "Left-String-Right-String",                 "Compount Value Mapper returned incorrect Value")
        XCTAssertEqual(testObject!.non_optionalCompoundString, "NONOP-Left-String-NONOP-Right-String",  "Compount Value Mapper returned incorrect Value")
    }
  
    /**
     *  TestObjectSix should fail since the non_optionalCompoundString will return nil
     **/
    func testCompoundValueMapperFailableInitializer() {
        
        let dataDictionary = ["left_hand_string" : "Left-String-",
                              "right_hand_string" : "Right-String"] as [String : AnyObject]
        
        let testObject = TestObjectSix(dataDictionary)
        
        XCTAssertNil(testObject, "Failable initializer should have returned nil, non-optinal values are missing")
    }

    /**
     *  TestObjectSeven has an array of TestObjectFour(s) and is passed an array
     **/
    func testArrayComplexSubtypeMapping() {
    
        let object1Dictionary = ["non_optional_int"     : 50,
                                 "non_optional_string"  : "TestString1",
                                 "non_optional_double"  : 60.0,
                                 "non_optional_float"   : 70.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let object2Dictionary = ["non_optional_int"     : 80,
                                 "non_optional_string"  : "TestString2",
                                 "non_optional_double"  : 90.0,
                                 "non_optional_float"   : 100.0,
                                 "non_optional_bool"    : false] as [String : Any]
        
        let object3Dictionary = ["non_optional_int"     : 110,
                                 "non_optional_string"  : "TestString3",
                                 "non_optional_double"  : 120.0,
                                 "non_optional_float"   : 130.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let testObjectArray = [object1Dictionary, object2Dictionary]
       
        let dataDictionary = ["optional_sub_object_array" : testObjectArray,
                              "non_optional_sub_object_array" : [object3Dictionary]] as [String : AnyObject]
        
        let testObject = TestObjectSeven(dataDictionary)
        
        XCTAssertEqual(testObject!.optionalArrayType![0].non_optionalInt, Int(50),          "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalArrayType![0].non_optionalDouble, Double(60.0),  "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalArrayType![0].non_optionalFloat, Float(70.0),    "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalArrayType![0].non_optionalString, "TestString1", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalArrayType![0].non_optionalBool, true,            "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObject!.optionalArrayType![1].non_optionalInt, Int(80),          "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalArrayType![1].non_optionalDouble, Double(90.0),  "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalArrayType![1].non_optionalFloat, Float(100.0),   "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalArrayType![1].non_optionalString, "TestString2", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalArrayType![1].non_optionalBool, false,           "Non-Optional Bool value was parsed incorrectly")
        
        
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalInt, Int(110),          "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalDouble, Double(120.0),  "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalFloat, Float(130.0),    "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalString, "TestString3",  "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalBool, true,             "Non-Optional Bool value was parsed incorrectly")
    }
 
    /**
     *  TestObjectSeven has an array of TestObjectFour(s), but is passed a dictionary
     **/
    func testArrayComplexSubtypeReturnedAsDictionaryMapping() {

        let object1Dictionary = ["non_optional_int"     : 50,
                                 "non_optional_string"  : "TestString1",
                                 "non_optional_double"  : 60.0,
                                 "non_optional_float"   : 70.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let object2Dictionary = ["non_optional_int"     : 80,
                                 "non_optional_string"  : "TestString2",
                                 "non_optional_double"  : 90.0,
                                 "non_optional_float"   : 100.0,
                                 "non_optional_bool"    : false] as [String : Any]
        
        let object3Dictionary = ["non_optional_int"     : 110,
                                 "non_optional_string"  : "TestString3",
                                 "non_optional_double"  : 120.0,
                                 "non_optional_float"   : 130.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let testObjectDictionary = ["1" : object2Dictionary,
                                    "2" : object1Dictionary]
        
        let testObjectDictionary2 = ["1" : object3Dictionary]
        
        let dataDictionary = ["optional_sub_object_array" : testObjectDictionary,
                              "non_optional_sub_object_array" : testObjectDictionary2] as [String : AnyObject]
        
        let testObject = TestObjectSeven(dataDictionary)
        
        if let testObject1 = testObject?.optionalArrayType![0],
           let testObject2 = testObject?.optionalArrayType![1]
        {
            let _test1Object = testObject1.non_optionalString == "TestString1" ? testObject1 : testObject2
            let _test2Object = testObject2.non_optionalString != "TestString2" ? testObject1 : testObject2
            
            XCTAssertEqual(_test1Object.non_optionalInt, Int(50),              "Non-Optional Int value was parsed incorrectly - \(_test1Object.non_optionalInt)")
            XCTAssertEqual(_test1Object.non_optionalDouble, Double(60.0),      "Non-Optional Double value was parsed incorrectly - \(_test1Object.non_optionalDouble)")
            XCTAssertEqual(_test1Object.non_optionalFloat, Float(70.0),        "Non-Optional Float value was parsed incorrectly - \(_test1Object.non_optionalFloat)")
            XCTAssertEqual(_test1Object.non_optionalString, "TestString1",     "Non-Optional String value was parsed incorrectly - \(_test1Object.non_optionalString)")
            XCTAssertEqual(_test1Object.non_optionalBool, true,                "Non-Optional Bool value was parsed incorrectly - \(_test1Object.non_optionalBool)")
            
            XCTAssertEqual(_test2Object.non_optionalInt, Int(80),              "Non-Optional Int value was parsed incorrectly")
            XCTAssertEqual(_test2Object.non_optionalDouble, Double(90.0),      "Non-Optional Double value was parsed incorrectly")
            XCTAssertEqual(_test2Object.non_optionalFloat, Float(100.0),       "Non-Optional Float value was parsed incorrectly")
            XCTAssertEqual(_test2Object.non_optionalString, "TestString2",     "Non-Optional String value was parsed incorrectly")
            XCTAssertEqual(_test2Object.non_optionalBool, false,               "Non-Optional Bool value was parsed incorrectly")
        }

        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalInt, Int(110),          "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalDouble, Double(120.0),  "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalFloat, Float(130.0),    "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalString, "TestString3",  "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalArrayType[0].non_optionalBool, true,             "Non-Optional Bool value was parsed incorrectly")
    }

    /**
     *  TestObjectSeven missing non-optional sub object array
     **/
    func testArrayComplexSubtypeMappingFailableInitializer() {

        let object1Dictionary = ["non_optional_int"     : 50,
                                 "non_optional_string"  : "TestString1",
                                 "non_optional_double"  : 60.0,
                                 "non_optional_float"   : 70.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let object2Dictionary = ["non_optional_int"     : 80,
                                 "non_optional_string"  : "TestString2",
                                 "non_optional_double"  : 90.0,
                                 "non_optional_float"   : 100.0,
                                 "non_optional_bool"    : false] as [String : Any]
        
        let testObjectArray = [object1Dictionary, object2Dictionary]
        let dataDictionary = ["optional_sub_object_array" : testObjectArray] as [String : AnyObject]
        
        let testObject = TestObjectSeven(dataDictionary)
        
        XCTAssertNil(testObject, "Failable initializer should have returned nil, non-optinal values are missing")
    }

    /**
     *  TestObjectEight has a dictionary of TestObjectFour(s), 
     *  and ingests the sub object as a dictionary
     **/
    func testDictionaryComplexSubtypeSingleMapping() {

        let object1Dictionary = ["non_optional_int"     : 50,
                                 "non_optional_string"  : "TestString1",
                                 "non_optional_double"  : 60.0,
                                 "non_optional_float"   : 70.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let object2Dictionary = ["non_optional_int"     : 110,
                                 "non_optional_string"  : "TestString3",
                                 "non_optional_double"  : 120.0,
                                 "non_optional_float"   : 130.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let dataDictionary  = ["optional_sub_object_dictionary"     : object1Dictionary,
                               "non_optional_sub_object_dictionary" : object2Dictionary] as [String : AnyObject]
        
        let testObject = TestObjectEight(dataDictionary)
        
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalInt, Int(50),              "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalDouble, Double(60.0),      "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalFloat, Float(70.0),        "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalString, "TestString1",     "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalBool, true,                "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalInt, Int(110),          "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalDouble, Double(120.0),  "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalFloat, Float(130.0),    "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalString, "TestString3",  "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalBool, true,             "Non-Optional Bool value was parsed incorrectly")
    }

    /**
     *  TestObjectEight has a dictionary of TestObjectFour(s),
     *  and ingests the sub object as a array
     **/
    func testDictionaryComplexSubtypeToArraysOfDictionaries() {

        let object1Dictionary = ["non_optional_int"     : 50,
                                 "non_optional_string"  : "TestString1",
                                 "non_optional_double"  : 60.0,
                                 "non_optional_float"   : 70.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let object2Dictionary = ["non_optional_int"     : 80,
                                 "non_optional_string"  : "TestString2",
                                 "non_optional_double"  : 90.0,
                                 "non_optional_float"   : 100.0,
                                 "non_optional_bool"    : false] as [String : Any]
        
        let object3Dictionary = ["non_optional_int"     : 110,
                                 "non_optional_string"  : "TestString3",
                                 "non_optional_double"  : 120.0,
                                 "non_optional_float"   : 130.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let object4Dictionary = ["non_optional_int"     : 140,
                                 "non_optional_string"  : "TestString4",
                                 "non_optional_double"  : 150.0,
                                 "non_optional_float"   : 160.0,
                                 "non_optional_bool"    : false] as [String : Any]
        
        let testObjectArray  = [object1Dictionary, object2Dictionary]
        let testObjectArray2 = [object3Dictionary, object4Dictionary]
        
        let dataDictionary = ["optional_sub_object_dictionary"      : testObjectArray,
                              "non_optional_sub_object_dictionary"  : testObjectArray2] as [String : AnyObject]
        
        let testObject = TestObjectEight(dataDictionary)
        
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalInt, Int(50),              "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalDouble, Double(60.0),      "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalFloat, Float(70.0),        "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalString, "TestString1",     "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["0"]!.non_optionalBool, true,                "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObject!.optionalDictionaryType!["1"]!.non_optionalInt, Int(80),              "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["1"]!.non_optionalDouble, Double(90.0),      "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["1"]!.non_optionalFloat, Float(100.0),       "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["1"]!.non_optionalString, "TestString2",     "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDictionaryType!["1"]!.non_optionalBool, false,               "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalInt, Int(110),          "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalDouble, Double(120.0),  "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalFloat, Float(130.0),    "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalString, "TestString3",  "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["0"]!.non_optionalBool, true,             "Non-Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObject!.non_optionalDictionaryType["1"]!.non_optionalInt, Int(140),          "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["1"]!.non_optionalDouble, Double(150.0),  "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["1"]!.non_optionalFloat, Float(160.0),    "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["1"]!.non_optionalString, "TestString4",  "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDictionaryType["1"]!.non_optionalBool, false,            "Non-Optional Bool value was parsed incorrectly")
    }

    /**
     *  TestObjectEight has a dictionary of TestObjectFour(s), 
     *  and should fail since the sub object is missing
     **/
    func testDictionaryComplexSubtypeFailableInitializer() {
       
        let object1Dictionary = ["non_optional_int"     : 50,
                                 "non_optional_string"  : "TestString1",
                                 "non_optional_double"  : 60.0,
                                 "non_optional_float"   : 70.0,
                                 "non_optional_bool"    : true] as [String : Any]
        
        let dataDictionary = ["optional_sub_object_dictionary" : object1Dictionary] as [String : AnyObject]
        
        let testObject = TestObjectEight(dataDictionary)
        
        XCTAssertNil(testObject, "Failable initializer should have returned nil, non-optinal values are missing")
    }

    /**
     *  Test array of arrays to dictionary of subtypes
     **/
    func testArraySimpleSubtypeMapping() {
        
        let stringArray     = ["String1", "String2", "String3"]
        let intArray        = [1, 2, 3]
        let doubleArray     = [Double(4.0), Double(5.0), Double(6.0)]
        let floatArray      = [Float(7.0), Float(8.0), Float(9.0)]
        
        let dataDictionary  = ["optional_array_string_type"     : stringArray,
                               "optional_array_int_type"        : intArray,
                               "optional_array_double_type"     : doubleArray,
                               "optional_array_float_type"      : floatArray,
                               "non_optional_array_string_type" : stringArray,
                               "non_optional_array_int_type"    : intArray,
                               "non_optional_array_double_type" : doubleArray,
                               "non_optional_array_float_type"  : floatArray] as [String : AnyObject]
        
        let testObject = TestObjectNine(dataDictionary)
        
        for stringValue in stringArray {
            XCTAssertTrue(testObject?.optionalArrayStringType!.containsValue(stringValue) == true,
                          "Array subtype as String was parsed incorrectly from Array")
        }
        
        for doubleValue in doubleArray {
            XCTAssertTrue(testObject?.optionalArrayDoubleType!.containsValue(doubleValue) == true,
                          "Array subtype as Double was parsed incorrectly from Array")
        }
        
        for floatValue in floatArray {
            XCTAssertTrue(testObject?.optionalArrayFloatType!.containsValue(floatValue) == true,
                          "Array subtype as Float was parsed incorrectly from Array")
        }
        
        for intValue in intArray {
            XCTAssertTrue(testObject?.optionalArrayIntType!.containsValue(intValue) == true,
                          "Array subtype as Int was parsed incorrectly from Array")
        }
        
        for stringValue in stringArray {
            XCTAssertTrue(testObject?.non_optionalArrayStringType.containsValue(stringValue) == true,
                          "Non-Optional Array subtype as String was parsed incorrectly from Array")
        }
        
        for doubleValue in doubleArray {
            XCTAssertTrue(testObject?.non_optionalArrayDoubleType.containsValue(doubleValue) == true,
                          "Non-Optional Array subtype as Double was parsed incorrectly from Array")
        }
        
        for floatValue in floatArray {
            XCTAssertTrue(testObject?.non_optionalArrayFloatType.containsValue(floatValue) == true,
                          "Non-Optional Array subtype as Float was parsed incorrectly from Array")
        }
        
        for intValue in intArray {
            XCTAssertTrue(testObject?.non_optionalArrayIntType.containsValue(intValue) == true,
                          "Non-Optional Array subtype as Int was parsed incorrectly from Array")
        }
    }
    
    /**
     *  Test array of dictioanries to dictionary of subtypes
     **/
    func testArraySimpleSubtypeToArraysOfDictionaries() {
        
        let stringDictionary    = ["1" : "String1", "2" : "String2", "3" : "String3"]
        let intDictionary       = ["1" : 1, "2" : 2, "3" : 3]
        let doubleDictionary    = ["1" : Double(4.0), "2" : Double(5.0), "3" : Double(6.0)]
        let floatDictionary     = ["1" : Float(7.0), "2" : Float(8.0), "3" : Float(9.0)]
        
        let dataDictionary = ["optional_array_string_type"      : stringDictionary,
                              "optional_array_int_type"         : intDictionary,
                              "optional_array_double_type"      : doubleDictionary,
                              "optional_array_float_type"       : floatDictionary,
                              "non_optional_array_string_type"  : stringDictionary,
                              "non_optional_array_int_type"     : intDictionary,
                              "non_optional_array_double_type"  : doubleDictionary,
                              "non_optional_array_float_type"   : floatDictionary] as [String : AnyObject]
        
        let testObject = TestObjectNine(dataDictionary)
        
        for (_ , stringValue) in stringDictionary {
            XCTAssertTrue(testObject?.optionalArrayStringType!.containsValue(stringValue) == true,
                          "Array subtype as String was parsed incorrectly from dictionary")
        }
        
        for (_ , doubleValue) in doubleDictionary {
            XCTAssertTrue(testObject?.optionalArrayDoubleType!.containsValue(doubleValue) == true,
                          "Array subtype as Double was parsed incorrectly from dictionary")
        }
        
        for (_ , floatValue) in floatDictionary {
            XCTAssertTrue(testObject?.optionalArrayFloatType!.containsValue(floatValue) == true,
                          "Array subtype as Float was parsed incorrectly from dictionary")
        }
        
        for (_ , intValue) in intDictionary {
            XCTAssertTrue(testObject?.optionalArrayIntType!.containsValue(intValue) == true,
                          "Array subtype as Int was parsed incorrectly from dictionary")
        }
        
        for (_ , stringValue) in stringDictionary {
            XCTAssertTrue(testObject?.non_optionalArrayStringType.containsValue(stringValue) == true,
                          "Non-Optional Array subtype as String was parsed incorrectly from dictionary")
        }
        
        for (_ , doubleValue) in doubleDictionary {
            XCTAssertTrue(testObject?.non_optionalArrayDoubleType.containsValue(doubleValue) == true,
                          "Non-Optional Array subtype as Double was parsed incorrectly from dictionary")
        }
        
        for (_ , floatValue) in floatDictionary {
            XCTAssertTrue(testObject?.non_optionalArrayFloatType.containsValue(floatValue) == true,
                          "Non-Optional Array subtype as Float was parsed incorrectly from dictionary")
        }
        
        for (_ , intValue) in intDictionary {
            XCTAssertTrue(testObject?.non_optionalArrayIntType.containsValue(intValue) == true,
                          "Non-Optional Array subtype as Int was parsed incorrectly from dictionary")
        }
    }
    
    /**
     *  Test array of arrays to dictionary of non-optional subtypes which are missing
     **/
    func testArraySimpleSubtypeFailableInitializer() {
        
        let stringArray     = ["String1", "String2", "String3"]
        let intArray        = [1, 2, 3]
        let doubleArray     = [Double(4.0), Double(5.0), Double(6.0)]
        let floatArray      = [Float(7.0), Float(8.0), Float(9.0)]
        
        let dataDictionary = ["optional_array_string_type"  : stringArray,
                              "optional_array_int_type"     : intArray,
                              "optional_array_double_type"  : doubleArray,
                              "optional_array_float_type"   : floatArray] as [String : AnyObject]
        
        let testObject = TestObjectNine(dataDictionary)
        
        XCTAssertNil(testObject, "Failable initializer should have returned nil, non optional array values are nill")
    }

    /**
     *  Test dictionary of dictionaries to non-optional dictionary of value types
     **/
    func testDictionarySimpleSubtypeMapping() {
        
        let stringDictionary    = ["1" : "String1", "2" : "String2", "3" : "String3"]
        let intDictionary       = ["1" : 1, "2" : 2, "3" : 3]
        let doubleDictionary    = ["1" : Double(4.0), "2" : Double(5.0), "3" : Double(6.0)]
        let floatDictionary     = ["1" : Float(7.0), "2" : Float(8.0), "3" : Float(9.0)]
        
        let dataDictionary = ["optional_dictionary_string_type"     : stringDictionary,
                              "optional_dictionary_int_type"        : intDictionary,
                              "optional_dictionary_double_type"     : doubleDictionary,
                              "optional_dictionary_float_type"      : floatDictionary,
                              "non_optional_dictionary_string_type" : stringDictionary,
                              "non_optional_dictionary_int_type"    : intDictionary,
                              "non_optional_dictionary_double_type" : doubleDictionary,
                              "non_optional_dictionary_float_type"  : floatDictionary] as [String : AnyObject]
        
        let testObject = TestObjectTen(dataDictionary)
        
        for (key, stringValue) in stringDictionary {
            XCTAssertEqual(testObject!.optionalDictionaryStringType![key]!, stringValue,
                           "Optional String value was parsed incorrectly from dictionary")
        }
        
        for (key, intValue) in intDictionary {
            XCTAssertEqual(testObject!.optionalDictionaryIntType![key]!, intValue,
                           "Optional Int value was parsed incorrectly from dictionary")
        }
        
        for (key, floatValue) in floatDictionary {
            XCTAssertEqual(testObject!.optionalDictionaryFloatType![key]!, floatValue,
                           "Optional Float value was parsed incorrectly from dictionary")
        }
        
        for (key, doubleValue) in doubleDictionary {
            XCTAssertEqual(testObject!.optionalDictionaryDoubleType![key]!, doubleValue,
                           "Optional Double value was parsed incorrectly from dictionary")
        }
        
        for (key, stringValue) in stringDictionary {
            XCTAssertEqual(testObject!.non_optionalDictionaryStringType[key]!, stringValue,
                           "Non-Optional String value was parsed incorrectly from dictionary")
        }
        
        for (key, intValue) in intDictionary {
            XCTAssertEqual(testObject!.non_optionalDictionaryIntType[key]!, intValue,
                           "Non-Optional Int value was parsed incorrectly from dictionary")
        }
        
        for (key, floatValue) in floatDictionary {
            XCTAssertEqual(testObject!.non_optionalDictionaryFloatType[key]!, floatValue,
                           "Non-Optional Float value was parsed incorrectly from dictionary")
        }
        
        for (key, doubleValue) in doubleDictionary {
            XCTAssertEqual(testObject!.non_optionalDictionaryDoubleType[key]!, doubleValue,
                           "Non-Optional Double value was parsed incorrectly from dictionary")
        }
    }
    
    /**
     *  Test dictionary of arrays to non-optional dictionary of value types
     **/
    func testDictionarySimpleSubtypeFromArrayMapping() {
        
        let stringArray     = ["String1", "String2", "String3"]
        let intArray        = [1, 2, 3]
        let doubleArray     = [Double(4.0), Double(5.0), Double(6.0)]
        let floatArray      = [Float(7.0), Float(8.0), Float(9.0)]
        
        let dataDictionary  = ["optional_dictionary_string_type"        : stringArray,
                               "optional_dictionary_int_type"           : intArray,
                               "optional_dictionary_double_type"        : doubleArray,
                               "optional_dictionary_float_type"         : floatArray,
                               "non_optional_dictionary_string_type"    : stringArray,
                               "non_optional_dictionary_int_type"       : intArray,
                               "non_optional_dictionary_double_type"    : doubleArray,
                               "non_optional_dictionary_float_type"     : floatArray] as [String : AnyObject]
        
        let testObject = TestObjectTen(dataDictionary)
        
        XCTAssertEqual(testObject!.optionalDictionaryStringType!["0"]!, "String1",      "Optional String value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.optionalDictionaryStringType!["1"]!, "String2",      "Optional String value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.optionalDictionaryStringType!["2"]!, "String3",      "Optional String value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObject!.optionalDictionaryIntType!["0"]!, 1,                 "Optional Int value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.optionalDictionaryIntType!["1"]!, 2,                 "Optional Int value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.optionalDictionaryIntType!["2"]!, 3,                 "Optional Int value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObject!.optionalDictionaryDoubleType!["0"]!, Double(4.0),    "Optional Double value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.optionalDictionaryDoubleType!["1"]!, Double(5.0),    "Optional Double value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.optionalDictionaryDoubleType!["2"]!, Double(6.0),    "Optional Double value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObject!.optionalDictionaryFloatType!["0"]!, Float(7.0),      "Optional Float value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.optionalDictionaryFloatType!["1"]!, Float(8.0),      "Optional Float value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.optionalDictionaryFloatType!["2"]!, Float(9.0),      "Optional Float value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObject!.non_optionalDictionaryStringType["0"]!, "String1",   "Non-Optional String value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.non_optionalDictionaryStringType["1"]!, "String2",   "Optional String value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.non_optionalDictionaryStringType["2"]!, "String3",   "Optional String value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObject!.non_optionalDictionaryIntType["0"]!, 1,              "Optional Int value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.non_optionalDictionaryIntType["1"]!, 2,              "Optional Int value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.non_optionalDictionaryIntType["2"]!, 3,              "Optional Int value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObject!.non_optionalDictionaryDoubleType["0"]!, Double(4.0), "Optional Double value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.non_optionalDictionaryDoubleType["1"]!, Double(5.0), "Optional Double value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.non_optionalDictionaryDoubleType["2"]!, Double(6.0), "Optional Double value was parsed incorrectly from Array")
        
        XCTAssertEqual(testObject!.non_optionalDictionaryFloatType["0"]!, Float(7.0),   "Optional Float value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.non_optionalDictionaryFloatType["1"]!, Float(8.0),   "Optional Float value was parsed incorrectly from Array")
        XCTAssertEqual(testObject!.non_optionalDictionaryFloatType["2"]!, Float(9.0),   "Optional Float value was parsed incorrectly from Array")
    }

    /**
     *  TestObjectTwelve is mapped with nested key values
     **/
    func testNestedMapping() {
        
        let final_value_dictionary = ["non_optional_int"    : 50,
                                      "non_optional_string" : "TestString",
                                      "non_optional_double" : 70.0,
                                      "non_optional_float"  : 80.0,
                                      "non_optional_bool"   : false] as [String : Any]
        
        let testObjectdictionary = ["top_level_key" : final_value_dictionary] as [String : AnyObject]
        let testObject = TestObjectEleven(testObjectdictionary)
        
        XCTAssertNil(testObject!.optionalInt,       "Optional Int Value should be nil")
        XCTAssertNil(testObject!.optionalString,    "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalDouble,    "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalFloat,     "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalBool,      "Optional String Value should be nil")
        
        XCTAssertEqual(testObject!.non_optionalInt, Int(50),            "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalString, "TestString",    "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(70.0),    "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(80.0),      "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalBool, false,             "Non-Optional Bool value was parsed incorrectly")
    }
    
    /**
     *  TestObjectTwelve is mapped with nested and non nested key values
     **/
    func testNestedAndNonNestedMapping() {

        let final_value_dictionary = ["non_optional_double" : 70.0,
                                      "non_optional_float"  : 80.0,
                                      "non_optional_bool"   : false] as [String : Any]
        
        let testObjectdictionary = ["top_level_key"         : final_value_dictionary,
                                    "non_optional_int"      : 50,
                                    "non_optional_string"   : "TestString"] as [String : AnyObject]
        
        let testObject = TestObjectTwelve(testObjectdictionary)
        
        XCTAssertNil(testObject!.optionalInt,       "Optional Int Value should be nil")
        XCTAssertNil(testObject!.optionalString,    "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalDouble,    "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalFloat,     "Optional String Value should be nil")
        XCTAssertNil(testObject!.optionalBool,      "Optional String Value should be nil")
        
        XCTAssertEqual(testObject!.non_optionalInt, Int(50), "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalString, "TestString", "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(70.0), "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(80.0), "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalBool, false, "Non-Optional Bool value was parsed incorrectly")
    }
    
    /**
     *  TestObjectFive has defaults only for non-optional values the optional values should all be nil
     *  All while the non optional values will be overriden to a value not set to a default
     **/
    func testUpdatedValues() {

        let dictionary = ["optional_int"        : 50,
                          "optional_string"     : "TestString",
                          "optional_double"     : 70.0,
                          "optional_float"      : 80.0,
                          "optional_bool"       : false,
                          "non_optional_int"    : 50,
                          "non_optional_string" : "TestString",
                          "non_optional_double" : 70.0,
                          "non_optional_float"  : 80.0,
                          "non_optional_bool"   : false] as [String : AnyObject]
        
        let testObject = TestObjectFour(dictionary)
        
        XCTAssertEqual(testObject!.optionalInt!, Int(50),               "Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalString!, "TestString",       "Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDouble!, Double(70.0),       "Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalFloat!, Float(80.0),         "Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalBool!, false,                "Optional Bool value was parsed incorrectly")
        
        XCTAssertEqual(testObject!.non_optionalInt, Int(50),            "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalString, "TestString",    "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(70.0),    "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(80.0),      "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalBool, false,             "Non-Optional Bool value was parsed incorrectly")
        
        
        let newOptionalValuesDictionary = ["optional_int"       : 100,
                                           "optional_string"    : "NewTestString",
                                           "optional_double"    : 140.0,
                                           "optional_float"     : 160.0,
                                           "optional_bool"      : true] as [String : AnyObject]
        
        testObject?.updateWithDictionary(dictionary: newOptionalValuesDictionary)

        // Ensure only the optional values got updated
        XCTAssertEqual(testObject!.optionalInt!, Int(100),              "Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalString!, "NewTestString",    "Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDouble!, Double(140.0),      "Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalFloat!, Float(160.0),        "Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalBool!, true,                 "Optional Bool value was parsed incorrectly")
        
        // Non Optional Values should stay the same
        XCTAssertEqual(testObject!.non_optionalInt, Int(50),            "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalString, "TestString",    "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(70.0),    "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(80.0),      "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalBool, false,             "Non-Optional Bool value was parsed incorrectly")
        
        
        let newNonOptionalValuesDictionary = ["non_optional_int"    : 100,
                                              "non_optional_string" : "NewNonOptionalString",
                                              "non_optional_double" : 140.0,
                                              "non_optional_float"  : 160.0,
                                              "non_optional_bool"   : true] as [String : AnyObject]
        
        testObject?.updateWithDictionary(dictionary: newNonOptionalValuesDictionary)

        // Ensure only the optional values stay the same
        XCTAssertEqual(testObject!.optionalInt!, Int(100),              "Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalString!, "NewTestString",    "Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDouble!, Double(140.0),      "Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalFloat!, Float(160.0),        "Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalBool!, true,                 "Optional Bool value was parsed incorrectly")
        
        // Ensure only Non Optional Values have been updated
        XCTAssertEqual(testObject!.non_optionalInt, Int(100),                   "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalString, "NewNonOptionalString",  "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(140.0),           "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(160.0),             "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalBool, true,                      "Non-Optional Bool value was parsed incorrectly")
        
        
        let newPartialOptionalValuesDictionary = ["optional_int"    : 200,
                                                  "optional_string" : "NewPartialValuesTestString",
                                                  "optional_bool"   : false] as [String : AnyObject]
    
        testObject?.updateWithDictionary(dictionary: newPartialOptionalValuesDictionary)

        // Ensure only the values specified in the dictionary are updated
        XCTAssertEqual(testObject!.optionalInt!, Int(200),                          "Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalString!, "NewPartialValuesTestString",   "Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDouble!, Double(140.0),                  "Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalFloat!, Float(160.0),                    "Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalBool!, false,                            "Optional Bool value was parsed incorrectly")
        
        // Ensure only Non Optional Values stay the same
        XCTAssertEqual(testObject!.non_optionalInt, Int(100),                       "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalString, "NewNonOptionalString",      "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(140.0),               "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(160.0),                 "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalBool, true,                          "Non-Optional Bool value was parsed incorrectly")

        
        let newPartialNonOptionalValuesDictionary = ["non_optional_string"  : "NewPartialNonOptionalString",
                                                     "non_optional_double"  : 280.0,
                                                     "non_optional_bool"    : false] as [String : AnyObject]
        
        testObject?.updateWithDictionary(dictionary: newPartialNonOptionalValuesDictionary)
        
        // Ensure only optional values stay the same
        XCTAssertEqual(testObject!.optionalInt!, Int(200),                          "Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalString!, "NewPartialValuesTestString",   "Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalDouble!, Double(140.0),                  "Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalFloat!, Float(160.0),                    "Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.optionalBool!, false,                            "Optional Bool value was parsed incorrectly")
        
        // Ensure only the values specified in the dictionary are updated for non optionals
        XCTAssertEqual(testObject!.non_optionalInt, Int(100),                           "Non-Optional Int value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalString, "NewPartialNonOptionalString",   "Non-Optional String value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalDouble, Double(280.0),                   "Non-Optional Double value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalFloat, Float(160.0),                     "Non-Optional Float value was parsed incorrectly")
        XCTAssertEqual(testObject!.non_optionalBool, false,                             "Non-Optional Bool value was parsed incorrectly")
    }
    
    /**
     *  TestObjectThirteen tests values types
     **/
    func testValueTypeMapping() {
        
        let dataDictionary = ["string1"         : "string1",
                              "string2"         : "string2",
                              "enumValue"       : 2,
                              "value_one"       : 20.0,
                              "value_two"       : 40.0,
                              "handler_type"    : "uppercase"] as [String : AnyObject]
        
        let testObject = TestObjectThirteen(dataDictionary)
        
        XCTAssertEqual(testObject!.optionalStruct!.string1, "string1",                      "Struct mapped incorrectly")
        XCTAssertEqual(testObject!.optionalStruct!.string2, "string2",                      "Struct mapped incorrectly")
        XCTAssertEqual(testObject!.optionalEnum!.rawValue, 2,                               "Enum mapped incorrectly")
        XCTAssertEqual(testObject!.optionalTuple!.val1, 20.0,                               "Tuple mapped incorrectly")
        XCTAssertEqual(testObject!.optionalTuple!.val2, 40.0,                               "Tuple mapped incorrectly")
        XCTAssertEqual(testObject!.optionalUppercaseCompletionHandler!("hello"), "HELLO",   "Completion handler mapped incorrectly")
    
        let updateCompletionHandlerDictionary = ["handler_type" : "lowercase"] as [String : AnyObject]
        
        testObject?.updateWithDictionary(dictionary: updateCompletionHandlerDictionary)
        
        XCTAssertEqual(testObject!.optionalUppercaseCompletionHandler!("HELLO"), "hello", "Completion handler mapped incorrectly")
    }
}
