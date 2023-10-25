//
//  URLSessionDataTaskHandler.swift
//  Pliossdk
//
//  Created by Macbook on 22/03/23.
//

import Foundation
import UIKit

class URLSessionDataTaskHandler {
    var task: URLSessionDataTask?
    
    static func fetchData(with url: URL, parameters:[String: Any],pinePerksUsername : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = BaseURLs.createHeader(username: pinePerksUsername)
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            completion(nil, nil , NSError(domain: "Invalid Parameters", code: -2, userInfo: nil))
            return
        }
        
        request.httpBody = httpBody
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        configuration.timeoutIntervalForResource = TimeInterval(15)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func fetchCardDetail<T: Encodable>(with url: URL, parameters:T,pinePerksUsername : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = BaseURLs.createHeader(username: pinePerksUsername)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        configuration.timeoutIntervalForResource = TimeInterval(15)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func validateViewCardOTP<T: Encodable>(with url: URL, parameters:T,pinePerksUsername : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = BaseURLs.createHeader(username: pinePerksUsername)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        configuration.timeoutIntervalForResource = TimeInterval(15)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func changePin<T: Encodable>(with url: URL, parameters:T,pinePerksUsername : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = BaseURLs.createHeader(username: pinePerksUsername)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        configuration.timeoutIntervalForResource = TimeInterval(15)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func validateChangePinOTP<T: Encodable>(with url: URL, parameters:T,pinePerksUsername : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = BaseURLs.createHeader(username: pinePerksUsername)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        configuration.timeoutIntervalForResource = TimeInterval(15)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func resendOTP<T: Encodable>(with url: URL, parameters:T,pinePerksUsername : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = BaseURLs.createHeader(username: pinePerksUsername)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(15)
        configuration.timeoutIntervalForResource = TimeInterval(15)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
