//
//  NetworkManager.swift
//  Home24Test
//
//  Created by Alexander Lisovik on 5/5/18.
//  Copyright © 2018 Alexander Lisovik. All rights reserved.
//

import Foundation
import Alamofire

typealias objectCompletionHandler = (Article?, Error?) -> Swift.Void

class NetworkManager {
    
    static let shared = NetworkManager()
    
    //MARK: - High Level Requests
    func getArticle(for id: String, completionHandler: objectCompletionHandler? = nil) {
        let parameters = "\(id)?appDomain=1&locale=de_DE"
        self.sendRequest(for: Endpoint.articles, and: parameters) { (article, error) in
            print("====== ARTICLE RESPONSE -> \(String(describing: article)) ======")
            if article != nil {
                completionHandler?(article, nil)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    //MARK: - Send Request
    func sendRequest(for method: String, and parameters: String? = nil, completionHandler: objectCompletionHandler? = nil) {
        let url = Backend.baseUrl + Backend.apiVersion + method + parameters!
        print("====== REQUEST FOR -> \(url) ======")
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
                if response.error == nil {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let article = try jsonDecoder.decode(Article.self, from: response.data!)
                        completionHandler!(article, nil)
                    } catch {
                        print(error)
                        completionHandler!(nil, error)
                    }
                } else {
                    completionHandler!(nil, response.error)
                }
            }
        } else {
            let error = NSError(domain: "com.home24.Home24Test", code: 408, userInfo: ["description": "No Internet Connection"])
            completionHandler!(nil, error)
        }
    }
}

//MARK: - Network Service
class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

