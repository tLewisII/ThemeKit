//
//  ThemableProperties.swift
//  ThemeKit
//
//  Created by Terry Lewis II on 7/4/15.
//  Copyright © 2015 Plover Productions. All rights reserved.
//

public enum ThemableViewProperties:String, ThemableProperties {
    case backgroundColor
    case alpha
    case cornerRadius
    case borderColor
    case borderWidth
    case tintColor
    case clipsToBounds
    case shadowRadius
    case shadowColor
    case shadowOpacity
    
    static var allValues:Set<ThemableViewProperties> {
        let vals = [
            backgroundColor,
            alpha,
            cornerRadius,
            borderColor,
            borderWidth,
            tintColor,
            clipsToBounds,
            shadowRadius,
            shadowColor,
            shadowOpacity
        ]
        
        return Set(vals)
    }
    
    public var hashValue:Int {
        return 1
    }
}

public enum ThemableLabelProperties:String, ThemableProperties {
    case font
    case textColor
    case text
    case textAlignment
    case attributedText
    
    static var allValues:Set<ThemableLabelProperties> {
        return Set([font,textColor,text,textAlignment,attributedText])
    }
}

public enum ThemableButtonProperties:String, ThemableProperties {
    case titleForStateNormal
    case titleForStateHighlighted
    case titleForStateSelected
    case titleForStateDisabled
    case titleColorForStateNormal
    case titleColorForStateHighlighted
    case titleColorForStateSelected
    case titleColorForStateDisabled
    case titleShadowColorForStateNormal
    case titleShadowColorForStateHighlighted
    case titleShadowColorForStateSelected
    case titleShadowColorForStateDisabled
    case imageForStateNormal
    case imageForStateHighlighted
    case imageForStateSelected
    case imageForStateDisabled
    case backgroundImageForStateNormal
    case backgroundImageForStateHighlighted
    case backgroundImageForStateSelected
    case backgroundImageForStateDisabled
    case backgroundColorForStateNormal
    case backgroundColorForStateHighlighted
    case backgroundColorForStateSelected
    case backgroundColorForStateDisabled
    
    static var allValues:Set<ThemableButtonProperties> {
        let vals = [
            titleForStateNormal,
            titleForStateHighlighted,
            titleForStateSelected,
            titleForStateDisabled,
            titleColorForStateNormal,
            titleColorForStateHighlighted,
            titleColorForStateSelected,
            titleColorForStateDisabled,
            titleShadowColorForStateNormal,
            titleShadowColorForStateHighlighted,
            titleShadowColorForStateSelected,
            titleShadowColorForStateDisabled,
            imageForStateNormal,
            imageForStateHighlighted,
            imageForStateSelected,
            imageForStateDisabled,
            backgroundImageForStateNormal,
            backgroundImageForStateHighlighted,
            backgroundImageForStateSelected,
            backgroundImageForStateDisabled,
            backgroundColorForStateNormal,
            backgroundColorForStateHighlighted,
            backgroundColorForStateSelected,
            backgroundColorForStateDisabled
        ]
        return Set(vals)
    }
}

public enum ThemableImageViewProperties:String, ThemableProperties {
    case image
    case highlightedImage
    case highlighted
    
    static var allValues:Set<ThemableImageViewProperties> {
        return Set([image,highlightedImage,highlighted])
    }
}

public enum ThemableTextFieldProperties:String, ThemableProperties {
    case text
    case attributedText
    case placeholder
    case attributedPlaceholder
    case font
    case textColor
    case textAlignment
    case borderStyle
    case background
    case disabledBackground
    
    static var allValues:Set<ThemableTextFieldProperties> {
        return Set([
            text,
            attributedText,
            attributedPlaceholder,
            placeholder,
            font,
            textAlignment,
            textColor,
            borderStyle,
            background,
            disabledBackground])
    }
}

public enum ThemableNavigationBarProperties:String, ThemableProperties {
    case barTintColor
    case shadowImage
    case backIndicatorImage
    case backIndicatorTransitionMaskImage
    case translucent
    case titleTextAttributes
    case backgroundImageForBarMetricsDefault
    case backgroundImageForBarMetricsCompact
    
    static var allValues:Set<ThemableNavigationBarProperties> {
        return Set([barTintColor,
            shadowImage,
            backIndicatorImage,
            backIndicatorTransitionMaskImage,
            translucent,
            titleTextAttributes,
            backgroundImageForBarMetricsDefault,
            backgroundImageForBarMetricsCompact])
    }
}


public enum ThemableTableViewProperties:String, ThemableProperties {
    case rowHeight
    case separatorColor
    case separatorStyle
    case separatorInset
    
    static var allValues:Set<ThemableTableViewProperties> {
        return Set([rowHeight,separatorColor,separatorStyle,separatorInset])
    }
}

public enum ThemableSwitchProperties:String, ThemableProperties {
    case on
    case onTintColor
    case tintColor
    case thumbTintColor
    case onImage
    case offImage
    
    static var allValues:Set<ThemableSwitchProperties> {
        return Set([
            on,
            onTintColor,
            tintColor,
            thumbTintColor,
            onImage,
            offImage
            ])
    }
}





