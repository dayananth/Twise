//
//  OAuthClient.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/25/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import OAuthSwift

enum Method: String {
    case GET
    case POST
    case PUT
    case PATCH

    var oAuthSwiftValue: OAuthSwiftHTTPRequest.Method {
        switch self {
        case .GET:
            return OAuthSwiftHTTPRequest.Method.GET
        case .POST:
            return OAuthSwiftHTTPRequest.Method.POST
        case .PUT:
            return OAuthSwiftHTTPRequest.Method.PUT
        case .PATCH:
            return OAuthSwiftHTTPRequest.Method.PATCH
        }
    }
}


protocol OAuthClientProtocol {
    /// Returns request with OAuth Header set and the given parameters added
    ///
    /// - Parameters:
    ///   - method: REST Methods GET, POST, UPDATE, etc.
    ///   - baseURL: the baseURL to hit the service
    ///   - parameters: parameters to be passed to the backend service
    /// - Returns: returns URLRequest
    func constructRequest(_ method: Method, baseURL: String, parameters: Dictionary<String, String>) -> URLRequest

}

class OAuthClient: OAuthClientProtocol {

    let consumerKey: String

    let consumerSecret: String

    let oAuthCredential: OAuthSwiftCredential


    /// Initializer for the OAuthClient
    ///
    /// - Parameters:
    ///   - consumerKey: consumer key obtained for OAuth
    ///   - consumerSecret: consumer secret key obtained for OAuth
    ///   - accessToken: access token obtained after login
    ///   - accessTokenSecret: access token secret obtained after login
    init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        let credential = OAuthSwiftCredential(consumerKey: consumerKey, consumerSecret: consumerSecret)
        credential.oauthToken = accessToken
        credential.oauthTokenSecret = accessTokenSecret
        self.oAuthCredential = credential
    }


    func constructRequest(_ method: Method, baseURL: String, parameters: Dictionary<String, String>) -> URLRequest{
        let url = URL(string: baseURL)!
        let authorization = oAuthCredential.authorizationHeader(method: method.oAuthSwiftValue, url: url, parameters: parameters)
        let headers = ["Authorization": authorization]

        let request: URLRequest
        do {
            request = try OAuthSwiftHTTPRequest.makeRequest(url:
                url, method: method.oAuthSwiftValue, headers: headers, parameters: parameters, dataEncoding: String.Encoding.utf8) as URLRequest
        } catch let error as NSError {
            fatalError("TwitterAPIOAuthClient#request invalid request error:\(error.description)")
        } catch {
            fatalError("TwitterAPIOAuthClient#request invalid request unknwon error")
        }

        return request
    }


}
