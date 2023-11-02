//
//  AdditionalInfoDetail.swift
//  pl-ios-sdk
//
//  Created by Isak sayyed on 10/08/23.
//

import Foundation

public class AdditionalInfoDetail: Codable {
    
    public var customerSignature: String?
    
    init(customerSignature : String) {
        self.customerSignature = customerSignature
    }
    
    enum CodingKeys: String, CodingKey {
        case customerSignature
    }
}
