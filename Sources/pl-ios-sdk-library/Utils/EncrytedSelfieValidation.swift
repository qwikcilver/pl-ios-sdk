//
//  SelfieEncryption.swift
//  Pliossdk
//
//  Created by Macbook on 16/03/23.
//

import Foundation
import CommonCrypto

class EncryptedSelfieValidationImage {
    
    private static let BASE_64_TAG = ";base64,"
    private static let DATA_IMAGE_TAG = "data:image/"
    private static let ALGORITHM_AES = kCCAlgorithmAES128
    private static let keyBytes: [UInt8] = "p!neL@bs12345678".utf8.map { $0 }
    private static let secretKey = keyBytes.withUnsafeBytes {
        return Data(Array($0.bindMemory(to: UInt8.self)))
    }
    
    static func getEncryptedSelfieImage(base64Image: String, ckycUniqueId: String) -> String? {
        do {
//            let base64Image = imageByte.base64EncodedString()
            let data = "data:image/jpeg;base64,"
            let content = data + base64Image
            guard let checkSum = try getSelfieValidationCheckSum(content: content, ckycUniqueId: ckycUniqueId) else {
                return nil
            }
            let selfieImageData = content + "~" + checkSum
            return selfieImageData
        } catch {
            print("\(SDKConstants.TAG) Exception occurred while selfie image encryption -- \(error)")
            return nil
        }
    }
    
    private static func getSelfieValidationCheckSum(content: String, ckycUniqueId: String) throws -> String? {
        if let base64TagIndex = content.range(of: BASE_64_TAG)?.lowerBound,
           let dataImageTagIndex = content.range(of: DATA_IMAGE_TAG)?.upperBound {
            let encryptedImageStartIndex = content.index(base64TagIndex, offsetBy: BASE_64_TAG.count)
            let dataImageTagEndIndex = content.index(dataImageTagIndex, offsetBy: -1)
            let imageFormat = String(content[dataImageTagEndIndex..<dataImageTagIndex])
            let originalEncryptedBytes = String(content[encryptedImageStartIndex...])
            let rowChecksum = "\(originalEncryptedBytes.prefix(8))\(originalEncryptedBytes.suffix(8))\(imageFormat)\(originalEncryptedBytes.count)\(ckycUniqueId.prefix(8))"
            guard let hashedChecksum = encryptData(data: rowChecksum) else {
                return nil
            }
            return hashedChecksum
        }
        return nil
    }
    
    private static func encryptData(data: String) -> String? {
        var rawCipher = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128)
        var numBytesEncrypted: Int = 0
        
        let status = secretKey.withUnsafeBytes { (keyPtr: UnsafeRawBufferPointer) -> CCCryptorStatus in
            data.withCString { (dataPtr: UnsafePointer<Int8>) -> CCCryptorStatus in
                CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(ALGORITHM_AES), CCOptions(kCCOptionPKCS7Padding), keyPtr.baseAddress, secretKey.count, nil, dataPtr, data.count, &rawCipher, rawCipher.count, &numBytesEncrypted)
            }
        }
        
        if status == kCCSuccess {
            let encryptedData = Data(bytes: &rawCipher, count: numBytesEncrypted)
            //return data
            return encryptedData.base64EncodedString()
        }
        return nil
    }
}
