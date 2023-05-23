//
//  PinePerksSession.swift
//  Pliossdk
//
//  Created by Macbook on 26/03/23.
//

import Foundation
import Security
import CryptoKit

class PinePerksSession {
    public static let sessionPK = PinePerksSession()
    
    init() {}
    
    func setCardId(_ cardSessionId: String) -> Bool{
        guard !cardSessionId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        return KeychainHelper.save(string: cardSessionId)
    }
    
    func getCardId() -> String? {
        return KeychainHelper.load()
    }
    
    func clearCardId() {
        KeychainHelper.delete()
    }
}
