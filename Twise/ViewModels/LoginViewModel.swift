//
//  LoginViewModel.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/27/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

class LoginViewModel {

    let authenticationService: AuthenticationServiceProtocol
    let router: Router
    let buttonTitle = "Twise OAuth Login"

    init(authenticationService: AuthenticationServiceProtocol, router: Router) {
        self.authenticationService = authenticationService
        self.router = router
    }

    func login() {
//        let requestTokenUrl = BaseURL.twitterAPIBaseURL + "/oauth/request_token"
//        let authorizeUrl = BaseURL.twitterAPIBaseURL + "/oauth/authorize"
//        let accessTokenUrl = BaseURL.twitterAPIBaseURL + "/oauth/access_token"
//
        guard let callbackURL = URL(string: Constants.applicationBaseURL + "oauth-callback") else {
            return
        }
//
//        let oAuth1 = authenticationService.OAuth1(requestTokenUrl: requestTokenUrl , authorizeUrl: authorizeUrl, accessTokenUrl: accessTokenUrl)


        authenticationService.authorize(with: BaseURL.twitterAPIBaseURL + "/oauth", callbackURL: callbackURL, success: { [weak self] (response) in
            if let router = self?.router {
                router.route(route: .home)
            }
        }) { (error) in
            // Error handling
        }
    }

    func didTapLoginButton() {
        self.login()
    }

}
