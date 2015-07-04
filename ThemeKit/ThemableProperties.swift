//
//  ThemableProperties.swift
//  ThemeKit
//
//  Created by Terry Lewis II on 7/4/15.
//  Copyright © 2015 Plover Productions. All rights reserved.
//

public enum ThemableViewProperties:String, ThemableProperties {
    case BackgroundColor = "backgroundColor"
    case Alpha = "alpha"
    case CornerRadius = "cornerRadius"
    case BorderColor = "borderColor"
    case BorderWidth = "borderWidth"
    case TintColor = "tintColor"
    case ClipsToBounds = "clipsToBounds"
    case ShadowRadius = "shadowRadius"
    case ShadowColor = "shadowColor"
    case ShadowOpacity = "shadowOpacity"
    
    static var allValues:Set<ThemableViewProperties> {
        let vals = [
            BackgroundColor,
            Alpha,
            CornerRadius,
            BorderColor,
            BorderWidth,
            TintColor,
            ClipsToBounds,
            ShadowRadius,
            ShadowColor,
            ShadowOpacity
        ]
        
        return Set(vals)
    }
    
    public var hashValue:Int {
        return 1
    }
}

public enum ThemableLabelProperties:String, ThemableProperties {
    case Font = "font"
    case TextColor = "textColor"
    case Text = "text"
    case TextAlignment = "textAlignment"
    case AttributedText = "attributedText"
    
    static var allValues:Set<ThemableLabelProperties> {
        return Set([Font,TextColor,Text,TextAlignment,AttributedText])
    }
}

public enum ThemableButtonProperties:String, ThemableProperties {
    case TitleForStateNormal = "titleForStateNormal"
    case TitleForStateHighlighted = "titleForStateHighlighted"
    case TitleForStateSelected = "titleForStateSelected"
    case TitleForStateDisabled = "titleForStateDisabled"
    case TitleColorForStateNormal = "titleColorForStateNormal"
    case TitleColorForStateHighlighted = "titleColorForStateHighlighted"
    case TitleColorForStateSelected = "titleColorForStateSelected"
    case TitleColorForStateDisabled = "titleColorForStateDisabled"
    case TitleShadowColorForStateNormal = "titleShadowColorForStateNormal"
    case TitleShadowColorForStateHighlighted = "titleShadowColorForStateHighlighted"
    case TitleShadowColorForStateSelected = "titleShadowColorForStateSelected"
    case TitleShadowColorForStateDisabled = "titleShadowColorForStateDisabled"
    case ImageForStateNormal = "imageForStateNormal"
    case ImageForStateHighlighted = "imageForStateHighlighted"
    case ImageForStateSelected = "imageForStateSelected"
    case ImageForStateDisabled = "imageForStateDisabled"
    case BackgroundImageForStateNormal = "backgroundImageForStateNormal"
    case BackgroundImageForStateHighlighted = "backgroundImageForStateHighlighted"
    case BackgroundImageForStateSelected = "backgroundImageForStateSelected"
    case BackgroundImageForStateDisabled = "backgroundImageForStateDisabled"
    case BackgroundColorForStateNormal = "backgroundColorForStateNormal"
    case BackgroundColorForStateHighlighted = "backgroundColorForStateHighlighted"
    case BackgroundColorForStateSelected = "backgroundColorForStateSelected"
    case BackgroundColorForStateDisabled = "backgroundColorForStateDisabled"
    
    static var allValues:Set<ThemableButtonProperties> {
        let vals = [
            TitleForStateNormal,
            TitleForStateHighlighted,
            TitleForStateSelected,
            TitleForStateDisabled,
            TitleColorForStateNormal,
            TitleColorForStateHighlighted,
            TitleColorForStateSelected,
            TitleColorForStateDisabled,
            TitleShadowColorForStateNormal,
            TitleShadowColorForStateHighlighted,
            TitleShadowColorForStateSelected,
            TitleShadowColorForStateDisabled,
            ImageForStateNormal,
            ImageForStateHighlighted,
            ImageForStateSelected,
            ImageForStateDisabled,
            BackgroundImageForStateNormal,
            BackgroundImageForStateHighlighted,
            BackgroundImageForStateSelected,
            BackgroundImageForStateDisabled,
            BackgroundColorForStateNormal,
            BackgroundColorForStateHighlighted,
            BackgroundColorForStateSelected,
            BackgroundColorForStateDisabled
        ]
        return Set(vals)
    }
}

public enum ThemableImageViewProperties:String, ThemableProperties {
    case Image = "image"
    case HighlightedImage = "highlightedImage"
    case Highlighted = "highlighted"
    
    static var allValues:Set<ThemableImageViewProperties> {
        return Set([Image,HighlightedImage,Highlighted])
    }
}

public enum ThemableTextFieldProperties:String, ThemableProperties {
    case Text = "text"
    case AttributedText = "attributedText"
    case Placeholder = "placeholder"
    case AttributedPlaceholder = "attributedPlaceholder"
    case Font = "font"
    case TextColor = "textColor"
    case TextAlignment = "textAlignment"
    case BorderStyle = "borderStyle"
    case Background = "background"
    case DisabledBackground = "disabledBackground"
    
    static var allValues:Set<ThemableTextFieldProperties> {
        return Set([Text,AttributedText,AttributedPlaceholder,Placeholder,Font,TextAlignment,TextColor,BorderStyle,Background,DisabledBackground])
    }
}

public enum ThemableNavigationBarProperties:String, ThemableProperties {
    case BarTintColor = "barTintColor"
    case ShadowImage = "shadowImage"
    case BackIndicatorImage = "backIndicatorImage"
    case BackIndicatorTransitionMaskImage = "backIndicatorTransitionMaskImage"
    case Translucent = "translucent"
    case TitleTextAttributes = "titleTextAttributes"
    case BackgroundImageForBarMetricsDefault = "backgroundImageForBarMetricsDefault"
    case BackgroundImageForBarMetricsCompact = "backgroundImageForBarMetricsCompact"
    
    static var allValues:Set<ThemableNavigationBarProperties> {
        return Set([BarTintColor,ShadowImage,BackIndicatorImage,BackIndicatorTransitionMaskImage,Translucent,TitleTextAttributes,BackgroundImageForBarMetricsDefault,BackgroundImageForBarMetricsCompact])
    }
}


public enum ThemableTableViewProperties:String, ThemableProperties {
    case RowHeight = "rowHeight"
    case SeparatorColor = "separatorColor"
    case SeparatorStyle = "separatorStyle"
    case SeparatorInset = "separatorInset"
    
    static var allValues:Set<ThemableTableViewProperties> {
        return Set([RowHeight,SeparatorColor,SeparatorStyle,SeparatorInset])
    }
}





