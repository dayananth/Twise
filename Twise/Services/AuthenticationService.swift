//
//  AuthenticationService.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//
import OAuthSwift

class AuthenticationService: NSObject {

    private let consumerKey = "PkKRNdwGbnsgLdXZUCX0kzVwI"
    private let consumerSecret = "yAmiuVRHF1NBNDj2zOeBLWewempeQt10QeHhcZvzIRMG0mlsck"
    private var _authenticatedClient: OAuthClient?

    func authenticatedClient() -> OAuthClient {
        if let authClient = _authenticatedClient  {
            return authClient
        } else {
            let authClient = OAuthClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: "", accessTokenSecret: "")
            _authenticatedClient = authClient
            return authClient
        }
    }

    func OAuth1(requestTokenUrl: String, authorizeUrl: String, accessTokenUrl: String) -> OAuth1Swift {
        return OAuth1Swift(consumerKey: consumerKey, consumerSecret: consumerSecret, requestTokenUrl: requestTokenUrl, authorizeUrl: authorizeUrl, accessTokenUrl: accessTokenUrl  )
    }

}
