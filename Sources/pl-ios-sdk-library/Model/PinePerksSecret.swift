//
//  PinePerksSecret.swift
//  Pliossdk
//
//  Created by Macbook on 06/04/23.
//

import Foundation
class PinePerksSecret {
    var clientKey: String
    var referenceNumber: String
    var username: String
    var checksum: String?
    
    init(clientKey: String, referenceNumber: String, username: String) {
        self.clientKey = clientKey
        self.referenceNumber = referenceNumber
        self.username = username
    }
    
    func getUsername() -> String {
        return username
    }
    
    func setUsername(username: String) {
        self.username = username
    }
    
    func getReferenceNumber() -> String {
        return referenceNumber
    }
    
    func setReferenceNumber(referenceNumber: String) {
        self.referenceNumber = referenceNumber
    }
    
    func getClientKey() -> String {
        return clientKey
    }
    
    func setClientKey(clientKey: String) {
        self.clientKey = clientKey
    }
    
    func getChecksum() -> String? {
        return checksum
    }
    
    func setChecksum(checksum: String?) {
        self.checksum = checksum
    }
}
