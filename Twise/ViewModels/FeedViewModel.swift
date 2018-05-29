//
//  FeedViewModel.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/28/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//
import Foundation

class FeedViewModel {

//    private static let TEST_TRENDING_STRING = "twitter"
    private static let headerTitlePrefix = "Search Keyword: "

    var twitterStreamingDatasource: TwitterStreamingDataSourceProtocol
    let router: Router
    let feedLimit = 5
    var filterViewModelsBinder: ViewModelBinder<[FilterViewModel]>?
    var headerTitle: ViewModelBinder<String>? = ViewModelBinder("")

    let numberOfSections = 1

    var onNewFilterViewModelsArrived: ((_ itemsToDelete: [IndexPath],_ itemsToinsert: [IndexPath]) -> Void)?

    var filterViewModels = [FilterViewModel]()

    init(twitterStreamingDatasource: TwitterStreamingDataSourceProtocol, router: Router) {
        self.twitterStreamingDatasource = twitterStreamingDatasource
        self.router = router
        self.twitterStreamingDatasource.datasourceCallback = {[weak self] (filterViewModels) in
            self?.processNewFilterViewModels(newFilterViewModels: filterViewModels)
        }
    }

    func viewLoaded() {
//        headerTitle = ViewModelBinder(FeedViewModel.headerTitlePrefix + FeedViewModel.TEST_TRENDING_STRING)
//        self.twitterStreamingDatasource.fetchStream(trackQuery: FeedViewModel.TEST_TRENDING_STRING)
    }

    func processNewFilterViewModels(newFilterViewModels: [FilterViewModel]) {

        let existingViewModelsCount = filterViewModels.count
        var toDelete = feedLimit - existingViewModelsCount - newFilterViewModels.count
        toDelete = toDelete >= 0 ? 0 : (toDelete * -1)
        var indexPathsToDelete: [IndexPath] = []

        for i in 0..<toDelete {
            indexPathsToDelete.append(IndexPath(item: existingViewModelsCount-i-1, section: 0))
            self.filterViewModels.removeLast()
        }

        var indexPathsToInsert: [IndexPath] = []

        for i in 0..<newFilterViewModels.count {
            indexPathsToInsert.append(IndexPath(item: i, section: 0))
        }

        var newBatch = newFilterViewModels
        newBatch.append(contentsOf: filterViewModels)

        self.filterViewModels = newBatch
        if self.filterViewModels.count > 0 {
            self.onNewFilterViewModelsArrived?(indexPathsToDelete, indexPathsToInsert)
        }
    }

    func didSearchKeywordUpdate(_ newSearchText: String) {
        self.filterViewModels = []
        self.onNewFilterViewModelsArrived?([], [])
        headerTitle?.value = FeedViewModel.headerTitlePrefix + newSearchText
        self.twitterStreamingDatasource.fetchStream(trackQuery: newSearchText)
    }

    func didTapLogout() {
        router.logout()
    }

}
