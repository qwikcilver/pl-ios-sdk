//
//  PinePerksResponseStub.swift
//  PliossdkTests
//
//  Created by Macbook on 11/05/23.
//

import Foundation
@testable import pl_ios_sdk_library

public class PinePerksResponseStub {
    public static func getPinePerksResponseSuccessfulStub() -> PinePerksResponse {
        let stubResponse = PinePerksResponse()
        // Set the desired values for the properties
        stubResponse.checksum = ""
        stubResponse.responseCode = 2004
        stubResponse.responseMessage = "Success"
        return stubResponse
    }
}
