//
//  ResendOtpRequest.swift
//  Pliossdk
//
//  Created by Macbook on 12/04/23.
//

import Foundation

class ResendOtpRequest : Codable{
    var checksum: String
    
    init(checksum: String) {
        self.checksum = checksum
    }
}
