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
    let buttonTitle = "Login"
    let labelTitle = "Please tap button below to login with Twitter OAuth"

    init(authenticationService: AuthenticationServiceProtocol, router: Router) {
        self.authenticationService = authenticationService
        self.router = router
    }

    func login() {
        guard let callbackURL = URL(string: Constants.applicationBaseURL + "oauth-callback") else {
            return
        }

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
