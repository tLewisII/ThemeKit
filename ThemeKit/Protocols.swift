//
//  Protocols.swift
//  ThemeKit
//
//  Created by Terry Lewis II on 7/4/15.
//  Copyright © 2015 Plover Productions. All rights reserved.
//

import UIKit

public protocol Themable:AnyObject {
    func registerForThemeChanges()
    func applyTheme()
    var currentTheme:Theme? { get }
    var themeFileName:String? { get }
    var themeName:String? { get }
}

protocol ThemableProperties:Hashable {
    static var allValues:Set<Self> { get }
}

public protocol ThemeableView {
    func setPropertiesFromTheme(theme:Theme)
    var themableProperties:Set<String> { get }
}

public extension Themable {
    public func registerForThemeChanges() {
        let queue = NSOperationQueue.mainQueue()
        let name = ThemeWatcher.THEME_WATCHER_UPDATED_NOTIFICATION
        NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: queue) {[weak self] _ -> Void in
            self?.applyTheme()
        }
    }
    
    public func applyTheme() {
        guard let theme = currentTheme else {
            return
        }
        
        let mirror = Mirror(reflecting: self)
        
        if let vc = self as? UIViewController, vcView = vc.view, vcViewTheme = theme.innerThemeForKey("view") {
            vcView.setPropertiesFromTheme(vcViewTheme)
        }
        
        if let vc = self as? UIViewController, navController = vc.navigationController,  navBarTheme = theme.innerThemeForKey("navigationBar") {
            navController.navigationBar.setPropertiesFromTheme(navBarTheme)
        }
        
        for case let(label?, value) in mirror.children {
            guard let innerTheme = theme.innerThemeForKey(label), themeable = value as? ThemeableView else {
                continue
            }
            
            themeable.setPropertiesFromTheme(innerTheme)
        }
    }
    
    public var currentTheme:Theme? {
        let ref = reflect(self)
        let typeString = String(ref.valueType)
        let chars = typeString.characters
        // remove module name
        let defaultThemeName = chars.indexOf(".").map { typeString.substringFromIndex($0.successor()) }
        
        let fileName = themeFileName ?? NSProcessInfo.processInfo().environment["ThemeFileName"] ?? ""
        let name = themeName ?? defaultThemeName ?? ""
        return Theme.themeNamed(name, themeFileName: fileName)
    }
    
    var themeFileName:String? {
        get {
            return nil
        }
    }
    
    var themeName:String? {
        get {
            return nil
        }
    }
}



