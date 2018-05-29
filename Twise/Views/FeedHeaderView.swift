//
//  FeedHeaderView.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/28/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

class FeedHeaderView: UICollectionReusableView {

    let headerTextLabel =  UILabel()
    var viewModel: FeedViewModel? {
        didSet {
            viewModel?.headerTitle?.bind = { (keyword) in
                self.headerTextLabel.text = keyword
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI()  {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.headerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerTextLabel)
        NSLayoutConstraint.activate([
            self.headerTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            self.headerTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
            self.headerTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.headerTextLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        self.headerTextLabel.text = "Search a keyword"
        self.headerTextLabel.textColor = .black
    }

}
