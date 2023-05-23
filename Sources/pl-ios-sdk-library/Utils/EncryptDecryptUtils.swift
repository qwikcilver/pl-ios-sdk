//
//  EncryptDecryptUtils.swift
//  Pliossdk
//
//  Created by Macbook on 03/04/23.
//

import Foundation
import CommonCrypto

public class EncryptDecryptUtils {
    
    private static let encAlgo = kCCAlgorithmAES128
    private static let decAlgo = kCCAlgorithmAES128
    
    public static func generateEncryptionKey() -> String? {
        var keyData = Data(count: 16)
        let result = keyData.withUnsafeMutableBytes { mutableBytes in
            SecRandomCopyBytes(kSecRandomDefault, 16, mutableBytes.baseAddress!)
        }
        guard result == errSecSuccess else {
            print("\(SDKConstants.TAG) Failed to generate random key data")
            return nil
        }
        return keyData.base64EncodedString()
    }
    
    public static func encryptData(_ data: String, symmetricKey: String) -> String? {
        guard let keyData = Data(base64Encoded: symmetricKey) else {
            print("\(SDKConstants.TAG) Invalid working key")
            return nil
        }
        let value = data.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let inputBuffer = value.data(using: .utf8) else {
            print("\(SDKConstants.TAG) Invalid input data")
            return nil
        }
        var encryptedBytes = [UInt8](repeating: 0, count: inputBuffer.count + kCCBlockSizeAES128)
        let keyLength = size_t(kCCKeySizeAES128)
        let options = CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding)
        var numBytesEncrypted = 0
        let cryptStatus = keyData.withUnsafeBytes { keyBytes in
            inputBuffer.withUnsafeBytes { inputBytes in
                CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), options,
                        keyBytes.baseAddress, keyLength, nil, inputBytes.baseAddress, inputBuffer.count,
                        &encryptedBytes, encryptedBytes.count, &numBytesEncrypted)
            }
        }
        guard cryptStatus == kCCSuccess else {
            print("\(SDKConstants.TAG) Encryption failed with status: \(cryptStatus)")
            return nil
        }
        let encryptedData = Data(bytes: encryptedBytes, count: numBytesEncrypted)
        return encryptedData.base64EncodedString()
    }
    
    public static func decryptData(workingKey: String, data: String) -> String? {
        guard let keyData = Data(base64Encoded: workingKey) else {
            print("\(SDKConstants.TAG) Invalid working key")
            return nil
        }
        guard let inputData = Data(base64Encoded: data) else {
            print("\(SDKConstants.TAG) Invalid input data")
            return nil
        }
        var decryptedBytes = [UInt8](repeating: 0, count: inputData.count + kCCBlockSizeAES128)
        let keyLength = size_t(kCCKeySizeAES128)
        let options = CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding)
        var numBytesDecrypted = 0
        let cryptStatus = keyData.withUnsafeBytes { keyBytes in
            inputData.withUnsafeBytes { inputBytes in
                CCCrypt(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES), options,
                        keyBytes.baseAddress, keyLength, nil, inputBytes.baseAddress, inputData.count,
                        &decryptedBytes, decryptedBytes.count, &numBytesDecrypted)
            }
        }
        guard cryptStatus == kCCSuccess else {
            print("\(SDKConstants.TAG) Decryption failed with status: \(cryptStatus)")
            return nil
        }
        let decryptedData = Data(bytes: decryptedBytes, count: numBytesDecrypted)
        return String(bytes: decryptedData, encoding: .utf8)
    }
}

