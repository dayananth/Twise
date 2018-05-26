//
//  StreamingService.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/25/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import MutableDataScanner

typealias ProgressHandler = (_ data: Data) -> Void
typealias CompletionHandler = (_ responseData: Data?, _ response: HTTPURLResponse?, _ error: NSError?) -> Void


// Service class that takes care of streaming twitter service.
class StreamingService: NSObject {

    /// Streaming service Session
    var session: URLSession?

    /// Streaming service Task
    var task: URLSessionDataTask?

    /// Request passed in
    let originalRequest: URLRequest

    /// Streaming Service Delegate
    let delegate: StreamingDelegate

    /**
     Create a StreamingRequest Instance
     - parameter request: NSURLRequest
     - parameter configuration: NSURLSessionConfiguration?
     - parameter queue: NSOperationQueue?
     */
    public init(_ request: URLRequest, configuration: URLSessionConfiguration = URLSessionConfiguration.default, queue: OperationQueue? = nil) {
        originalRequest = request
        delegate = StreamingDelegate()
        session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
        task = session?.dataTask(with: request)
    }

    /**
     Connect streaming.
     - returns: self
     */
    func start() -> StreamingService {
        task?.resume()
        return self
    }

    /**
     Disconnect streaming.
     - returns: self
     */
    func closeConnection() -> StreamingService {
        task?.cancel()
        return self
    }

    /**
     Set progress hander.
     It will be called whenever the server returns data
     - parameter progress: (data: NSData) -> Void
     - returns: self
     */
    func progress(_ progress: @escaping ProgressHandler) -> StreamingService {
        delegate.progress = progress
        return self
    }

    /**
     Set completion hander.
     It will be called when an error is received.
     - URLSession:dataTask:didReceiveResponse:completionHandler: (if statusCode is not 200)
     - URLSession:task:didCompleteWithError:
     - parameter completion: (responseData: NSData?, response: NSURLResponse?, error: NSError?) -> Void
     - returns: self
     */
    func completion(_ completion: @escaping CompletionHandler) -> StreamingService {
        delegate.completion = completion
        return self
    }

}

class StreamingDelegate: NSObject, URLSessionDataDelegate {

    fileprivate let serial = DispatchQueue(label: "Twise.StreamingDelegate", attributes: [])

    /// Streaming Service Response
    var response: HTTPURLResponse!

    /// Streaming Service Response data buffer
    let scanner = MutableDataScanner(delimiter: "\r\n")

    /// Streaming Service Received JSON Hander
    fileprivate var progress: ProgressHandler?

    /// Streaming Service Disconnect Hander
    fileprivate var completion: CompletionHandler?

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        serial.sync {
            self.scanner.append(data)
            while let data = self.scanner.next() {
                if data.count > 0 {
                    self.progress?(data)
                }
            }
        }
    }

    @nonobjc func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        guard let httpURLResponse = response as? HTTPURLResponse else {
            fatalError("didReceiveResponse is not NSHTTPURLResponse")
        }
        self.response = httpURLResponse

        if httpURLResponse.statusCode == 200 {
            completionHandler(.allow)
        } else {
            DispatchQueue.main.async(execute: {
                self.completion?(self.scanner.data, httpURLResponse, nil)
            })
        }
    }

    @nonobjc func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            completionHandler(
                Foundation.URLSession.AuthChallengeDisposition.useCredential,
                URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async(execute: {
            self.completion?(self.scanner.data, self.response, error as NSError?)
        })
    }
}
