//
//  CardDetailRequest.swift
//  Pliossdk
//
//  Created by Macbook on 06/04/23.
//

import Foundation
class CardDetailRequest : Codable{
    var clientKey: String
    var referenceNumber: String
    var sessionId: String?
    
    init() {
        self.clientKey = ""
        self.referenceNumber = ""
    }
    
    init(clientKey: String, referenceNumber: String, sessionId: String?) {
        self.clientKey = clientKey
        self.referenceNumber = referenceNumber
        self.sessionId = sessionId
    }
    
    func getClientKey() -> String {
        return clientKey
    }
    
    func setClientKey(clientKey: String) {
        self.clientKey = clientKey
    }
    
    func getReferenceNumber() -> String {
        return referenceNumber
    }
    
    func setReferenceNumber(referenceNumber: String) {
        self.referenceNumber = referenceNumber
    }
    
    func getSessionId() -> String? {
        return sessionId
    }
    
    func setSessionId(sessionId: String?) {
        self.sessionId = sessionId
    }
}
