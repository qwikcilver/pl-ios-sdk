//
//  APIUtil.swift
//  Pliossdk
//
//  Created by Macbook on 22/03/23.
//

import Foundation

class APIUtil {
    
    /* Version 1 urls */
    internal static let getCardDetailV1 = "/v1/sdk/cards/view/attribute"
    internal static let validateViewCardOTPV1 = "/v1/sdk/cards/view/validate/otp"
    internal static let changePinV1 = "/v1/cards/setpin"
    internal static let validateChangePinOTPV1 = "/v1/sdk/cards/setpin/validate/otp"
    internal static let resendOTPV1 = "/v1/sdk/cards/resend/otp"
    internal static let selfieValidationV1 = "/v1/sdk/kycs/validate/selfie/image"
    
    /* Version 2 urls */
    internal static let getCardDetailV2 = "/v2/sdk/cards/view/attribute"
    internal static let validateViewCardOTPV2 = "/v2/sdk/cards/view/validate/otp"
    internal static let changePinV2 = "/v2/cards/setpin"
    internal static let validateChangePinOTPV2 = "/v2/sdk/cards/setpin/validate/otp"
    internal static let resendOTPV2 = "/v2/sdk/cards/resend/otp"
    internal static let selfieValidationV2 = "/v2/sdk/kycs/validate/selfie/image"
   
  
    static let apiData : [Event: [String :String]] = [
        Event.showCard:[Version.Version_1.rawValue:getCardDetailV1,
                                 Version.Version_2.rawValue:getCardDetailV2],
        Event.showCardOtp:[Version.Version_1.rawValue:validateViewCardOTPV1,
                                    Version.Version_2.rawValue:validateViewCardOTPV2],
        Event.changePin:[Version.Version_1.rawValue:changePinV1,
                                  Version.Version_2.rawValue:changePinV2],
        Event.changePinOtp:[Version.Version_1.rawValue:validateViewCardOTPV1,
                                     Version.Version_2.rawValue:validateChangePinOTPV2],
        Event.resendOtp:[Version.Version_1.rawValue:resendOTPV1,
                                  Version.Version_2.rawValue:resendOTPV2],
        Event.selfieValidation:[Version.Version_1.rawValue:selfieValidationV1,
                                         Version.Version_2.rawValue:selfieValidationV2]
    ]
    
    static func getURL(baseUrl:String, selectedVersion:String,event:Event) -> URL{
        guard let eventDict = apiData[event],
              let url = eventDict[selectedVersion] else {
            return URL(string:baseUrl)!
        }
        return URL(string: baseUrl + url)!
    }
    
    static func createHeaderWithVersion(credential:String,selectedVersion:String)-> [String: String]{
        return (selectedVersion == Version.Version_1.rawValue) ? createHeaderForV1(username: credential) : createHeaderForV2(authToken: credential)
    }
    
    static func createHeaderForV1(username:String) -> [String: String]{
        let headers = [
            "Content-Type": "application/json",
            "X-PinePerks-UserName": username
        ]
        return headers
    }
    
    static func createHeaderForV2(authToken:String) -> [String: String]{
        let headers = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        return headers
    }
}
