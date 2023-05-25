//
//  CardManagementServiceTest.swift
//  Pliossdk
//
//  Created by Macbook on 10/05/23.
//

import XCTest
@testable import pl_ios_sdk_library

@available(iOS 11.0, *)
class CardManagementServiceTest: XCTestCase {

    var cardManagementService: CardManagementService!
    var pinePerksSecret: PinePerksSecret!
    
    override func setUp() {
        super.setUp()
        cardManagementService = CardManagementService(baseUrl: "https://apiuat.pineperks.in")
        cardManagementService.setCredentials(session: PinePerksSession.sessionPK, clientKey: "SJh7AkADjjGkJg5DnnB2Les6gg9XxLIN+p2f4Np3iBc=", referenceNumber: "XJViazjhXMDRCtQE8ay4NA==", username: "te9zvDWnZ1nMqB2KViWnbw==")
        
        cardManagementService.pinePerksSecret?.checksum = "bzh23j-nxha78i-932jja"
        cardManagementService.getRandomKey()
    }
    
    func testGivenAnInitializeRequest_WhenUrlIsPassed_thenReturnRandomKey() {
        let key = cardManagementService.getRandomKey()
        XCTAssertNotEqual(key, "Det5EsA6s0n3utHv2PEBVg==")
    }
    
    func testGivenAChangePinRequest_WhenPinIsProper_thenReturnSDKResponse() throws {
            let mockCardManagementService = MockCardManagementService(baseUrl: "https://apiuat.pineperks.in")
            mockCardManagementService.getRandomKey()
            mockCardManagementService.setCredentials(session: PinePerksSession.sessionPK, clientKey: "SJh7AkADjjGkJg5DnnB2Les6gg9XxLIN+p2f4Np3iBc=", referenceNumber: "XJViazjhXMDRCtQE8ay4NA==", username: "te9zvDWnZ1nMqB2KViWnbw==")
            
            try? mockCardManagementService.changePin(pin: "1234")
            XCTAssertTrue(mockCardManagementService.isValidatePinePerksCredentialsCalled)
            XCTAssertTrue(mockCardManagementService.isCallChangePinAPICalled)
            XCTAssertEqual(mockCardManagementService.receivedPin, "1234")
            XCTAssertEqual(mockCardManagementService.recievedresponse?.responseCode, 2004)
        
    }
    
    func testGivenAChangePinRequest_WhenPinIsBlank_thenReturnBlank() throws {
        XCTAssertThrowsError(try cardManagementService.changePin(pin: ""))
    }
    
    func testGivenAChangePinRequest_WhenPinNotFourDigit_thenReturnNull() throws {
        XCTAssertThrowsError(try cardManagementService.changePin(pin: "12"))
    }
    
    func testGivenAValidateChangePinOTPRequest_WhenOTPIsValid_thenReturnSDKResponse() throws {
        let mockCardManagementService = MockCardManagementService(baseUrl: "https://apiuat.pineperks.in")
        mockCardManagementService.getRandomKey()
        mockCardManagementService.setCredentials(session: PinePerksSession.sessionPK, clientKey: "SJh7AkADjjGkJg5DnnB2Les6gg9XxLIN+p2f4Np3iBc=", referenceNumber: "XJViazjhXMDRCtQE8ay4NA==", username: "te9zvDWnZ1nMqB2KViWnbw==")
        mockCardManagementService.pinePerksSecret?.checksum = "bzh23j-nxha78i-932jja"
        try? mockCardManagementService.validateViewCardOTP(otp: "123456",event: Event.changePinOtp)
        XCTAssertTrue(mockCardManagementService.isValidatePinePerksCredentialsCalled)
        XCTAssertTrue(mockCardManagementService.isCallValidateChangePinOTPAPICalled)
        XCTAssertEqual(mockCardManagementService.receivedPin, "123456")
        XCTAssertEqual(mockCardManagementService.recievedresponse?.responseCode, 2004)
    }
    
    func testGivenAValidateChangePinOTPRequest_WhenOTPIsBlank_thenReturnWithError() throws {
        XCTAssertThrowsError(try cardManagementService.validateViewCardOTP(otp: "",event: Event.changePinOtp))
    }
    
    func testGivenAValidateChangePinOTPRequest_WhenOTPIsNotSixDigit_thenReturnNull() throws {
        XCTAssertThrowsError(try cardManagementService.validateViewCardOTP(otp: "12345",event: Event.changePinOtp))
    }
    
    func testGivenAResendOTPRequest_WhenTypeIsPin_thenReturnSDKResponse() throws {
        let mockCardManagementService = MockCardManagementService(baseUrl: "https://apiuat.pineperks.in")
        mockCardManagementService.getRandomKey()
        mockCardManagementService.setCredentials(session: PinePerksSession.sessionPK, clientKey: "SJh7AkADjjGkJg5DnnB2Les6gg9XxLIN+p2f4Np3iBc=", referenceNumber: "XJViazjhXMDRCtQE8ay4NA==", username: "te9zvDWnZ1nMqB2KViWnbw==")
        mockCardManagementService.pinePerksSecret?.checksum = "bzh23j-nxha78i-932jja"
        try? mockCardManagementService.validateViewCardOTP(otp: "123456",event: Event.changePinOtp)
        XCTAssertTrue(mockCardManagementService.isValidatePinePerksCredentialsCalled)
        XCTAssertTrue(mockCardManagementService.isCallValidateChangePinOTPAPICalled)
        XCTAssertEqual(mockCardManagementService.receivedPin, "123456")
        XCTAssertEqual(mockCardManagementService.recievedresponse?.responseCode, 2004)
    }
    
    func testGivenAResendOTPRequest_WhenTypeIsNotPin_thenReturnSDKResponse() throws {
        let mockCardManagementService = MockCardManagementService(baseUrl: "https://apiuat.pineperks.in")
        mockCardManagementService.getRandomKey()
        mockCardManagementService.setCredentials(session: PinePerksSession.sessionPK, clientKey: "SJh7AkADjjGkJg5DnnB2Les6gg9XxLIN+p2f4Np3iBc=", referenceNumber: "XJViazjhXMDRCtQE8ay4NA==", username: "te9zvDWnZ1nMqB2KViWnbw==")
        mockCardManagementService.pinePerksSecret?.checksum = "bzh23j-nxha78i-932jja"
        mockCardManagementService.resendOTP()
        XCTAssertTrue(mockCardManagementService.isValidatePinePerksCredentialsCalled)
        XCTAssertTrue(mockCardManagementService.isCallResendOTPAPICalled)
        XCTAssertEqual(mockCardManagementService.recievedresponse?.responseCode, 2004)
    }
}
       
