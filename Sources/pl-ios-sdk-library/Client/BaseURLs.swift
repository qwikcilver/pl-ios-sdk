//
//  BaseURLs.swift
//  Pliossdk
//
//  Created by Macbook on 22/03/23.
//

import Foundation

class BaseURLs {
    internal static let selfieURL = "/customer/profile/V1/validate/selfie/image"
    internal static let getCardDetail = "/card/profile/V1/view/attribute"
    internal static let validateViewCardOTP = "/card/profile/V1/view/attribute/validate/otp"
    internal static let changePin = "/card/profile/V1/setpin"
    internal static let validateChangePinOTP = "/card/profile/V1/setpin/validate/otp"
    internal static let resendOTPApi = "/card/profile/V1/resend/otp"

    static func createHeader(username: String) -> [String: String] {
        let headers = [
            "Content-Type": "application/json",
            "X-PinePerks-UserName": username
        ]
        return headers
    }
    
}
