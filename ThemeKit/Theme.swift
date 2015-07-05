//
//  Theme.swift
//  ThemeKit
//
//  Created by Terry Lewis II on 7/4/15.
//  Copyright © 2015 Plover Productions. All rights reserved.
//

import UIKit

enum TextCaseTransform {
    case None, Upper, Lower
}

private func stringIsEmpty(string: String?) -> Bool {
    guard let s = string else {
        return true
    }
    
    return s.characters.count == 0
}

// Picky. Crashes by design.
private func colorFromString(hexString: String?) -> UIColor {
    guard let string = hexString where stringIsEmpty(string) == false else {
        return UIColor.blackColor()
    }
    
    if stringIsHex(string) {
        return parseHexColor(string)
    } else if stringIsRGB(string) {
        return parseRGBAString(string)
    } else {
        return UIColor.blackColor()
    }
}

private func stringIsRGB(string:String) -> Bool {
    return string.hasPrefix("rgb")
}

private func stringIsHex(string:String) -> Bool {
    return string.hasPrefix("#")
}

private func parseRGBAString(rgbaString:String) -> UIColor {
    var junk, red, blue, green:NSString?
    var alpha:Float = 1.0
    let scanner = NSScanner(string: rgbaString)
    let decimal = NSMutableCharacterSet.decimalDigitCharacterSet()
    let commas = NSMutableCharacterSet.punctuationCharacterSet()
    scanner.scanUpToCharactersFromSet(decimal, intoString: &junk)
    scanner.scanUpToCharactersFromSet(commas, intoString: &red)
    scanner.scanUpToCharactersFromSet(decimal, intoString: &junk)
    scanner.scanUpToCharactersFromSet(commas, intoString: &green)
    scanner.scanUpToCharactersFromSet(decimal, intoString: &junk)
    scanner.scanUpToCharactersFromSet(commas, intoString: &blue)
    scanner.scanUpToCharactersFromSet(decimal, intoString: &junk)
    scanner.scanFloat(&alpha)
    
    return UIColor(red: CGFloat(red?.floatValue ?? 0)/255.0, green: CGFloat(green?.floatValue ?? 0)/255.0, blue: CGFloat(blue?.floatValue ?? 0)/255.0, alpha:CGFloat(alpha))
}

private func substringWithRange(string:String, range:Range<Int>) -> String {
    let startIndex = advance(string.startIndex, range.startIndex)
    let endIndex = advance(startIndex, range.endIndex - range.startIndex)
    
    return string[Range(start: startIndex, end: endIndex)]
}


private func parseHexColor(hexString:String) -> UIColor {
    let string = String(dropFirst(hexString.characters)).stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
    
    var alphaValue:UInt32 = 1
    let hasAlpha = string.characters.count > 6
    if hasAlpha {
        let alpha = string.substringToIndex(advance(string.startIndex, 2))
        NSScanner(string: alpha).scanHexInt(&alphaValue)
    }
    let redString = substringWithRange(string, range: Range(start: hasAlpha ? 2 : 0, end: hasAlpha ? 4 : 2))
    let greenString = substringWithRange(string, range: Range(start: hasAlpha ? 4 : 2, end: hasAlpha ? 6 : 4))
    let blueString = substringWithRange(string, range: Range(start: hasAlpha ? 6 : 4, end: hasAlpha ? 8 : 6))
    
    var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
    NSScanner(string: redString).scanHexInt(&r)
    NSScanner(string: greenString).scanHexInt(&g)
    NSScanner(string: blueString).scanHexInt(&b)
    
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: hasAlpha ? CGFloat(alphaValue)/255.0 : 1.0)
}

struct AnimationSpecifier {
    let delay: NSTimeInterval
    let duration: NSTimeInterval
    let curve: UIViewAnimationOptions
}

public class Theme: NSObject {
    let name: String
    var parentTheme: Theme?
    
    private let themeDictionary: NSDictionary
    private let colorCache: NSCache
    private let fontCache: NSCache
    
    public class func themeNamed(themeName:String, themeFileName:String) -> Theme? {
        let loader = ThemeLoader(themeFilename: themeFileName)
        return loader.themeNamed(themeName)
    }
    
