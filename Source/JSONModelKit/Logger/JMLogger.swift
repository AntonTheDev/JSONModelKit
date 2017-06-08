//
//  JMLogger.swift
//  
//
//  Created by Anton Doudarev on 6/8/17.
//
//
//
//  jmLogger.swift
//  TechBook
//
//  Created by Anton Doudarev on 9/25/15.
//  Copyright © 2015 Huge. All rights reserved.
//

import Foundation

public enum JMLogLevel : Int {
    case none = 0
    case error = 1
    case warning = 2
    case info = 3
    case debug = 4
    case verbose = 5
}

public func logError(_ logString:  String) {
    Log(.error, logString: logString)
}

public func jm_logWarning(_ logString:  String) {
    Log(.warning, logString: logString)
}

public func jm_logInfo(_ logString:  String) {
    Log(.info, logString: logString)
}

public func jm_logDebug(_ logString:  String) {
    Log(.debug, logString: logString)
}

public func jm_logVerbose(_ logString:  String) {
    Log(.verbose, logString: logString)
}

public func ENTRY_LOG(functionName:  String = #function) {
    jm_logVerbose("ENTRY " + functionName)
}

public func EXIT_LOG(functionName:  String = #function) {
    jm_logVerbose("EXIT " + functionName)
}

public func Log(_ currentLogLevel: JMLogLevel, logString:  String) {
    if currentLogLevel.rawValue <= JMConfig.logLevel.rawValue {
        let log = jm_stringForLogLevel(JMConfig.logLevel) + " - " + logString
        print(log)
    }
}

public func jm_stringForLogLevel(_ logLevel:  JMLogLevel) -> String {
    switch logLevel {
    case .debug:
        return "D"
    case .verbose:
        return "V"
    case .info:
        return "I"
    case .warning:
        return "W"
    case .error:
        return "E"
    case .none:
        return "NONE"
    }
}
