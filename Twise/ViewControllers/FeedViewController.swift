//
//  FeedViewController.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/27/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    private let feedListView: UICollectionView
    private let collectionViewFlowLayout: UICollectionViewFlowLayout

    init() {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 4.0
        feedListView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.translatesAutoresizingMaskIntoConstraints = false
        setupFeedListView()
    }

    private func setupFeedListView() {
        feedListView.register(FeedView.self, forCellWithReuseIdentifier: "FeedView")
        self.view.addSubview(feedListView)
        feedListView.backgroundColor = UIColor.blue
        feedListView.translatesAutoresizingMaskIntoConstraints = false
        feedListView.isScrollEnabled = true
        feedListView.delegate = self
        feedListView.dataSource = self
        setupFeedListConstraints()
    }

    private func setupFeedListConstraints() {
        feedListView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8.0).isActive = true
        feedListView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8.0).isActive = true
        feedListView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5.0).isActive = true
        feedListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }


}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let feedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedView", for: indexPath) as? FeedView {
            return feedViewCell
        }
        return FeedView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {

}



