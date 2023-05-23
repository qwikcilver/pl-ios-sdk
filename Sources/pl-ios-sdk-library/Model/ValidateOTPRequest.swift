//
//  ValidateOTPRequest.swift
//  Pliossdk
//
//  Created by Macbook on 09/04/23.
//

import Foundation

class ValidateOTPRequest: Codable {
    let checksum: String
    let otp: String
    
    init(checksum: String, otp: String) {
        self.checksum = checksum
        self.otp = otp
    }
}
