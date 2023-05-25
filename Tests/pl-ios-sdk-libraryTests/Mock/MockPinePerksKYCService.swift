//
//  File.swift
//  
//
//  Created by Macbook on 17/05/23.
//

@testable import pl_ios_sdk_library

class MockPinePerksKYCService: PinePerksKYCService {
    var isSelfieValidationCalled = false
    var selfieValidationCompletion: ((PLKYCResponse?, Error?) -> Void)?
    
    override func selfieValidation(ckycUniqueId: String, selfieImageData: String, completion: @escaping (PLKYCResponse?, Error?) -> Void) {
        isSelfieValidationCalled = true
        selfieValidationCompletion = completion
        let plKycResponse = PLKYCResponse(responseCode: ResponseCodes.SUCCESS.rawValue, responseMessage: ResponseMessage.SUCCESS.rawValue,event:Event.selfieValidation.description)
        completion(plKycResponse, nil)
    }
}

