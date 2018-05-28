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
    private let searchBox: UITextField
    private var feedViewModel: FeedViewModel

    init(feedViewModel: FeedViewModel) {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 4.0
        feedListView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        searchBox = UITextField(frame: .zero)
        self.feedViewModel = feedViewModel
        super.init(nibName: nil, bundle: nil)
        self.feedViewModel.onNewFilterViewModelsArrived = updateCollectionView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 240/255, green: 242/255, blue: 245/255, alpha: 1.0)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        setupSearchBox()
        setupFeedListView()
        feedViewModel.viewLoaded()
    }

    private func setupSearchBox() {
        self.view.addSubview(searchBox)
        searchBox.backgroundColor = UIColor.white
        searchBox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8.0),
            searchBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8.0),
            searchBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBox.heightAnchor.constraint(equalToConstant: 40.0)
        ])
//        searchBox.becomeFirstResponder()
    }

    private func setupFeedListView() {
        feedListView.register(FeedView.self, forCellWithReuseIdentifier: "FeedView")
        self.view.addSubview(feedListView)
        feedListView.backgroundColor = UIColor(red: 240/255, green: 242/255, blue: 245/255, alpha: 1.0)
        feedListView.translatesAutoresizingMaskIntoConstraints = false
        feedListView.isScrollEnabled = true
        feedListView.delegate = self
        feedListView.dataSource = self
        setupFeedListConstraints()
        feedListView.reloadData()
    }

    private func setupFeedListConstraints() {
        feedListView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8.0).isActive = true
        feedListView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8.0).isActive = true
        feedListView.topAnchor.constraint(equalTo: self.searchBox.bottomAnchor, constant: 5.0).isActive = true
        feedListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func updateCollectionView(indexPathsTodelete: [IndexPath], indexPathsToInsert: [IndexPath]) {
//        self.feedListView.insertItems(at: indexPathsToInsert)
//        self.feedListView.performBatchUpdates({
//            self.feedListView.deleteItems(at: indexPathsTodelete)
//        }) { _ in
//            self.feedListView.performBatchUpdates({
//                self.feedListView.insertItems(at: indexPathsToInsert)
//            }, completion: nil)
//        }
        self.feedListView.reloadData()
    }


}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedViewModel.feedLimit
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let feedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedView", for: indexPath) as? FeedView {
            if indexPath.row < feedViewModel.filterViewModels.count {
                feedViewCell.viewModel = feedViewModel.filterViewModels[indexPath.row]
            }
            return feedViewCell
        }
        return FeedView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return feedViewModel.numberOfSections
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {

}



