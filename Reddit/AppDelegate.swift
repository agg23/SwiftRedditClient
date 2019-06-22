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
    let viewController = ListingViewController<Link, LinkTableViewRow>()
    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window.minSize = NSSize(width: 600, height: 400)
        window.contentViewController = viewController
        
        firstly { () -> Promise<Listing<Link>> in
            self.viewController.showSpinner()
//            self.subreddit = subreddit
            return RedditAPI.shared.request(from: .subreddit("programming", type: .hot))
        }.done { (data) in
            self.viewController.data = data.children
            self.viewController.reloadTable()
            self.viewController.hideSpinner()
        }.catch { (error) in
            print(error)
        }
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

