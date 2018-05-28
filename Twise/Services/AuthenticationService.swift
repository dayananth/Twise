//
//  AuthenticationService.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//
import OAuthSwift
import KeychainAccess

enum AuthenticationServiceConstants {
    static let keyChainServiceName = "com.twise.tokenService"
    static let keyChainAccessTokenKey = "com.twise.accessToken"
    static let keyChainAccessTokenSecretKey = "com.twise.accessTokenSecret"
    static let isAuthenticated = "isAuthenticated"
}

enum AuthenticationResponse {
    case success
    case failure
}

typealias AuthorizeSuccessCallback = (AuthenticationResponse) -> Void
typealias AuthorizeFailureCallback = (OAuthSwiftError) -> Void

protocol AuthenticationServiceProtocol {

    /// Function that returns client with OAuth tokens set
    ///
    /// - Returns: OAuthClient
    func authenticatedClient() -> OAuthClient?

    /// OAuth1Swift object that helps getting the accessTokens
    ///
    /// - Parameters:
    ///   - requestTokenUrl: OAuth request token url ex: https://api.twitter.com/oauth/request_token
    ///   - authorizeUrl: OAuth authorization url ex: https://api.twitter.com/oauth/authorize
    ///   - accessTokenUrl: access token url to retrieve for further communications ex: https://api.twitter.com/oauth/access_token
    /// - Returns: OAuth1Swift Object
    func OAuth1(requestTokenUrl: String, authorizeUrl: String, accessTokenUrl: String) -> OAuth1Swift

    /// function to store authentication keys in KeyChain access
    ///
    /// - Parameter credential: OAuthSwiftCredential containing access keys
    func authenticationSucceeded(with credential: OAuthSwiftCredential )

    /// Function to remove the stored keys after user logged out for example.
    func removeAccessTokens()


    /// The function that authorizes the user with the consumerKey and consumerSecretKey
    ///
    /// - Parameters:
    ///   - oAuthBaseURL: Base url string for oauth for ex: https://api.twitter.com/oauth
    ///   - callbackURL: the client app url to be called back
    ///   - success: success callback to be executed after the successful authorization
    ///   - failure: success callback to be executed after the failed authorization
    func authorize(with oAuthBaseURL: String, callbackURL: URL, success: @escaping AuthorizeSuccessCallback, failure: @escaping AuthorizeFailureCallback)
}

class AuthenticationService: AuthenticationServiceProtocol {

    private let consumerKey = "PkKRNdwGbnsgLdXZUCX0kzVwI"
    private let consumerSecret = "yAmiuVRHF1NBNDj2zOeBLWewempeQt10QeHhcZvzIRMG0mlsck"
    private var _authenticatedClient: OAuthClient?
    private let keychain = Keychain(service: AuthenticationServiceConstants.keyChainServiceName)

    var oauthswift: OAuthSwift?

    func authenticatedClient() -> OAuthClient? {
        if let authClient = _authenticatedClient  {
            return authClient
        } else {
            guard let accessToken = keychain[AuthenticationServiceConstants.keyChainAccessTokenKey],
                let accessTokenSecret = keychain[AuthenticationServiceConstants.keyChainAccessTokenSecretKey] else {
                    return nil
            }

            let authClient = OAuthClient(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: accessToken, accessTokenSecret: accessTokenSecret)
            _authenticatedClient = authClient
            return authClient
        }
    }

    func OAuth1(requestTokenUrl: String, authorizeUrl: String, accessTokenUrl: String) -> OAuth1Swift {
        return OAuth1Swift(consumerKey: consumerKey, consumerSecret: consumerSecret, requestTokenUrl: requestTokenUrl, authorizeUrl: authorizeUrl, accessTokenUrl: accessTokenUrl  )
    }

    func authenticationSucceeded(with credential: OAuthSwiftCredential ) {
        keychain[AuthenticationServiceConstants.keyChainAccessTokenKey] = credential.oauthToken
        keychain[AuthenticationServiceConstants.keyChainAccessTokenSecretKey] = credential.oauthTokenSecret
        UserDefaults.standard.set(true, forKey: AuthenticationServiceConstants.isAuthenticated)
    }

    func removeAccessTokens() {
        keychain[AuthenticationServiceConstants.keyChainAccessTokenKey] = nil
        keychain[AuthenticationServiceConstants.keyChainAccessTokenSecretKey] = nil
        UserDefaults.standard.set(false, forKey: AuthenticationServiceConstants.isAuthenticated)
    }

    func isAuthenticated() -> Bool {
        return UserDefaults.standard.bool(forKey: AuthenticationServiceConstants.isAuthenticated)
    }

    func authorize(with oAuthBaseURL: String, callbackURL: URL, success: @escaping AuthorizeSuccessCallback, failure: @escaping AuthorizeFailureCallback) {

        let requestTokenUrl = oAuthBaseURL + "/request_token"
        let authorizeUrl = oAuthBaseURL + "/authorize"
        let accessTokenUrl = oAuthBaseURL + "/access_token"

        guard let callbackURL = URL(string: Constants.applicationBaseURL + "oauth-callback") else {
            return
        }

        let oAuth1 = OAuth1Swift(consumerKey: consumerKey, consumerSecret: consumerSecret, requestTokenUrl: requestTokenUrl, authorizeUrl: authorizeUrl, accessTokenUrl: accessTokenUrl  )

        self.oauthswift = oAuth1

        oAuth1.authorize(withCallbackURL: callbackURL, success: { [weak self ]  (credential, response, parameters) in
            if let `self` = self {
                self.authenticationSucceeded(with: credential)
            }
            success(.success)
            }, failure:{ error in
                failure(error)
        })
    }


    func authorize(with callbackURL: URL, success: @escaping AuthorizeSuccessCallback, failure: @escaping AuthorizeFailureCallback) {

        let requestTokenUrl = BaseURL.twitterAPIBaseURL + "/oauth/request_token"
        let authorizeUrl = BaseURL.twitterAPIBaseURL + "/oauth/authorize"
        let accessTokenUrl = BaseURL.twitterAPIBaseURL + "/oauth/access_token"

        guard let callbackURL = URL(string: Constants.applicationBaseURL + "oauth-callback") else {
            return
        }

        let oAuth1 = OAuth1Swift(consumerKey: consumerKey, consumerSecret: consumerSecret, requestTokenUrl: requestTokenUrl, authorizeUrl: authorizeUrl, accessTokenUrl: accessTokenUrl  )

        self.oauthswift = oAuth1
        
        oAuth1.authorize(withCallbackURL: callbackURL, success: { [weak self ]  (credential, response, parameters) in
//            if let `self` = self {
//                self.authenticationSucceeded(with: credential)
//            }
            self?.authenticationSucceeded(with: credential)
            success(.success)
            }, failure:{ error in
                failure(error)
        })
    }

}
