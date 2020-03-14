//
//  OAuthAuthorizer.swift
//  Reddit
//
//  Created by Adam Gastineau on 3/14/20.
//  Copyright © 2020 Adam Gastineau. All rights reserved.
//

import AppKit
import OAuth2

class CustomSheetAuthorizer : OAuth2Authorizer {
    override func presentableAuthorizeViewController(at url: URL) throws -> OAuth2WebViewController {
        let result = try super.presentableAuthorizeViewController(at: url)
        result.view.setFrameSize(NSSize(width: 840, height: 500))
        return result
    }
}
