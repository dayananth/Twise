//
//  ViewController.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/24/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON


class ViewController: UIViewController {


    var oauthswift: OAuthSwift?

    let consumerData: [String:String] = ["consumerKey": "PkKRNdwGbnsgLdXZUCX0kzVwI", "consumerSecret": "yAmiuVRHF1NBNDj2zOeBLWewempeQt10QeHhcZvzIRMG0mlsck"]

    @IBAction func twitterAuth(_ sender: UIButton) {
        doAuthTwitter(consumerData)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.backgroundColor = .white
        let button = UIButton()
        button.setTitle("Twitter OAuth", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.bounds = CGRect(x: 0, y: 0, width: 120, height: 30)
        button.center = self.view.center
        button.addTarget(self, action: #selector(ViewController.twitterAuth(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Twitter
    func doAuthTwitter(_ serviceParams: [String: String]) {
        let oauthswift = OAuth1Swift(consumerKey: serviceParams["consumerKey"]!, consumerSecret: serviceParams["consumerSecret"]!, requestTokenUrl: "https://api.twitter.com/oauth/request_token", authorizeUrl: "https://api.twitter.com/oauth/authorize", accessTokenUrl: "https://api.twitter.com/oauth/access_token")
        self.oauthswift = oauthswift
        oauthswift.authorize(withCallbackURL: URL(string: "TWiseOAuth://oauth-callback")!,
                             success: { credential, response, parameters in
                                self.showTokenAlert(name: serviceParams["name"], credential: credential)
        }, failure: { error in
            print(error.description)
        }
        )
    }

    func getURLHandler() -> OAuthSwiftURLHandlerType {
        return OAuthSwiftOpenURLExternally.sharedInstance
    }

    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token: \(credential.oauthToken)"
        if !credential.oauthTokenSecret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauthTokenSecret)"
        }
        let client = OAuthClient(consumerKey: consumerData["consumerKey"]!, consumerSecret: consumerData["consumerSecret"]!, accessToken: credential.oauthToken, accessTokenSecret: credential.oauthTokenSecret)
        let streamingRequest = StreamingService(client.constructRequest(.POST, requestURL: "https://stream.twitter.com/1.1/statuses/filter.json", parameters: ["track":"twitter"]))
//        self.showAlertView(title: name ?? "Service", message: message)

        _ = streamingRequest.progress { (data) in
            let json = try! JSON(data: data)
            print(json)
        }.start()
    }

    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