    func themeByCombiningWithTheme(otherTheme:Theme?) -> Theme {
        guard let otherTheme = otherTheme else {
            return self
        }
        
        var otherDict = otherTheme.dictionary
        for (key, value) in dictionary {
            otherDict[key] = value
        }
        
        return Theme(fromDictionary: otherDict, name: name)
    }
    
    // MARK: - Init
    init(fromDictionary themeDictionary: NSDictionary, name:String) {
        self.name = name
        colorCache = NSCache()
        fontCache = NSCache()
        self.themeDictionary = themeDictionary
    }
    
    public func innerThemeForKey(key:String) -> Theme? {
        guard let obj = objectForKey(key) as? NSDictionary else {
            return nil
        }
        let innerTheme = Theme(fromDictionary: obj, name:key)
        innerTheme.parentTheme = parentTheme
        return innerTheme
    }
    
    var keys:[String] {
        return themeDictionary.allKeys as! [String]
    }
    
    var values:[AnyObject] {
        return themeDictionary.allValues
    }
    
    var dictionary:[String : AnyObject] {
        return themeDictionary as! [String : AnyObject]
    }
    
    func removeKeys(removeKeys:[String]) -> Theme {
        let temp = NSMutableDictionary(dictionary: themeDictionary)
        temp.removeObjectsForKeys(removeKeys)
        return Theme(fromDictionary: NSDictionary(dictionary: temp), name:name)
    }
    
    // MARK: - Queries
    public func tableViewSeparatorStyleForKey(key:String) -> UITableViewCellSeparatorStyle {
        guard let string = stringForKey(key) else {
            return .SingleLine
        }
        
        switch string.lowercaseString {
        case "singleline": return .SingleLine
        case "Singlelineetched": return .SingleLineEtched
        case "none": return .None
        default: return .SingleLine
        }
    }
    
    public func attributedStringForKey(key:String) -> NSAttributedString {
        guard let attributes = textAttributesDictionaryForKey(key + "Attributes") else {
            return NSAttributedString(string: nonNilStringForKey(key))
        }
        
        return NSAttributedString(string: nonNilStringForKey(key), attributes: attributes)
    }
    
    public func textAttributesDictionaryForKey(key:String) -> [String : AnyObject]? {
        guard let dict = themeDictionary[key] as? [String : AnyObject] else {
            return nil
        }
        
        let themeDict = Theme(fromDictionary: dict, name:key)
        var result:[String : AnyObject] = [:]
        for (key, _) in dict {
            switch key {
            case "font": result[NSFontAttributeName] = themeDict.fontForKey(key)
            case "foregroundColor": result[NSForegroundColorAttributeName] = themeDict.colorForKey(key)
            case "backgroundColor": result[NSBackgroundColorAttributeName] = themeDict.colorForKey(key)
            default: if (key == "fontSize") == false { print("\(key) not yet supported for text attributes dictionary") }
            }
        }
        return result
    }
    
    public func textFieldBorderStyleForKey(key:String) -> UITextBorderStyle {
        guard let string = stringForKey(key) else {
            return .None
        }
        
        switch string.lowercaseString {
        case "none": return .None
        case "line": return .Line
        case "bezel": return .Bezel
        case "roundedrect": return .RoundedRect
        default: return .None
        }
    }
    
    public func objectForKey(key: String) -> AnyObject? {
        guard let obj = themeDictionary[key] else {
            return parentTheme?.objectForKey(key)
        }
        return obj
    }
    
    public func boolForKey(key: String) -> Bool {
        return objectForKey(key) as? Bool ?? false
    }
    
    public func stringForKey(key: String) -> String? {
        return objectForKey(key) as? String
    }
    
    public func nonNilStringForKey(key:String) -> String {
        return stringForKey(key) ?? ""
    }
    
    public func integerForKey(key: String) -> Int {
        return objectForKey(key) as? Int ?? 0
    }
    
    public func floatForKey(key: String) -> CGFloat {
        return objectForKey(key) as? CGFloat ?? 0.0
    }
    
    public func doubleForKey(key: String) -> Double {
        return objectForKey(key) as? Double ?? 0.0
    }
    
    public func imageForKey(key: String) -> UIImage? {
        guard let imageName = stringForKey(key) where stringIsEmpty(imageName) == false else {
            return nil
        }
        return UIImage(named: imageName)
    }
    
