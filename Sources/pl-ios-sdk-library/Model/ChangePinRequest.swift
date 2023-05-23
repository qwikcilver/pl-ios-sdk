//
//  ChangePinRequest.swift
//  Pliossdk
//
//  Created by Macbook on 12/04/23.
//

import Foundation

class ChangePinRequest: Codable {
    let cardPIN: String
    let referenceNumber: String
    let clientKey: String
    
    init(cardPIN: String, referenceNumber: String,clientKey: String) {
        self.cardPIN = cardPIN
        self.referenceNumber = referenceNumber
        self.clientKey = clientKey
    }
}
