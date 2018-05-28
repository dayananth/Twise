//
//  TwitterStreamingDataSource.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

typealias TwitterStreamingDataSourceCallback = ([FilterViewModel]) -> Void

protocol TwitterStreamingDataSourceProtocol {
    var datasourceCallback: TwitterStreamingDataSourceCallback? {get set}

    func fetchStream(trackQuery: String)
}

class TwitterStreamingDataSource: TwitterStreamingDataSourceProtocol{

    let twitterStreamingService: TwitterStreamingService
    var datasourceCallback: TwitterStreamingDataSourceCallback?

    init(twitterStreamingService: TwitterStreamingService) {
        self.twitterStreamingService = twitterStreamingService
        self.twitterStreamingService.streamingServiceCallback = {
            (filterModels) in
            var filterViewModelsArray = [FilterViewModel]()
            for filterModel in filterModels {
                filterViewModelsArray.append(FilterViewModel(filterModel: filterModel))
            }
            self.datasourceCallback?(filterViewModelsArray)
        }
    }

//    func fetchStream(trackQuery: String, twitterStreamingDataSourceCallback: @escaping TwitterStreamingDataSourceCallback)  {
//        let parameters = ["track": trackQuery]
//        twitterStreamingService.throttledStreaming(parameters: parameters)
//            { (filterModels) in
//                var filterViewModelsArray = [FilterViewModel]()
//                for filterModel in filterModels {
//                    filterViewModelsArray.append(FilterViewModel(filterModel: filterModel))
//                }
//                twitterStreamingDataSourceCallback(filterViewModelsArray)
//        }
//    }

    func fetchStream(trackQuery: String) {
        let parameters = ["track": trackQuery]
        twitterStreamingService.throttledStreaming(parameters: parameters)
    }
}
