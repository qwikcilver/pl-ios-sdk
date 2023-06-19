//
//  PLKYCResponse.swift
//  CamStarter
//
//  Created by Macbook on 17/03/23.
//

import Foundation

public class PLKYCResponse: Codable {
    public var responseCode: Int
    public var responseMessage: String
    public var minKycLink: String?
    public var event: String?
    public var ckycUniqueId : String?
    public var kycLink : String?
    
    init(responseCode: Int, responseMessage: String, event: String? = nil) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.event = event
    }
    
    enum CodingKeys: String, CodingKey {
        case responseCode
        case responseMessage
        case minKycLink
        case event
    }
}
