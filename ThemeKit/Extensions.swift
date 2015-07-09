//
//  Extensions.swift
//  ThemeKit
//
//  Created by Terry Lewis II on 7/4/15.
//  Copyright © 2015 Plover Productions. All rights reserved.
//

import UIKit

extension UIImage {
    class func _imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(ctx, color.CGColor)
        CGContextFillRect(ctx, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIView:ThemeableView {
    
    public var themableProperties:Set<String> {
        return Set(ThemableViewProperties.allValues.map{ $0.rawValue })
    }
    
    public func setPropertiesFromTheme(theme:Theme) {
        let globalString = theme.stringForKey("globalStyle") ?? ""
        let finalTheme = theme.themeByCombiningWithTheme(theme.innerThemeForKey(globalString))
        let ignoredProperties = Set(arrayLiteral: "fontSize", "globalStyle", "attributedTextAttributes")
        
        for k in finalTheme.keys {
            guard let  viewCase = ThemableViewProperties(rawValue: k) else {
                if ignoredProperties.contains(k) == false {
                    print("\(k) is not impelmented for class \(self.dynamicType)")
                }
                continue
            }
            switch viewCase {
            case .backgroundColor: backgroundColor = finalTheme.colorForKey(k)
            case .alpha: alpha = finalTheme.floatForKey(k)
            case .cornerRadius: layer.cornerRadius = finalTheme.floatForKey(k)
            case .borderWidth: layer.borderWidth = finalTheme.floatForKey(k)
            case .borderColor: layer.borderColor = finalTheme.colorForKey(k).CGColor
            case .tintColor: tintColor = finalTheme.colorForKey(k)
            case .clipsToBounds: clipsToBounds = finalTheme.boolForKey(k)
            case .shadowColor: layer.shadowColor = finalTheme.colorForKey(k).CGColor
            case .shadowOpacity: layer.shadowOpacity = Float(finalTheme.floatForKey(k))
            case .shadowRadius: layer.shadowRadius = finalTheme.floatForKey(k)
            }
        }
    }
}

public extension UILabel {
    override public var themableProperties:Set<String> {
        return Set(ThemableLabelProperties.allValues.map { $0.rawValue })
    }
    
    override public func setPropertiesFromTheme(theme: Theme) {
        let viewProperties = themableProperties
        super.setPropertiesFromTheme(theme.removeKeys(Array(viewProperties)))
        let globalString = theme.stringForKey("globalStyle") ?? ""
        let finalTheme = theme.themeByCombiningWithTheme(theme.innerThemeForKey(globalString))
        
        for k in viewProperties.intersect(finalTheme.keys) {
            guard let labelCase = ThemableLabelProperties(rawValue: k) else {
                continue
            }
            
            switch labelCase {
            case .font: font = finalTheme.fontForKey(k)
            case .textColor: textColor = finalTheme.colorForKey(k)
            case .text: text = finalTheme.stringForKey(k)
            case .textAlignment: textAlignment = finalTheme.textAlignmentForKey(k)
            case .attributedText: attributedText = finalTheme.attributedStringForKey(k)
            }
        }
    }
}

public extension UIButton {
    override public var themableProperties:Set<String> {
        return Set(ThemableButtonProperties.allValues.map { $0.rawValue })
    }
    
    override public func setPropertiesFromTheme(theme: Theme) {
        let properties = themableProperties
        let superTheme = theme.removeKeys(Array(properties))
        super.setPropertiesFromTheme(superTheme)
        titleLabel?.setPropertiesFromTheme(superTheme)
        
        let globalString = theme.stringForKey("globalStyle") ?? ""
        let finalTheme = theme.themeByCombiningWithTheme(theme.innerThemeForKey(globalString))
        
        for k in properties.intersect(finalTheme.keys) {
            guard let buttonCase = ThemableButtonProperties(rawValue: k) else {
                continue
            }
            
            switch buttonCase {
            case .titleForStateNormal: setTitle(finalTheme.stringForKey(k), forState: .Normal)
            case .titleForStateHighlighted: setTitle(finalTheme.stringForKey(k), forState: .Highlighted)
            case .titleForStateSelected: setTitle(finalTheme.stringForKey(k), forState: .Selected)
            case .titleForStateDisabled: setTitle(finalTheme.stringForKey(k), forState: .Disabled)
            case .titleColorForStateNormal: setTitleColor(finalTheme.colorForKey(k), forState: .Normal)
            case .titleColorForStateHighlighted: setTitleColor(finalTheme.colorForKey(k), forState: .Highlighted)
            case .titleColorForStateSelected: setTitleColor(finalTheme.colorForKey(k), forState: .Selected)
            case .titleColorForStateDisabled: setTitleColor(finalTheme.colorForKey(k), forState: .Disabled)
            case .titleShadowColorForStateNormal: setTitleShadowColor(finalTheme.colorForKey(k), forState: .Normal)
            case .titleShadowColorForStateHighlighted: setTitleShadowColor(finalTheme.colorForKey(k), forState: .Highlighted)
            case .titleShadowColorForStateSelected: setTitleShadowColor(finalTheme.colorForKey(k), forState: .Selected)
            case .titleShadowColorForStateDisabled: setTitleShadowColor(finalTheme.colorForKey(k), forState: .Disabled)
            case .imageForStateNormal: setImage(finalTheme.imageForKey(k), forState: .Normal)
            case .imageForStateHighlighted: setImage(finalTheme.imageForKey(k), forState: .Highlighted)
            case .imageForStateSelected: setImage(finalTheme.imageForKey(k), forState: .Selected)
            case .imageForStateDisabled: setImage(finalTheme.imageForKey(k), forState: .Disabled)
            case .backgroundImageForStateNormal: setBackgroundImage(finalTheme.imageForKey(k), forState: .Normal)
            case .backgroundImageForStateHighlighted: setBackgroundImage(finalTheme.imageForKey(k), forState: .Highlighted)
            case .backgroundImageForStateSelected: setBackgroundImage(finalTheme.imageForKey(k), forState: .Selected)
            case .backgroundImageForStateDisabled: setBackgroundImage(finalTheme.imageForKey(k), forState: .Disabled)
            case .backgroundColorForStateNormal: setBackgroundImage(UIImage._imageWithColor(finalTheme.colorForKey(k)), forState: .Normal)
            case .backgroundColorForStateHighlighted: setBackgroundImage(UIImage._imageWithColor(finalTheme.colorForKey(k)), forState: .Highlighted)
            case .backgroundColorForStateSelected: setBackgroundImage(UIImage._imageWithColor(finalTheme.colorForKey(k)), forState: .Selected)
            case .backgroundColorForStateDisabled: setBackgroundImage(UIImage._imageWithColor(finalTheme.colorForKey(k)), forState: .Disabled)
            }
        }
    }
}

public extension UIImageView {
    override public var themableProperties:Set<String> {
        return Set(ThemableImageViewProperties.allValues.map { $0.rawValue })
    }
    
    override public func setPropertiesFromTheme(theme: Theme) {
        let properties = themableProperties
        let superTheme = theme.removeKeys(Array(properties))
        super.setPropertiesFromTheme(superTheme)
        
        let globalString = theme.stringForKey("globalStyle") ?? ""
        let finalTheme = theme.themeByCombiningWithTheme(theme.innerThemeForKey(globalString))
        
        for k in properties.intersect(finalTheme.keys) {
            guard let imageCase = ThemableImageViewProperties(rawValue: k) else {
                continue
            }
            
            switch imageCase {
            case .image: image = finalTheme.imageForKey(k)
            case .highlightedImage: highlightedImage = finalTheme.imageForKey(k)
            case .highlighted: highlighted = finalTheme.boolForKey(k)
            }
        }
    }
}

public extension UITextField {
    override public var themableProperties:Set<String> {
        return Set(ThemableTextFieldProperties.allValues.map { $0.rawValue })
    }
    
    override public func setPropertiesFromTheme(theme: Theme) {
        let properties = themableProperties
        let superTheme = theme.removeKeys(Array(properties))
        super.setPropertiesFromTheme(superTheme)
        
        let globalString = theme.stringForKey("globalStyle") ?? ""
        let finalTheme = theme.themeByCombiningWithTheme(theme.innerThemeForKey(globalString))
        
        for k in properties.intersect(finalTheme.keys) {
            guard let textFieldCase = ThemableTextFieldProperties(rawValue: k) else {
                continue
            }
            
            switch textFieldCase {
            case .text: text = finalTheme.stringForKey(k)
            case .attributedText: attributedText = finalTheme.attributedStringForKey(k)
            case .placeholder: placeholder = finalTheme.stringForKey(k)
            case .attributedPlaceholder: attributedPlaceholder = finalTheme.attributedStringForKey(k)
            case .textAlignment: textAlignment = finalTheme.textAlignmentForKey(k)
            case .background: background = finalTheme.imageForKey(k)
            case .disabledBackground: disabledBackground = finalTheme.imageForKey(k)
            case .borderStyle: borderStyle = finalTheme.textFieldBorderStyleForKey(k)
            case .font: font = finalTheme.fontForKey(k)
            case .textColor: textColor = finalTheme.colorForKey(k)
            }
        }
    }
}

public extension UINavigationBar {
    override public var themableProperties:Set<String> {
        return Set(ThemableNavigationBarProperties.allValues.map { $0.rawValue })
    }
    
    override public func setPropertiesFromTheme(theme: Theme) {
        let properties = themableProperties
        let superTheme = theme.removeKeys(Array(properties))
        super.setPropertiesFromTheme(superTheme)
        
        let globalString = theme.stringForKey("globalStyle") ?? ""
        let finalTheme = theme.themeByCombiningWithTheme(theme.innerThemeForKey(globalString))
        
        for k in properties.intersect(finalTheme.keys) {
            guard let navigationBarCase = ThemableNavigationBarProperties(rawValue: k) else {
                continue
            }
            
            switch navigationBarCase {
            case .barTintColor: barTintColor = finalTheme.colorForKey(k)
            case .shadowImage: shadowImage = finalTheme.imageForKey(k)
            case .backIndicatorImage: backIndicatorImage = finalTheme.imageForKey(k)
            case .backIndicatorTransitionMaskImage: backIndicatorTransitionMaskImage = finalTheme.imageForKey(k)
            case .translucent: translucent = finalTheme.boolForKey(k)
            case .titleTextAttributes: titleTextAttributes = finalTheme.textAttributesDictionaryForKey(k)
            case .backgroundImageForBarMetricsDefault: setBackgroundImage(finalTheme.imageForKey(k), forBarMetrics: .Default)
            case .backgroundImageForBarMetricsCompact: setBackgroundImage(finalTheme.imageForKey(k), forBarMetrics: .Compact)
            }
        }
    }
}

public extension UITableView {
    override public var themableProperties:Set<String> {
        return Set(ThemableTableViewProperties.allValues.map { $0.rawValue })
    }
    
    override public func setPropertiesFromTheme(theme: Theme) {
        let properties = themableProperties
        let superTheme = theme.removeKeys(Array(properties))
        super.setPropertiesFromTheme(superTheme)
        
        let globalString = theme.stringForKey("globalStyle") ?? ""
        let finalTheme = theme.themeByCombiningWithTheme(theme.innerThemeForKey(globalString))
        
        for k in properties.intersect(finalTheme.keys) {
            guard let tableViewCase = ThemableTableViewProperties(rawValue: k) else {
                continue
            }
            
            switch tableViewCase {
            case .separatorColor: separatorColor = finalTheme.colorForKey(k)
            case .separatorInset: separatorInset = finalTheme.edgeInsetsForKey(k)
            case .separatorStyle: separatorStyle = finalTheme.tableViewSeparatorStyleForKey(k)
            case .rowHeight: rowHeight = finalTheme.floatForKey(k)
            }
        }
    }
}



