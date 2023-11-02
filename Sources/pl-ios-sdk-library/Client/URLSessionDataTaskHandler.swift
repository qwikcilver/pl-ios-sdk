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
    static private var selectedVersion:String = Version.Version_2.rawValue
    static private var timeout:Int = 15
    
    static func fetchData(baseUrl:String, parameters:[String: Any],credential : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: APIUtil.getURL(baseUrl: baseUrl, selectedVersion: selectedVersion, event: Event.selfieValidation))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIUtil.createHeaderWithVersion(credential: credential, selectedVersion: selectedVersion)
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            completion(nil, nil , NSError(domain: "Invalid Parameters", code: -2, userInfo: nil))
            return
        }
        
        request.httpBody = httpBody
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func fetchCardDetail<T: Encodable>(baseUrl: String, parameters:T,crednetial : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: APIUtil.getURL(baseUrl: baseUrl, selectedVersion: selectedVersion, event: Event.showCard))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIUtil.createHeaderWithVersion(credential: crednetial, selectedVersion: selectedVersion)
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func validateViewCardOTP<T: Encodable>(baseUrl :String, parameters:T,credential : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: APIUtil.getURL(baseUrl: baseUrl, selectedVersion: selectedVersion, event: Event.showCardOtp))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIUtil.createHeaderWithVersion(credential: credential, selectedVersion: selectedVersion)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func changePin<T: Encodable>(baseUrl:String, parameters:T,credential : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: APIUtil.getURL(baseUrl: baseUrl, selectedVersion: selectedVersion, event: Event.changePin))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIUtil.createHeaderWithVersion(credential: credential, selectedVersion: selectedVersion)
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func validateChangePinOTP<T: Encodable>(baseUrl:String, parameters:T,credential : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: APIUtil.getURL(baseUrl: baseUrl, selectedVersion: selectedVersion, event: Event.changePinOtp))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIUtil.createHeaderWithVersion(credential: credential, selectedVersion: selectedVersion)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func resendOTP<T: Encodable>(baseUrl:String, parameters:T,crdential : String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: APIUtil.getURL(baseUrl: baseUrl, selectedVersion: selectedVersion, event: Event.resendOtp))
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIUtil.createHeaderWithVersion(credential: crdential, selectedVersion: selectedVersion)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("\(SDKConstants.TAG)" ,error.localizedDescription)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    static func setSelectedVersion(selectedVersion:String){
        self.selectedVersion = selectedVersion
    }
    
    static func setAPITimeout(timeout:Int){
        self.timeout = timeout
    }
    
}

