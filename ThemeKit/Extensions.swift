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
            case .BackgroundColor: self.backgroundColor = finalTheme.colorForKey(k)
            case .Alpha: self.alpha = finalTheme.floatForKey(k)
            case .CornerRadius: self.layer.cornerRadius = finalTheme.floatForKey(k)
            case .BorderWidth: self.layer.borderWidth = finalTheme.floatForKey(k)
            case .BorderColor: self.layer.borderColor = finalTheme.colorForKey(k).CGColor
            case .TintColor: self.tintColor = finalTheme.colorForKey(k)
            case .ClipsToBounds: self.clipsToBounds = finalTheme.boolForKey(k)
            case .ShadowColor: layer.shadowColor = finalTheme.colorForKey(k).CGColor
            case .ShadowOpacity: layer.shadowOpacity = Float(finalTheme.floatForKey(k))
            case .ShadowRadius: layer.shadowRadius = finalTheme.floatForKey(k)
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
            case .Font: self.font = finalTheme.fontForKey(k)
            case .TextColor: self.textColor = finalTheme.colorForKey(k)
            case .Text: self.text = finalTheme.stringForKey(k)
            case .TextAlignment: self.textAlignment = finalTheme.textAlignmentForKey(k)
            case .AttributedText: attributedText = finalTheme.attributedStringForKey(k)
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
        self.titleLabel?.setPropertiesFromTheme(superTheme)
        
        let globalString = theme.stringForKey("globalStyle") ?? ""
        let finalTheme = theme.themeByCombiningWithTheme(theme.innerThemeForKey(globalString))
        
        for k in properties.intersect(finalTheme.keys) {
            guard let buttonCase = ThemableButtonProperties(rawValue: k) else {
                continue
            }
            
            switch buttonCase {
            case .TitleForStateNormal: setTitle(finalTheme.stringForKey(k), forState: .Normal)
            case .TitleForStateHighlighted: setTitle(finalTheme.stringForKey(k), forState: .Highlighted)
            case .TitleForStateSelected: setTitle(finalTheme.stringForKey(k), forState: .Selected)
            case .TitleForStateDisabled: setTitle(finalTheme.stringForKey(k), forState: .Disabled)
            case .TitleColorForStateNormal: setTitleColor(finalTheme.colorForKey(k), forState: .Normal)
            case .TitleColorForStateHighlighted: setTitleColor(finalTheme.colorForKey(k), forState: .Highlighted)
            case .TitleColorForStateSelected: setTitleColor(finalTheme.colorForKey(k), forState: .Selected)
            case .TitleColorForStateDisabled: setTitleColor(finalTheme.colorForKey(k), forState: .Disabled)
            case .TitleShadowColorForStateNormal: setTitleShadowColor(finalTheme.colorForKey(k), forState: .Normal)
            case .TitleShadowColorForStateHighlighted: setTitleShadowColor(finalTheme.colorForKey(k), forState: .Highlighted)
            case .TitleShadowColorForStateSelected: setTitleShadowColor(finalTheme.colorForKey(k), forState: .Selected)
            case .TitleShadowColorForStateDisabled: setTitleShadowColor(finalTheme.colorForKey(k), forState: .Disabled)
            case .ImageForStateNormal: setImage(finalTheme.imageForKey(k), forState: .Normal)
            case .ImageForStateHighlighted: setImage(finalTheme.imageForKey(k), forState: .Highlighted)
            case .ImageForStateSelected: setImage(finalTheme.imageForKey(k), forState: .Selected)
            case .ImageForStateDisabled: setImage(finalTheme.imageForKey(k), forState: .Disabled)
            case .BackgroundImageForStateNormal: setBackgroundImage(finalTheme.imageForKey(k), forState: .Normal)
            case .BackgroundImageForStateHighlighted: setBackgroundImage(finalTheme.imageForKey(k), forState: .Highlighted)
            case .BackgroundImageForStateSelected: setBackgroundImage(finalTheme.imageForKey(k), forState: .Selected)
            case .BackgroundImageForStateDisabled: setBackgroundImage(finalTheme.imageForKey(k), forState: .Disabled)
            case .BackgroundColorForStateNormal: setBackgroundImage(UIImage._imageWithColor(finalTheme.colorForKey(k)), forState: .Normal)
            case .BackgroundColorForStateHighlighted: setBackgroundImage(UIImage._imageWithColor(finalTheme.colorForKey(k)), forState: .Highlighted)
            case .BackgroundColorForStateSelected: setBackgroundImage(UIImage._imageWithColor(finalTheme.colorForKey(k)), forState: .Selected)
            case .BackgroundColorForStateDisabled: setBackgroundImage(UIImage._imageWithColor(finalTheme.colorForKey(k)), forState: .Disabled)
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
            case .Image: image = finalTheme.imageForKey(k)
            case .HighlightedImage: highlightedImage = finalTheme.imageForKey(k)
            case .Highlighted: highlighted = finalTheme.boolForKey(k)
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
            case .Text: text = finalTheme.stringForKey(k)
            case .AttributedText: attributedText = finalTheme.attributedStringForKey(k)
            case .Placeholder: placeholder = finalTheme.stringForKey(k)
            case .AttributedPlaceholder: attributedPlaceholder = finalTheme.attributedStringForKey(k)
            case .TextAlignment: textAlignment = finalTheme.textAlignmentForKey(k)
            case .Background: background = finalTheme.imageForKey(k)
            case .DisabledBackground: disabledBackground = finalTheme.imageForKey(k)
            case .BorderStyle: borderStyle = finalTheme.textFieldBorderStyleForKey(k)
            case .Font: font = finalTheme.fontForKey(k)
            case .TextColor: textColor = finalTheme.colorForKey(k)
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
            case .BarTintColor: barTintColor = finalTheme.colorForKey(k)
            case .ShadowImage: shadowImage = finalTheme.imageForKey(k)
            case .BackIndicatorImage: backIndicatorImage = finalTheme.imageForKey(k)
            case .BackIndicatorTransitionMaskImage: backIndicatorTransitionMaskImage = finalTheme.imageForKey(k)
            case .Translucent: translucent = finalTheme.boolForKey(k)
            case .TitleTextAttributes: titleTextAttributes = finalTheme.textAttributesDictionaryForKey(k)
            case .BackgroundImageForBarMetricsDefault: setBackgroundImage(finalTheme.imageForKey(k), forBarMetrics: .Default)
            case .BackgroundImageForBarMetricsCompact: setBackgroundImage(finalTheme.imageForKey(k), forBarMetrics: .Compact)
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
            case .SeparatorColor: separatorColor = finalTheme.colorForKey(k)
            case .SeparatorInset: separatorInset = finalTheme.edgeInsetsForKey(k)
            case .SeparatorStyle: separatorStyle = finalTheme.tableViewSeparatorStyleForKey(k)
            case .RowHeight: rowHeight = finalTheme.floatForKey(k)
            }
        }
    }
}



