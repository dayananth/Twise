//
//  TwitterStreamingService.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//
import SwiftyJSON

typealias TwitterStreamingServiceProgressCallback = ([FilterModel]) -> Void

class TwitterStreamingService {

    var streamingService: StreamingService?
    let authenticationService: AuthenticationServiceProtocol

    init(authenticationService: AuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
//        let authenticatedClient = authenticationService.authenticatedClient()
//        authenticatedClient.constructRequest(.POST, requestURL: BaseURL.twitterStreamBaseURL + "/1.1/statuses/filter.json",, parameters: <#T##Dictionary<String, String>#>)
//        streamingService = StreamingService( )
    }

    func startStreaming(parameters: Dictionary<String, String>, twitterStreamingServiceProgressCallBack: @escaping TwitterStreamingServiceProgressCallback) {

        guard let authenticatedClient = authenticationService.authenticatedClient() else {
            // Error Handling
            return
        }
        let request = authenticatedClient.constructRequest(.POST, requestURL: BaseURL.twitterStreamBaseURL + "/1.1/statuses/filter.json", parameters: parameters)

        _ = streamingService?.closeConnection()
        streamingService = StreamingService(request)
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
                twitterStreamingServiceProgressCallBack(filterModelsArray)

            } catch _ as NSError {

            }
        })
    }


}
