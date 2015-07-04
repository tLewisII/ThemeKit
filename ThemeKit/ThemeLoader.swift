//
//  ThemeLoader.swift
//  ThemeKit
//
//  Created by Terry Lewis II on 7/4/15.
//  Copyright © 2015 Plover Productions. All rights reserved.
//


class ThemeLoader {
    var defaultTheme: Theme?
    var themes: [Theme] = []
    
    init(themeFilename filename: String) {
        let urls = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        let first = urls[0]
        let documentsDirPath = first.stringByAppendingPathComponent(filename + ".plist")
        
        let bundlePath = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")
        
        let pathToRead = NSFileManager.defaultManager().fileExistsAtPath(documentsDirPath) ? documentsDirPath : bundlePath
        if let goodPath = pathToRead, themesDictionary = NSDictionary(contentsOfFile:goodPath) {
            
            for key in themesDictionary.allKeys as! [String] {
                let themeDictionary = themesDictionary[key] as! NSDictionary
                let theme = Theme(fromDictionary: themeDictionary, name:key)
                if key.lowercaseString == "default" {
                    defaultTheme = theme
                }
                themes.append(theme)
            }
            
            for oneTheme in themes where oneTheme != defaultTheme {
                oneTheme.parentTheme = defaultTheme
            }
        }
    }
    
    func themeNamed(themeName: String) -> Theme? {
        return themes.filter { $0.name == themeName }.first
    }
}
