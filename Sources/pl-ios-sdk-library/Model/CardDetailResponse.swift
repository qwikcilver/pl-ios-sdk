//
//  CardDetailResponse.swift
//  Pliossdk
//
//  Created by Macbook on 05/04/23.
//

import Foundation

public class CardDetailResponse: Codable {
    public var sessionId : String?
    public var checksum : String?
    public var cardNumber : String?
    public var cvv2 : String?
    public var cardValidFromDate : String?
    public var cardValidToDate : String?
    public var responseCode : Int?
    public var responseMessage : String?
    
    init(data: NSDictionary) {
        self.sessionId = data.object(forKey: CodingKeys.sessionId.stringValue) as? String
        self.checksum = data.object(forKey: CodingKeys.checksum.stringValue) as? String
        
        self.cardNumber = data.object(forKey: CodingKeys.cardNumber.stringValue) as? String
        
        self.cvv2 = data.object(forKey: CodingKeys.cvv2.stringValue) as? String
        
        self.cardValidFromDate = data.object(forKey: CodingKeys.cardValidFromDate.stringValue) as? String
        
        self.cardValidToDate = data.object(forKey: CodingKeys.cardValidToDate.stringValue) as? String
        
        self.responseCode = data.object(forKey: CodingKeys.responseCode.stringValue) as? Int
        
        self.responseMessage = data.object(forKey: CodingKeys.responseMessage.stringValue) as? String
    }
    
    init(){}
    
    enum CodingKeys: String, CodingKey {
        case sessionId
        case checksum
        case cardNumber
        case cvv2
        case cardValidFromDate
        case cardValidToDate
        case responseCode
        case responseMessage
    }
}
