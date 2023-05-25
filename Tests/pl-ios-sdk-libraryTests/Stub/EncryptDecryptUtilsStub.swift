//
//  File.swift
//  
//
//  Created by Macbook on 12/05/23.
//

import Foundation
import CommonCrypto
@testable import pl_ios_sdk_library

class EncryptDecryptUtilsStub {
    static func getRandomKeyStub() -> String {
        return "ad7XD/8TfZjMg2nmrSH0eA=="
    }
    
    static func encryptedData(randomKey: String, data: String) -> String? {
        guard let keyData = Data(base64Encoded: randomKey) else {
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
}
