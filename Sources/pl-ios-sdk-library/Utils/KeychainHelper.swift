//
//  KeychainHelper.swift
//  Pliossdk
//
//  Created by Macbook on 26/03/23.
//

import Foundation
import UIKit
import Security

class KeychainHelper {
    
    private static let service = "com.cam.ai.Pliossdk"
    private static let account = "cardSessionId"
    
    static func save(string: String) -> Bool {
        guard let data = string.data(using: .utf8) else {
            return false
        }
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }
    
    static func load() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let string = String(data: data, encoding: .utf8) {
                return string
            }
        }
        return nil
    }
    
    static func delete() -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
}
