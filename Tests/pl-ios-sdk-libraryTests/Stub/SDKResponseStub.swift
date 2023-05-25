//
//  File.swift
//  
//
//  Created by Macbook on 12/05/23.
//

@testable import pl_ios_sdk_library
class SDKResponseStub {
    static func getSDKResponseStub() -> PLCardResponse {
        return PLCardResponse(responseCode: 0, responseMessage: "successful", event: Event.hideCard.rawValue)
    }
}
