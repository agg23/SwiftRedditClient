//
//  OAuthManager.swift
//  Reddit
//
//  Created by Adam Gastineau on 6/16/19.
//  Copyright © 2019 Adam Gastineau. All rights reserved.
//

import OAuth2
import Moya

struct OAuthManager {
    static let shared = OAuthManager()
    
//    var sessionM
    
    var redditOAuth = OAuth2CodeGrant(settings: [
        "client_id": "93syVA-O7Gn6Vg",
        "client_secret": "",
        "authorize_uri": "https://www.reddit.com/api/v1/authorize",
        "token_uri": "https://www.reddit.com/api/v1/access_token",
        "redirect_uris": ["reddit://oauth"],
        "scope": "identity,edit,flair, modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread",
        "keychain": true,         // if you DON'T want keychain integration
        "parameters": ["response_type": "code", "duration": "permanent"],
        ] as OAuth2JSON)
}
