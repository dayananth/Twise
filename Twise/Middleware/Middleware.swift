//
//  Middleware.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

enum Constants {
    static let applicationBaseURL = "TwiseOAuth://"
}

class Middleware: NSObject {

    let window: UIWindow?
    let router: Router
    let authenticationService = AuthenticationService()

    init(window: UIWindow? ) {
        self.window = window
        self.router = Router(window: window, authenticationService: authenticationService)
    }

    func appStarted() {
        if authenticationService.isAuthenticated() {
            router.route(route: .home)
        } else {
            router.route(route: .login)
        }
    }

}


class Router {

    enum Route {
        case login
        case home
        case logout
    }

    let window: UIWindow?
    let authenticationService: AuthenticationServiceProtocol
    let twitterStreamingDataSource: TwitterStreamingDataSource

    init(window: UIWindow?,
         authenticationService: AuthenticationServiceProtocol) {
        self.window = window
        self.authenticationService = authenticationService
        let twitterStreamingService = TwitterStreamingService(authenticationService: authenticationService)
        self.twitterStreamingDataSource = TwitterStreamingDataSource(twitterStreamingService: twitterStreamingService)
    }

    func route(route: Router.Route) {
        switch route {
        case .login:
            self.window?.rootViewController = loginViewController()
            self.window?.makeKeyAndVisible()
        case .home:
            self.window?.rootViewController = feedViewController()
            self.window?.makeKeyAndVisible()
        case .logout:
            logout()
        }
    }

    func loginViewController() -> UIViewController {
        let loginViewModel = LoginViewModel(authenticationService: self.authenticationService, router: self)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        return loginViewController
    }

    func feedViewController() -> UIViewController {
        let twitterStreamingService = TwitterStreamingService(authenticationService: self.authenticationService)
        let twitterStreamingDatasource = TwitterStreamingDataSource(twitterStreamingService: twitterStreamingService)
        let feedViewModel = FeedViewModel(twitterStreamingDatasource: twitterStreamingDatasource, router: self)

        let feedViewController = FeedViewController(feedViewModel: feedViewModel)
        return feedViewController
    }

    func logout() {
        authenticationService.removeAccessTokens()
        self.route(route: .login)
    }
}
