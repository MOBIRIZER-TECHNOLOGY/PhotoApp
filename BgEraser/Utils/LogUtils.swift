//
//  Logger.swift
//  BoilerPlate_iOS
//
//  Created by Comviva on 14/04/19.
//  Copyright © 2019 Comviva. All rights reserved.
//

import Foundation

enum LogEvent: String {
    case e = "[‼️] ERROR" // error
    case i = "[ℹ️] INFO" // info
    case d = "[💬] DEBUG" // debug
    case v = "[🔬] VERBOSE" // verbose
    case w = "[⚠️] WARNING" // warning
    case s = "[🔥] SEVERE" // severe
}

/// LogUtils - Have different variations of logs, with proper highlighting markers, in IDE console
/// Have Logs with complete details viz - fileName, lineNo, functionName & columnIndex.

public class LogUtils {
    // 1. The date formatter
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    /// Wrapping Swift.print() within DEBUG flag
    public class func print(_ object: Any) {
        // Only allowing in DEBUG mode
        if self.isLoggingEnabled {
            Swift.print(object)
        }
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    // 1. "[‼️] ERROR" // error
    public class func e( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
    }
    
    // 2. "[ℹ️] INFO" // info
    public class func i( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("\(Date().toString()) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
    }
    
    // 3.  "[💬] DEBUG" // debug
    public class func v( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
    }
    
    // 4. "[🔬] VERBOSE" // verbose
    public class func d( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("\(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
    }
    
    // 5. "[⚠️] WARNING" // warning
    public class func w( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("\(Date().toString()) \(LogEvent.w.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
    }
    
    // 6. "[🔥] SEVERE" // severe
    public class func s( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        print("\(Date().toString()) \(LogEvent.s.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
    }
}

// 2. The Date to String extension
extension Date {
    func toString() -> String {
        return LogUtils.dateFormatter.string(from: self as Date)
    }
}

/// Enable Logs in debug mode only by mentioning below line in AppDelegate
/// #if DEBUG
///  LogUtils.setLoggingEnabled(isEnabled: **true**)
/// #endif
public extension LogUtils {
    private static var isLoggingEnabled : Bool = false
    
    static func setLoggingEnabled(isEnabled : Bool) {
        self.isLoggingEnabled = isEnabled
    }
    
}

