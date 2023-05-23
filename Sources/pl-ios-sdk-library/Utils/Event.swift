//
//  Event.swift
//  Pliossdk
//
//  Created by Macbook on 24/03/23.
//

import Foundation

public enum Event: String, CustomStringConvertible {
    case showCard = "showCard"
    case hideCard = "hideCard"
    case showCardOtp = "showCardOtp"
    case changePin = "changePin"
    case changePinOtp = "changePinOtp"
    case resendOtp = "resendOtp"
    case minKycToken = "minKycToken"
    case minKyc = "minKyc"
    case selfieValidation = "selfieValidation"
    
    public var description: String {
        return self.rawValue
    }
}
