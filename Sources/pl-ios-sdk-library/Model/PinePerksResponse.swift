//
//  PinePerksResponse.swift
//  Pliossdk
//
//  Created by Rakesh salian on 08/05/23.
//

import Foundation

public class PinePerksResponse: Codable {
    public var checksum : String?
    public var responseCode : Int?
    public var responseMessage : String?
    
    init(data: NSDictionary) {
        
        self.checksum = data.object(forKey: CodingKeys.checksum.stringValue) as? String
        
        self.responseCode = data.object(forKey: CodingKeys.responseCode.stringValue) as? Int
        
        self.responseMessage = data.object(forKey: CodingKeys.responseMessage.stringValue) as? String
    }
    
    init(){}
    
    enum CodingKeys: String, CodingKey {
        case checksum
        case responseCode
        case responseMessage
    }
}
