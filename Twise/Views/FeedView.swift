//
//  FeedView.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/27/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

class FeedView: UICollectionViewCell {

    private let imageView =  UIImageView()
    private let textLabel = UILabel()

    var viewModel: FilterViewModelProtocol? {
        didSet {
            updateUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        addSubview(imageView)
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            imageView.heightAnchor.constraint(equalToConstant: 84.0),
            imageView.widthAnchor.constraint(equalToConstant: 84.0),

            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.0),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0)
            ])
    }

    override func prepareForReuse() {
        imageView.image = nil
        textLabel.text = nil
    }

    func updateUI() {
        setupImageData()
        textLabel.text = viewModel?.text
    }

    private func setImageFromURL(urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        let image = UIImage(data: data)
                        self?.imageView.image = image
                    }
                }
            }
        }
    }

    func setupImageData() {
        if let imageURL = viewModel?.imageURL {
            setImageFromURL(urlString: imageURL)
        }
    }
}
