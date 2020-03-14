//
//  AppDelegate.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Cocoa
import PromiseKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let viewController = MainViewController()
    @IBOutlet weak var window: NSWindow!

    func applicationWillFinishLaunching(_ notification: Notification) {
        window.titleVisibility = .hidden
        
        window.minSize = NSSize(width: 1000, height: 700)
        window.contentViewController = viewController
        
        window.toolbar = ToolbarController.shared.toolbar
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        RedditAPI.shared.shouldAuthenticate = true
        RedditAPI.shared.authenticationWindow = window
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            debugPrint("URL received: \(String(describing: url.host))")
            if (url.host == "oauth") {
                debugPrint("Handling oauth at: \(url)")
                OAuthManager.shared.redditOAuth.handleRedirectURL(url)
            }
        }
    }
}

