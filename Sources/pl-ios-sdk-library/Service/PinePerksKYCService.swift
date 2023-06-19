//
//  PKYC.swift
//  Pliossdk
//
//  Created by Macbook on 16/03/23.
//

import Foundation
import UIKit

class PinePerksKYCService {
    
    private var baseUrl: String
    private var pinePerksUsername: String
    init(baseUrl: String, pinePerksUsername: String) {
        self.baseUrl = baseUrl
        self.pinePerksUsername = pinePerksUsername
    }
    
    func selfieValidation(ckycUniqueId: String, selfieImageData: String, completion: @escaping (PLKYCResponse?, Error?) -> Void) {
        let validationEvent = Event.selfieValidation.description
        
        if ckycUniqueId == "" || selfieImageData == "" {
            let PLKYCResponse = PLKYCResponse(responseCode: ResponseCodes.SELFIE_VALIDATION_ERROR.rawValue, responseMessage: ResponseMessage.SELFIE_VALIDATION_ERROR.rawValue)
            print("\(SDKConstants.TAG)", PLKYCResponse)
            completion(PLKYCResponse, nil)
        }
        if Internet.isConnected() == true {
            let url = URL(string:baseUrl + BaseURLs.selfieURL)!
            let parameters: [String: Any] = [
                "ckycUniqueId": ckycUniqueId,
                "selfieImageData": selfieImageData
            ]
            
            URLSessionDataTaskHandler.fetchData(with: url, parameters: parameters, pinePerksUsername:  self.pinePerksUsername) { data, response, error in
                
                if let error = error {
                    if error._code == NSURLErrorTimedOut {
                        let plKycResponse = PLKYCResponse(responseCode: ResponseCodes.SOCKET_TIMEOUT_EXCEPTION.rawValue, responseMessage: ResponseMessage.SOCKET_TIMEOUT_EXCEPTION.rawValue,event:validationEvent)
                        print("\(SDKConstants.TAG)", plKycResponse)
                        completion(plKycResponse, error)
                    }else {
                        let plKycResponse = PLKYCResponse(responseCode: ResponseCodes.IO_EXCEPTION.rawValue, responseMessage: ResponseMessage.IO_EXCEPTION.rawValue,event:validationEvent)
                        print("\(SDKConstants.TAG)", plKycResponse)
                        completion(plKycResponse, error)
                    }
                    return
                }
                guard let data = data else {
                    let plKycResponse = PLKYCResponse(responseCode: ResponseCodes.EMPTY_BODY.rawValue, responseMessage: ResponseMessage.EMPTY_BODY.rawValue,event:validationEvent)
                    print("\(SDKConstants.TAG)", plKycResponse)
                    completion(plKycResponse, nil)
                    return
                }
                do {
                    let responseModel = try JSONDecoder().decode(SelfieValidationResponseModel.self, from: data)
                    let plKycResponse = PLKYCResponse(responseCode: responseModel.responseCode, responseMessage: responseModel.responseMessage!,event:validationEvent)
                    plKycResponse.kycLink = responseModel.kycLink
                    plKycResponse.ckycUniqueId = responseModel.ckycUniqueId
                    completion(plKycResponse, nil)
                } catch let error {
                    print("PL-SDK Error: \(error)")
                    let plKycResponse = PLKYCResponse(responseCode: ResponseCodes.SDK_EXCEPTION.rawValue, responseMessage: ResponseMessage.SDK_EXCEPTION.rawValue,event:validationEvent)
                    print("\(SDKConstants.TAG)", plKycResponse)
                    completion(plKycResponse, nil)
                }
            }
        } else {
            print("\(SDKConstants.TAG) check your network connection")
            let plKycResponse = PLKYCResponse(responseCode: ResponseCodes.UNKNOWN_HOST_EXCEPTION.rawValue, responseMessage: ResponseMessage.UNKNOWN_HOST_EXCEPTION.rawValue, event:validationEvent)
            print("\(SDKConstants.TAG)", plKycResponse)
            completion(plKycResponse, nil)
        }
    }
}





