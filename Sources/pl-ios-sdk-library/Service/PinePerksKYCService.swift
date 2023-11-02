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
    private var credential: String
    private var selectedVersion:String
    private var timeout:Int = 15
    
    init(baseUrl: String, credential: String, selectedVersion:String) {
        self.baseUrl = baseUrl
        self.credential = credential
        self.selectedVersion = selectedVersion
        URLSessionDataTaskHandler.setSelectedVersion(selectedVersion: selectedVersion)
    }
    
    func selfieValidation(ckycUniqueId: String, selfieImageData: String, completion: @escaping (PLKYCResponse?, Error?) -> Void) {
        let validationEvent = Event.selfieValidation.description
        
        if ckycUniqueId == "" || selfieImageData == "" {
            let PLKYCResponse = PLKYCResponse(responseCode: ResponseCodes.SELFIE_VALIDATION_ERROR.rawValue, responseMessage: ResponseMessage.SELFIE_VALIDATION_ERROR.rawValue)
            print("\(SDKConstants.TAG) KYC Response \(PLKYCResponse)")
            completion(PLKYCResponse, nil)
        }
        if Internet.isConnected() == true {
            //let url = URL(string:baseUrl + APIUtil.selfieURL)!
            let parameters: [String: Any] = [
                "ckycUniqueId": ckycUniqueId,
                "selfieImageData": selfieImageData
            ]
            
            URLSessionDataTaskHandler.setAPITimeout(timeout: timeout)
            
            URLSessionDataTaskHandler.fetchData(baseUrl:baseUrl, parameters: parameters, credential: self.credential) { data, response, error in
                
                if let error = error {
                    print("\(SDKConstants.TAG) API execution failed.")
                    print("\(SDKConstants.TAG) Cause: \(error.localizedDescription)")
                    print("\(SDKConstants.TAG) StackTrace: \(error)")
              
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
                if let httpStatus = response as? HTTPURLResponse{
                    let statusCode = httpStatus.statusCode
                    print("\(SDKConstants.TAG) KYC Response: HttpStatus -- \(statusCode)")
                }
                do {
                    let responseModel = try JSONDecoder().decode(SelfieValidationResponseModel.self, from: data)
                    let plKycResponse = PLKYCResponse(responseCode: responseModel.responseCode, responseMessage: responseModel.responseMessage!,event:validationEvent)
                    print(SDKConstants.TAG, "selfieValidation: code:" + "\(responseModel.responseCode)" + " msg:" + responseModel.responseMessage!)
                
                    if responseModel.kycLink != nil {
                        let kyclinkResponseModel : KYCLinkResponseModel = responseModel.kycLink!
                        let weblink = kyclinkResponseModel.webLink
                        let mobileLink = kyclinkResponseModel.mobileLink
                        let linkExpiryDateTime = kyclinkResponseModel.linkExpiryDateTime
                        plKycResponse.webLink = weblink
                        plKycResponse.mobileLink = mobileLink
                        plKycResponse.linkExpiryDateTime = linkExpiryDateTime
                    }
                    
                    if responseModel.additionalInfoDetail != nil{
                        plKycResponse.additionalInfoDetail = responseModel.additionalInfoDetail
                    }
                    plKycResponse.ckycUniqueId = responseModel.ckycUniqueId
                    completion(plKycResponse, nil)
                } catch let error {
                    print("\(SDKConstants.TAG) Error: \(error)")
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
    
    public func setAPITimeout(_ newValue:Int){
        self.timeout = newValue
    }
    
    
}





