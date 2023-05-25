//
//  File.swift
//  
//
//  Created by Macbook on 12/05/23.
//

import Foundation
@testable import pl_ios_sdk_library

class SelfieValidationResponseModelStub {
    static func getSelfieValidationResponse() -> SelfieValidationResponseModel {
        
        let stubResponse = SelfieValidationResponseModel()

        // Set the desired values for the properties
        stubResponse.responseCode = 2004
        stubResponse.responseMessage = "Success"
        return stubResponse
    }
}
