//
//  File.swift
//  
//
//  Created by Macbook on 14/05/23.
//

import Foundation
@testable import pl_ios_sdk_library

@available(iOS 11.0, *)
class MockCardManagementService: CardManagementService {
    var isValidatePinePerksCredentialsCalled = false
    var isCallChangePinAPICalled = false
    var receivedPin: String?
    var receivedChangePinRequest: Encodable?
    var receivedEvent: Event?
    var isCallValidateChangePinOTPAPICalled = false
    var receivedOTP: String?
    var recievedresponse :PinePerksResponse?
    var isCallResendOTPAPICalled = false
    
    override func validatePinePerksCredentials() throws {
        isValidatePinePerksCredentialsCalled = true
    }
    
    override func callChangePinAPI<T: Encodable>(changePinRequest: T, event: Event) {
        isCallChangePinAPICalled = true
        receivedChangePinRequest = changePinRequest
        receivedEvent = event
        receivedPin = "1234"
        recievedresponse = PinePerksResponseStub.getPinePerksResponseSuccessfulStub()
    }
    
    override func callValidateChangePinOTPAPI<T: Encodable>(validateOTPRequest: T, event:Event) {
        isCallValidateChangePinOTPAPICalled = true
        receivedOTP = (validateOTPRequest as? ValidateOTPRequest)?.otp
        receivedEvent = event
        receivedPin = "123456"
        recievedresponse = PinePerksResponseStub.getPinePerksResponseSuccessfulStub()
    }
    
    override func callResendOTPAPI<T: Encodable>(resendOtpRequest: T, event: Event) {
        isCallResendOTPAPICalled = true
        recievedresponse = PinePerksResponseStub.getPinePerksResponseSuccessfulStub()
    }

}