    public func colorForKey(key: String) -> UIColor {
        guard let cachedColor = colorCache.objectForKey(key) as? UIColor else {
            let colorString = stringForKey(key)
            let color = colorFromString(colorString)
            colorCache.setObject(color, forKey: key)
            return color
        }
        return cachedColor
    }
    
    public func edgeInsetsForKey(key: String) -> UIEdgeInsets {
        let left = floatForKey(key.stringByAppendingString("Left"))
        let top = floatForKey(key.stringByAppendingString("Top"))
        let right = floatForKey(key.stringByAppendingString("Right"))
        let bottom = floatForKey(key.stringByAppendingString("Bottom"))
        return UIEdgeInsetsMake(top, left, bottom, right)
    }
    
    public func fontForKey(key: String) -> UIFont {
        guard let cachedFont = fontCache.objectForKey(key) as? UIFont else {
            let fontName = stringForKey(key)
            
            let size = floatForKey(key.stringByAppendingString("Size"))
            let fontSize = size == 0 ? 15.0 : size
            
            var font: UIFont
            if stringIsEmpty(fontName) || UIFont(name: fontName!, size: fontSize) == nil {
                font = UIFont.systemFontOfSize(fontSize)
            } else {
                font = UIFont(name: fontName!, size: fontSize)!
            }
            fontCache.setObject(font, forKey: key)
            return font
        }
        return cachedFont
    }
    
    public func pointForKey(key: String) -> CGPoint {
        let pointX = floatForKey(key.stringByAppendingString("X"))
        let pointY = floatForKey(key.stringByAppendingString("Y"))
        return CGPointMake(pointX, pointY)
    }
    
    public func sizeForKey(key: String) -> CGSize {
        let width = floatForKey(key.stringByAppendingString("Width"))
        let height = floatForKey(key.stringByAppendingString("Height"))
        return CGSizeMake(width, height)
    }
    
    public func timeIntervalForKey(key: String) -> NSTimeInterval {
        return objectForKey(key) as? NSTimeInterval ?? 0.0
    }
    
    public func curveForKey(key: String) -> UIViewAnimationOptions {
        guard let curveString = stringForKey(key) else {
            return .CurveEaseInOut
        }
        let lowercaseString = curveString.lowercaseString
        
        if lowercaseString == "easeinout" {
            return .CurveEaseInOut
        } else if lowercaseString == "easeout" {
            return .CurveEaseOut
        } else if lowercaseString == "easein" {
            return .CurveEaseIn
        } else if lowercaseString == "linear" {
            return .CurveLinear
        }
        return .CurveEaseInOut
    }
    
    func animationSpecifierForKey(key: String) -> AnimationSpecifier {
        let duration = timeIntervalForKey(key.stringByAppendingString("Duration"))
        let delay = timeIntervalForKey(key.stringByAppendingString("Delay"))
        let curve = curveForKey(key.stringByAppendingString("Curve"))
        return AnimationSpecifier(delay: delay, duration: duration, curve: curve)
    }
    
    func textCaseForKey(key: String) -> TextCaseTransform {
        guard let string = stringForKey(key) else {
            return .None
        }
        let lowercaseString = string.lowercaseString
        
        if lowercaseString == "lowercase" {
            return .Lower
        } else if lowercaseString ==  "uppercase" {
            return .Upper
        }
        return .None
    }
    
    func textAlignmentForKey(key: String) -> NSTextAlignment {
        guard let string = stringForKey(key) else {
            return .Left
        }
        let lowercaseString = string.lowercaseString
        
        if lowercaseString == "center" {
            return .Center
        } else if lowercaseString == "right" {
            return .Right
        } else if lowercaseString == "natural" {
            return .Natural
        } else if lowercaseString == "justified" {
            return .Justified
        }
        return .Left
    }
    
    func animateWithAnimationSpecifierKey(animationSpecifierKey: String, animations: () -> Void, completion: ((Bool) -> Void)?) {
        let animationSpecifier = animationSpecifierForKey(animationSpecifierKey)
        UIView.animateWithDuration(animationSpecifier.duration,
            delay: animationSpecifier.delay,
            options: animationSpecifier.curve,
            animations: animations,
            completion: completion)
    }
}

