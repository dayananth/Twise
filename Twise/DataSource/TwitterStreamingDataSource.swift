//
//  TwitterStreamingDataSource.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

typealias TwitterStreamingDataSourceCallback = ([FilterViewModel]) -> Void

protocol TwitterStreamingDataSourceProtocol {
    func fetchStream(trackQuery: String, twitterStreamingDataSourceCallback: @escaping TwitterStreamingDataSourceCallback)
}

class TwitterStreamingDataSource {

    let twitterStreamingService: TwitterStreamingService

    init(twitterStreamingService: TwitterStreamingService) {
        self.twitterStreamingService = twitterStreamingService
    }

    func fetchStream(trackQuery: String, twitterStreamingDataSourceCallback: @escaping TwitterStreamingDataSourceCallback)  {
        let parameters = ["track": trackQuery]
        twitterStreamingService.startStreaming(parameters: parameters)
            { (filterModels) in
                var filterViewModelsArray = [FilterViewModel]()
                for filterModel in filterModels {
                    filterViewModelsArray.append(FilterViewModel(filterModel: filterModel))
                }
                twitterStreamingDataSourceCallback(filterViewModelsArray)
        }
    }
}
