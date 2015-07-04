//
//  ThemeWatcher.swift
//  ThemeKit
//
//  Created by Terry Lewis II on 7/4/15.
//  Copyright © 2015 Plover Productions. All rights reserved.
//

import Foundation

public class ThemeWatcher {
    private var path:String?
    private var themeFileName:String?
    private var source:dispatch_source_t?
    
    public class var THEME_WATCHER_UPDATED_NOTIFICATION:String {
        return "theme-watcher-updated"
    }
    
    public static let sharedInstance = ThemeWatcher()
    
    public init() {
        let env = NSProcessInfo.processInfo().environment
        guard let path = env["ThemePath"] else {
            print("ThemePath argument not set as in environment variable, cannot monitor theme for changes")
            return
        }
        
        self.path = path
        self.themeFileName = path.lastPathComponent
    }
    
    private func reloadTheme() {
        guard let themeFileName = self.themeFileName, path = self.path else {
            return
        }
        
        let urls = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        let first = urls[0]
        let writePath = first.stringByAppendingPathComponent(themeFileName)
        
        do {
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(writePath) {
                try fileManager.removeItemAtPath(writePath)
            }
            try fileManager.copyItemAtPath(path, toPath: writePath)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(ThemeWatcher.THEME_WATCHER_UPDATED_NOTIFICATION, object: nil)
            })
        } catch {
            print(error)
        }
    }
    
    public func watch() {
        guard let path = self.path, filePath = NSURL(fileURLWithPath: path).path?.fileSystemRepresentation() else {
            return
        }
        
        let fileDescriptor = open(filePath, O_EVTONLY)
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        source = dispatch_source_create(
            DISPATCH_SOURCE_TYPE_VNODE,
            UInt(fileDescriptor),
            DISPATCH_VNODE_DELETE
                | DISPATCH_VNODE_EXTEND
                | DISPATCH_VNODE_LINK
                | DISPATCH_VNODE_RENAME
                | DISPATCH_VNODE_REVOKE
                | DISPATCH_VNODE_WRITE,
            queue)
        
        
        dispatch_source_set_event_handler(source!, { () -> Void in
            self.reloadTheme()
            dispatch_source_cancel(self.source!)
        })
        
        dispatch_source_set_cancel_handler(source!, { () -> Void in
            close(Int32(fileDescriptor))
            self.source = nil
            self.watch()
        })
        
        dispatch_resume(source!)
    }
}

