//
//  FeedViewModel.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/28/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//
import Foundation

protocol FeedViewModelProtocol: class {

    var numberOfSections: Int {get}

    /// can be called when the view or viewcontroller that uses this protocol is loaded
    func viewLoaded()

    /// On logging out
    func didTapLogout()

    /// Binder property on filter view models for views and viewcontrollers to react to
    var filterViewModelsBinder: ViewModelBinder<[FilterViewModelProtocol]> {get}

    /// Binder property on header title for views and viewcontrollers to react to
    var headerTitleBinder: ViewModelBinder<String> {get}

    /// When the new twitter keyword is used for getting trends
    ///
    /// - Parameter newSearchText: search keyword
    func didSearchKeywordUpdate(_ newSearchText: String)
}

class FeedViewModel: FeedViewModelProtocol {
//    private static let TEST_TRENDING_STRING = "twitter"
    private static let headerTitlePrefix = "Search Keyword: "

    var twitterStreamingDatasource: TwitterStreamingDataSourceProtocol
    let router: Router?
    let feedLimit = 5
    let headerTitleBinder: ViewModelBinder<String> = ViewModelBinder("")

    let filterViewModelsBinder: ViewModelBinder<[FilterViewModelProtocol]> = ViewModelBinder([])

    let numberOfSections = 1

    var filterViewModels: [FilterViewModelProtocol] {
        didSet {
            filterViewModelsBinder.value = self.filterViewModels
        }
    }

    init(twitterStreamingDatasource: TwitterStreamingDataSourceProtocol, router: Router? = nil) {
        self.twitterStreamingDatasource = twitterStreamingDatasource
        self.router = router
        self.filterViewModels = []
        self.twitterStreamingDatasource.datasourceCallback = {[weak self] (filterViewModels) in
            self?.processNewFilterViewModels(newFilterViewModels: filterViewModels)
        }
    }

    func viewLoaded() {
//        headerTitle = ViewModelBinder(FeedViewModel.headerTitlePrefix + FeedViewModel.TEST_TRENDING_STRING)
//        self.twitterStreamingDatasource.fetchStream(trackQuery: FeedViewModel.TEST_TRENDING_STRING)
    }

    func processNewFilterViewModels(newFilterViewModels: [FilterViewModelProtocol]) {

        if newFilterViewModels.count == 0 {
            return
        }

        let existingViewModelsCount = filterViewModels.count
        var toDelete = feedLimit - existingViewModelsCount - newFilterViewModels.count
        toDelete = toDelete >= 0 ? 0 : (toDelete * -1)

        for _ in 0..<toDelete {
            self.filterViewModels.removeLast()
        }

        var newBatch = newFilterViewModels
        newBatch.append(contentsOf: filterViewModels)

        self.filterViewModels = newBatch
        self.filterViewModelsBinder.value = self.filterViewModels
    }

    func didSearchKeywordUpdate(_ newSearchText: String) {
        self.filterViewModels = []
        self.filterViewModelsBinder.value = []
        headerTitleBinder.value = FeedViewModel.headerTitlePrefix + newSearchText
        self.twitterStreamingDatasource.fetchStream(trackQuery: newSearchText)
    }

    func didTapLogout() {
        router?.logout()
    }

}
