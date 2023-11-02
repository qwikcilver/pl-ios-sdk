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
    var credential: String
    var checksum: String?
    
    init(clientKey: String, referenceNumber: String, credential: String) {
        self.clientKey = clientKey
        self.referenceNumber = referenceNumber
        self.credential = credential
    }
    
    func getcredential() -> String {
        return credential
    }
    
    func setcredential(credential: String) {
        self.credential = credential
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
