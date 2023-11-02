//
//  File.swift
//  
//
//  Created by Macbook on 12/05/23.
//

import Foundation
import CommonCrypto
@testable import pl_ios_sdk_library

class PinePerksSecretStub {
    static func getPinePerksSecretStub() -> PinePerksSecret {
        return PinePerksSecret(
            clientKey: "qRmzm1zwcbFCbr0fCCVoV0Tb8FLwZhFjGoRSMxQLthQ=",
            referenceNumber: "XJViazjhXMDRCtQE8ay4NA==",
            credential: "te9zvDWnZ1nMqB2KViWnbw=="
        )
    }
    
    static func getClientKey(randomKey: String) -> String? {
            
            guard let keyData = Data(base64Encoded: "DghfXAgZL9gIC9KNE8eF2g==") else {
                print("\(SDKConstants.TAG) Invalid working key")
                return nil
            }
            let value = randomKey.trimmingCharacters(in: .whitespacesAndNewlines)
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

