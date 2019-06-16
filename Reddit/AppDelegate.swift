//
//  AppDelegate.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import Cocoa
import Moya

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let provider = MoyaProvider<RedditAPI>()

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        provider.request(.getSubreddit("programming")) { (result) in
            do {
                let response = try result.get()
                let objectResponse = try response.map(Listing<Link>.self)
                
                print(objectResponse)
            } catch {
                print(error)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

