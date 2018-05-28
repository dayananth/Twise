//
//  FeedViewModel.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/28/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//
import Foundation

class FeedViewModel {

    var twitterStreamingDatasource: TwitterStreamingDataSourceProtocol
    let router: Router
    let feedLimit = 5
//    let backgroundColor = UIColor(red: 240/255, green: 242/255, blue: 245/255, alpha: 1.0)
    var filterViewModelsBinder: ViewModelBinder<[FilterViewModel]>?

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
        self.twitterStreamingDatasource.fetchStream(trackQuery: "twitter")
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

        self.onNewFilterViewModelsArrived?(indexPathsToDelete, indexPathsToInsert)
    }

}
