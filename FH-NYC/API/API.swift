//
//  API.swift
//  FH-NYC
//
//  Created by Christophe Delhaze on 31/1/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIError: Error {
    case missingData
    case missingRequiredField(name: String)
    case invalidUrl(urlString: String)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingData:
            return "Some required Data is missing."
        case .missingRequiredField(let name):
            return "The \(name) parameter is missing."
        case .invalidUrl(let urlString):
            return "Invalid URL: \(urlString)"
        case .unknown:
            return "An unknown error accured."
        }
    }
}

typealias APIData = [String: Any?]
typealias APIRequest = DataRequest

class API {
    
    var accessToken: String? //We would get that from an OAuth login.
    
    typealias APIResponse = (_ error: Error?, _ json: JSON?) -> Void
    
    fileprivate struct Headers {
        static let accept = "Accept"
        static let acceptJSON = "application/json"
        static let timeoutRetry = "X-Timeout-Retry"
        static let timeoutRetryYes = "1"
        static let timeoutRetryNo = "0"
        static let authorization = "Authorization"
        static let authorizationType = "Bearer"
    }
    
    private let dispatchQueue = DispatchQueue(label: "com.ChD.FH-NYC.api.queue", qos: .background)
    internal var sessionManager: Alamofire.SessionManager

    internal var apiBaseUrl: String {
        let environment = Environment()
        let serverUrl = environment.configuration(.serverApiURL)
        let `protocol` = environment.configuration(.connectionProtocol)
        let apiVersion = environment.configuration(.apiVersion)
        
        return "\(`protocol`)://\(serverUrl)/\(apiVersion)"
    }

    
    static func apiStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = (dateString.count == 10 ? Constants.apiShortDateFormat : Constants.apiDateFormat)
        return dateFormatter.date(from: dateString)
    }

    static func dateToAPIString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.apiDateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: date)
    }

    required init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.timeoutIntervalForRequest = Constants.apiTimeoutInterval
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.retrier = TimeoutHandler()
    }
    
    @discardableResult
    internal func get(_ path: String, parameters: APIData? = nil, retryOnTimeout: Bool = true, completionHandler: APIResponse? = nil) -> APIRequest? {
        return request(path, method: .get, parameters: parameters, retryOnTimeout: retryOnTimeout, completionHandler: completionHandler)
    }
    
    @discardableResult
    internal func delete(_ path: String, parameters: APIData? = nil, retryOnTimeout: Bool = true, completionHandler: APIResponse? = nil) -> APIRequest? {
        return request(path, method: .delete, parameters: parameters, retryOnTimeout: retryOnTimeout, completionHandler: completionHandler)
    }
    
    @discardableResult
    internal func post(_ path: String, parameters: APIData? = nil, retryOnTimeout: Bool = true, completionHandler: APIResponse? = nil) -> APIRequest? {
        return request(path, method: .post, parameters: parameters, retryOnTimeout: retryOnTimeout, completionHandler: completionHandler)
    }
    
    @discardableResult
    internal func put(_ path: String, parameters: APIData? = nil, retryOnTimeout: Bool = true, completionHandler: APIResponse? = nil) -> APIRequest? {
        return request(path, method: .put, parameters: parameters, retryOnTimeout: retryOnTimeout, completionHandler: completionHandler)
    }
    
    @discardableResult
    internal func patch(_ path: String, parameters: APIData? = nil, retryOnTimeout: Bool = true, completionHandler: APIResponse? = nil) -> APIRequest? {
        return request(path, method: .patch, parameters: parameters, retryOnTimeout: retryOnTimeout, completionHandler: completionHandler)
    }
        
    func request(_ path: String, method: HTTPMethod = .get, parameters: APIData? = nil, retryOnTimeout: Bool = true, completionHandler: APIResponse? = nil) -> APIRequest? {
        var headers: HTTPHeaders = [
            Headers.accept: Headers.acceptJSON,
            Headers.timeoutRetry: (retryOnTimeout ? Headers.timeoutRetryYes : Headers.timeoutRetryNo)
        ]
        
        if let accessToken = accessToken {
            headers[Headers.authorization] = "\(Headers.authorizationType) \(accessToken)"
        }
        
        var formattedParameters = Parameters()
        parameters?.forEach { (key, value) in
            if let value = value {
                if let date = value as? Date {
                    formattedParameters[key] = API.dateToAPIString(date)
                } else {
                    formattedParameters[key] = value
                }
            }
        }
        
        let encoding: ParameterEncoding = (method == .get || method == .delete ? URLEncoding.queryString : JSONEncoding.default)
        let serverUrlString = "\(apiBaseUrl)\(path)"
        guard let url = URL(string: serverUrlString) else {
            completionHandler?(APIError.invalidUrl(urlString: serverUrlString), nil)
            return nil
        }
        
        return sessionManager.request(url, method: method, parameters: formattedParameters, encoding: encoding, headers: headers).responseJSON(queue: dispatchQueue) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let statusCode = response.response?.statusCode, statusCode >= 400, statusCode < 600 {
                    completionHandler?(response.error, nil)
                } else {
                    completionHandler?(nil, json)
                }
            case .failure(let error):
                print("An API error occurred: \(error)")
                completionHandler?(error, nil)
            }
        }
    }
    
}

class TimeoutHandler: RequestRetrier {
    
    func should(_ manager: Alamofire.SessionManager, retry request: Alamofire.Request, with error: Error, completion: @escaping Alamofire.RequestRetryCompletion) {
        let timeoutRetry = request.request?.value(forHTTPHeaderField: API.Headers.timeoutRetry)
        if (error as NSError).code == NSURLErrorTimedOut && request.retryCount < Constants.apiTimeoutRetryCount && timeoutRetry == API.Headers.timeoutRetryYes {
            completion(true, 0.5)
        } else {
            completion(false, 0)
        }
    }
    
}
