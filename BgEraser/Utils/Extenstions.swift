//
//  Extenstions.swift
//  BgEraser
//
//  Created by pawan kumar on 27/08/22.
//

import Foundation
import UIKit
import CoreTelephony

///  DP extensions has been added to CGFloat to vary values as per different iPhone Sizes considering iPhone 8 as base
extension CGFloat {
    /**
     The relative dimension to the corresponding screen size.
     
     //Usage
     let someView = UIView(frame: CGRect(x: 0, y: 0, width: 320.dp, height: 40.dp)
     
     **Warning** Only works with size references from @1x mockups.
     
     */
    ///  DP extensions has been added to CGFloat to vary values as per different iPhone Sizes considering iPhone 8 as base
    public var dp: CGFloat {
        return (self / 375) * UIScreen.main.bounds.width
    }
}

///Below has been added for easy access and avoiding lint issues
extension String {
    
    /// String.empty = ""
    public static let empty = ""
    /// String.space = " "
    public static let space = " "
    /// String.tabSpace = "\t"
    public static let tabSpace = "\t"
    /// String.newLine = "\n"
    public static let newLine = "\n"
    /// String.colon = ":"
    public static let colon = ":"
    /// String.hyphen = "-"
    public static let hyphen = "-"
    /// String.percentage = "%"
    public static let percentage = "%"
    /// String.ampersand = "&"
    public static let ampersand = "&"
    /// String.asterisk = "*"
    public static let asterisk = "*"
    /// String.openingBracket = "("
    public static let openingBracket = "("
    /// String.closingBracket = ")"
    public static let closingBracket = ")"
    /// String.plus = "+"
    public static let plus = "+"
    /// String.comma = ","
    public static let comma = ","
    /// String.dot = "."
    public static let dot = "."
    /// String.question = "?"
    public static let question = "?"
    /// String.singleQuote = "'"
    public static let singleQuote = "'"
    /// String.doubleQuote = "\""
    public static let doubleQuote = "\""
    /// String.pipe = "|"
    public static let pipe = "|"
    /// String.underscore = "_"
    public static let underscore = "_"
    /// String.equalSign = "="
    public static let equalSign = "="
    
  
    public static var defaultLocale = Locale.current

    
    /// Get Path URL from Assets Bundle with name as String itself
    public func getPathURLFromBundle(_ fileExtension:String, bundle:Bundle = Bundle.main) -> URL?{
        if let url = bundle.url(forResource: self, withExtension: fileExtension) {
            return url
        }else{
            LogUtils.e("Resource named \(self) not found at bundle.");
        }
        return nil
    }
    
    /// Get Path URL from Documents Director with name as String itself
    public func getPathURLFromDocumentsDirectory(_ fileExtension:String, directoryURL:URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first) -> URL?{
        
        if directoryURL != nil {
            let destinationFileUrl = directoryURL!.appendingPathComponent("\(self).\(fileExtension)")
            
            let fileExists = FileManager().fileExists(atPath: destinationFileUrl.path)
            
            if fileExists {
                return destinationFileUrl
            }else{
                LogUtils.e("File named \(self) not found on Disk Space at Documents Directory.");
            }
        }else{
            LogUtils.e("Disk Folder named Documents Directory not found on Disk.");
        }
        
        return nil
    }
    
    /// Get UIColor from String HexCode value
    public func getUIColor() -> UIColor{
        return UIColor.init(hexString: self)
    }
     
     
    /// Format String
    public static func format(strings: String ..., withSeparator separtor: String = String.empty) -> String {
        return "\(strings.joined(separator: separtor))"
    }
    
    /// Get Height for particular string contents
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    /// Get Width for particular string contents
    public func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    /// Get Initials from String Words - used mainly in finding out Name Initials - like RC for Rakesh Chander
    public func getFirstCharacters() -> String {
        var firstCharacters = String.empty
        let namesArray = self.components(separatedBy: String.space)
        if namesArray.count > 1 {
            for item in namesArray {
                if let char = item.first {
                    firstCharacters += String(char)
                }
            }
        } else {
            if let char = namesArray[0].first {
                firstCharacters += String(char)
            }
        }
        return firstCharacters.uppercased()
    }
    public func filterCharacters(unicodeScalarsFilter closure: (UnicodeScalar) -> Bool) -> String {
        return String(String.UnicodeScalarView(unicodeScalars.filter { closure($0) }))
    }
    public func filterCharacters(definedIn charSets: [CharacterSet], unicodeScalarsFilter: (CharacterSet, UnicodeScalar) -> Bool) -> String {
        if charSets.isEmpty { return self }
        let charSet = charSets.reduce(CharacterSet()) { return $0.union($1)
        }
        return filterCharacters { unicodeScalarsFilter(charSet, $0) }
    }
    public func onlyCharacters(charSets: [CharacterSet]) -> String {
        return filterCharacters(definedIn: charSets) { $0.contains($1) }
    }
    public func onlyNumbers(charSet: CharacterSet) -> String {
        return onlyCharacters(charSets: [charSet])
    }
}

public extension UIColor {
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    /// Create Color Instance from HexCode String Value
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    /// Get translucent color of an instance - 50%
    func translucent() -> UIColor{
        return self.withAlphaComponent(0.50)
    }
    
    /// Get hazy color of an instance - 75%
    func hazy() -> UIColor{
        return self.withAlphaComponent(0.75)
    }
    
    /// Get transparent color of an instance - 25%
    func transparent() -> UIColor{
        return self.withAlphaComponent(0.25)
    }
    
}

public extension UIImage {
    
