//
//  SelfieEncryption.swift
//  Pliossdk
//
//  Created by Macbook on 16/03/23.

import Foundation
import CommonCrypto
import CryptoKit

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
           
            let base64Index = content.distance(from: content.startIndex, to: base64TagIndex)
            let dataImageIndex = content.distance(from: content.startIndex, to: dataImageTagIndex)
            let encryptedImageStartIndex1 = base64Index + BASE_64_TAG.count
            let dataImageTagEndIndex1 = dataImageIndex + DATA_IMAGE_TAG.count
            let imageFormat1 = content.prefix(base64Index).suffix(base64Index - dataImageIndex)
            let originalEncryptedBytes = content.suffix(from: content.index(content.startIndex, offsetBy: encryptedImageStartIndex1))
            let rowChecksum = "\(originalEncryptedBytes.prefix(8))\(originalEncryptedBytes.suffix(8))\(imageFormat1)\(originalEncryptedBytes.count)\(ckycUniqueId.prefix(8).suffix(8))"
            
            guard let hashedChecksum = encryptData(data: rowChecksum) else {
                return nil
            }
            
            let hashedChecksum1 = try encryptData(rowChecksum,  symmetricKey: "p!neL@bs12345678")
        
            return hashedChecksum1
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
    
   
    public static func encryptData(_ data: String, symmetricKey: String) -> String? {
        guard let keyData = symmetricKey.data(using: .utf8) else {
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
