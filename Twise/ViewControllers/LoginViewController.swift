//
//  LoginViewController.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/27/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func twitterAuth(_ sender: UIButton) {
        viewModel.didTapLoginButton()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        let button = UIButton()
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.bounds = CGRect(x: 0, y: 0, width: 120, height: 30)
        button.center = self.view.center
        button.addTarget(self, action: #selector(LoginViewController.twitterAuth(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
}
