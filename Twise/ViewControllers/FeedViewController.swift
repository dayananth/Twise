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
    private var feedViewModel: FeedViewModelProtocol
    private var filterViewModels = [FilterViewModelProtocol]()
    private let searchBoxContainer = UIView()

    init(feedViewModel: FeedViewModelProtocol) {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 4.0
        feedListView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        searchBox = UITextField(frame: .zero)
        self.feedViewModel = feedViewModel
        super.init(nibName: nil, bundle: nil)
        self.feedViewModel.filterViewModelsBinder.bind = { (filterViewModels) in
            self.filterViewModels = filterViewModels
            self.feedListView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 102/255, green: 153/255, blue: 255/255, alpha: 1.0)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        setupSearchBox()
        setupFeedListView()
        feedViewModel.viewLoaded()
    }

    private func setupSearchBox() {
        self.view.addSubview(searchBoxContainer)
        searchBoxContainer.addSubview(searchBox)
        searchBoxContainer.backgroundColor = UIColor(red: 102/255, green: 153/255, blue: 255/255, alpha: 1.0)
        searchBoxContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBox.backgroundColor = UIColor.white
        searchBox.translatesAutoresizingMaskIntoConstraints = false
        searchBox.delegate = self
        searchBox.placeholder = "Search a keyword"

        NSLayoutConstraint.activate([
            searchBoxContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBoxContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchBoxContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBoxContainer.heightAnchor.constraint(equalToConstant: 60.0)
            ])

        NSLayoutConstraint.activate([
            searchBox.leadingAnchor.constraint(equalTo: searchBoxContainer.leadingAnchor, constant: 8.0),
            searchBox.topAnchor.constraint(equalTo: searchBoxContainer.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            searchBox.bottomAnchor.constraint(equalTo: searchBoxContainer.bottomAnchor, constant: -8.0)
        ])


        let logoutButton = UIButton()
        logoutButton.setTitle("LOGOUT", for: .normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        searchBoxContainer.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(FeedViewController.didTapLogout), for: .touchUpInside)

        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(equalTo: searchBox.trailingAnchor, constant: 8.0),
            logoutButton.trailingAnchor.constraint(equalTo: searchBoxContainer.trailingAnchor, constant: -8.0),
            logoutButton.topAnchor.constraint(equalTo: searchBoxContainer.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            logoutButton.bottomAnchor.constraint(equalTo: searchBoxContainer.bottomAnchor, constant: -8.0)
        ])

    }

    private func setupFeedListView() {
        feedListView.register(FeedView.self, forCellWithReuseIdentifier: "FeedView")
        feedListView.register(FeedHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FeedHeaderView")
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
        feedListView.topAnchor.constraint(equalTo: self.searchBoxContainer.bottomAnchor, constant: 5.0).isActive = true
        feedListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func updateCollectionView(indexPathsTodelete: [IndexPath], indexPathsToInsert: [IndexPath]) {
        self.feedListView.reloadData()
    }

    @objc private func didTapLogout() {
        feedViewModel.didTapLogout()
    }


}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let feedViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedView", for: indexPath) as? FeedView {
            if indexPath.row < filterViewModels.count {
                feedViewCell.viewModel = filterViewModels[indexPath.row]
            }
            return feedViewCell
        }
        return FeedView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return feedViewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader,
            let feedHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FeedHeaderView", for: indexPath) as? FeedHeaderView {
            feedHeaderView.viewModel = self.feedViewModel
            return feedHeaderView
        }

        return UICollectionReusableView()

    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {

}

extension FeedViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            textField.resignFirstResponder()
            self.feedViewModel.didSearchKeywordUpdate(searchText)
        }
        return true
    }
}


