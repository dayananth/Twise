//
//  TwitterStreamingService.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//
import SwiftyJSON

typealias TwitterStreamingServiceProgressCallback = ([FilterModel]) -> Void

enum TwitterStreamingServiceConstants {
    static let updateInterval: TimeInterval = 1.25
    static let batchLimit: Int = 1
}

class TwitterStreamingService {

    var streamingService: StreamingService?
    let authenticationService: AuthenticationServiceProtocol

    var filterModelsQueue = [FilterModel]()
    var lastProcessedBatch: TimeInterval

    var streamingServiceCallback: TwitterStreamingServiceProgressCallback?

    init(authenticationService: AuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
        self.lastProcessedBatch = Date().timeIntervalSince1970 - 2
    }

    func startStreaming(parameters: Dictionary<String, String>) {

        guard let authenticatedClient = authenticationService.authenticatedClient() else {
            // Error Handling
            return
        }
        let request = authenticatedClient.constructRequest(.POST, requestURL: BaseURL.twitterStreamBaseURL + "/1.1/statuses/filter.json", parameters: parameters)

        streamingService = StreamingService(request).start()
        _ = streamingService?.progress({ (data) in
            do {
                let json = try JSON(data: data)
                var filterModelsArray = [FilterModel]()
                if let jsonArray = json.array {
                    for jsonObject in jsonArray {
                        filterModelsArray.append(FilterModel(json: jsonObject))
                    }
                } else {
                    let filterModel = FilterModel(json: json)
                    filterModelsArray.append(filterModel)
                }
                self.filterModelsQueue.append(contentsOf: filterModelsArray)

            } catch _ as NSError {

            }
        }).completion({ (data, response, error) in
            _ = self.streamingService?.closeConnection()
        })
    }

    func throttle() {
        let now = Date().timeIntervalSince1970

        if now - self.lastProcessedBatch > TwitterStreamingServiceConstants.updateInterval {
            let slice =  Array(self.filterModelsQueue.suffix(TwitterStreamingServiceConstants.batchLimit))
            self.lastProcessedBatch = now
            self.streamingServiceCallback?(slice)
            self.filterModelsQueue.removeAll()
        }

        let interval = DispatchTime.now() + Double(Int64(TwitterStreamingServiceConstants.updateInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: interval) {
            self.throttle()
        }
    }

    func throttledStreaming(parameters: Dictionary<String, String>) {
        _ = streamingService?.closeConnection()
        startStreaming(parameters: parameters)
        throttle()
    }


}