    // colorize image with given tint color
    // this is similar to Photoshop's "Color" layer blend mode
    // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
    // white will stay white and black will stay black as the lightness of the image is preserved
    func tint(tintColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            
            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)
            
            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    // fills the alpha channel of the source image with the given color
    // any color information except to the alpha channel will be ignored
    func fillAlpha(fillColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
            //            context.fillCGContextFillRect(context, rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    private func modifiedImage( draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

public extension UIApplication {

    /// Get Top View Controller of application
    func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        }
        return base
    }
}

extension UIViewController {
    /// Override this function to update DXL / LIVE theme over Push Notifications
    @objc open func updateTheme() {
        //override to update theme
    }
}

public extension UIDevice {
    
    /// parse the deveice name as the standard name
    var modelName: String {
        
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE 2nd Gen"
        case "iPhone13,1":                              return "iPhone 12 Mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "iPhone14,2":                              return "iPhone 13 Pro"
        case "iPhone14,3":                              return "iPhone 13 Pro Max"
        case "iPhone14,4":                              return "iPhone 13 Mini"
        case "iPhone14,5":                              return "iPhone 13"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }
    
    /// Get IP Address
    class func getIPAddressOfDevice() -> String?{
        var address : String = ""
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0"  || name == "pdp_ip0" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                    if name == "pdp_ip0" {
                        break
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    /// Get Service provider name
    class func getServiceProviderName() -> String {
        var serviceProviderName = ""
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        if carrier?.carrierName != nil {
            serviceProviderName = (carrier?.carrierName)!
        }
        return serviceProviderName
    }

}

public extension UIViewController {
    /// Instantiating ViewController as per MicroApp Strategy - MXVM Architecture
    /// - It checks repective XIB first in main bundle, if found thats used for VC otherwise - FMA specific bundle is used - by default
    ///
    static func instantiate(storyboardName: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self))
        return vc as! Self
    }
      
    /// Getting Parent Navigation Item instance to setup nav properties currectly
    var navItem: UINavigationItem {
     
     if var parentVC = self.parent {
         while let newParent = parentVC.parent, newParent.navigationController != nil {
             parentVC = newParent
         }
         return parentVC.navigationItem
     }
     
        return self.navigationItem
    }
}

public extension Bundle {

    /// For dynamic / static frameworks - use below mthod to correctly define bundle internally
    static func resourceBundle(for frameworkClass: AnyClass) -> Bundle {
        guard let moduleName = String(reflecting: frameworkClass).components(separatedBy: ".").first else {
            return Bundle.init(for: frameworkClass)
        }

        let frameworkBundle = Bundle(for: frameworkClass)

        guard let resourceBundleURL = frameworkBundle.url(forResource: moduleName, withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
            return Bundle.init(for: frameworkClass)
        }

        return resourceBundle
    }
}

public extension UIView {
    /// To get View (XIB) of any custom view or cells - tableView / collectionView using MXVM architecture
    /// - It checks repective XIB first in main bundle, if found thats used for VC otherwise - FMA specific bundle is used - by default
    static func getNib() -> UINib {
        
        if Bundle.main.path(forResource: String(describing: self), ofType: "nib") != nil {
            return UINib(nibName: String(describing: self), bundle: .main)
        }
        
        let sdkBundle = Bundle.resourceBundle(for: self)
        return UINib(nibName: String(describing: self), bundle: sdkBundle)
    }
    
    /// To get reuseIdentifier for cells / views - as class name itself
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

public extension Array {
    /// For accessing particular object at any index of an array - to escape from ArrayOutOfBound exception
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}

public extension Optional where Wrapped == String {
    /// String - returns empty String if object is nil
    var safelyUnwrap: String {
        return self ?? String.empty
    }
}

public extension Optional where Wrapped == Date {
    /// Date - returns currentDate if object is nil
    var safelyUnwrap: Date {
        return self ?? Date()
    }
}

public extension Optional where Wrapped == CGFloat {
    /// CGFloat / Int - returns 0 if object is nil
    var safelyUnwrap: CGFloat {
        return self ?? 0.0
    }
}

public extension Optional where Wrapped == Double {
    /// CGFloat / Int - returns 0 if object is nil
    var safelyUnwrap: Double {
        return self ?? 0.0
    }
}

public extension Optional where Wrapped == Int {
    /// CGFloat / Int - returns 0 if object is nil
    var safelyUnwrap: Int {
        return self ?? 0
    }
}

public extension Dictionary {
    /// Decode any Dictionary Object to any Decodable Class - if decoding is not possible - returns nil
    func decodeObject<T:Decodable>() -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let decoder = JSONDecoder.init()
            let data = try decoder.decode(T.self, from: jsonData)
            return data
        } catch (let error) {
            LogUtils.d(error.localizedDescription)
            return nil
        }
    }
}

public extension String {
    /// For URL String - get query parameters in Dictionary - if invalid URL or no query params then empty dictionary is returned
    var queryParameters: [AnyHashable: Any] {
        guard let url = URL.init(string: self),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return [:] }
        return queryItems.reduce(into: [AnyHashable: Any]()) { (result, item) in
            result[item.name] = item.value?.removingPercentEncoding
        }
    }
    
    /// For URL String - get context path excluding host & query params - if invalid URL then empty String is returned
    var path: String {
        guard let url = URL.init(string: self),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return String.empty
        }
            return components.path
    }
    
    /// Micro App Development strategy has defined approach for Configurations sush that Product Apps can drive Micro Apps as per respective needs.
    func getConfigValue(targetBundle:Bundle, table:String = "Configurations") -> String {
        return targetBundle.localizedString(forKey: self, value: self, table: table)
    }
}

extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
        ]

    /// Get MimeType of Data - default value as "application/octet-stream"
    public var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}
public extension UITextField{
    @objc open func getRawValue()->String{
        return self.text ?? String.empty
    }
    
    @objc open func setPrepopulatedText(_ text: String){
        self.text = text
    }
}

