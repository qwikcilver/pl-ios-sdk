//
//  File.swift
//  
//
//  Created by Aman Singh on 04/07/23.
//

import Foundation

class KYCLinkResponseModel: Decodable {
    public var webLink: String?
    public var mobileLink: String?
    public var linkExpiryDateTime: String?
   
    
    init(webLink: String?, mobileLink: String?, linkExpiryDateTime: String?) {
        self.webLink = webLink
        self.mobileLink = mobileLink
        self.linkExpiryDateTime = linkExpiryDateTime
        
    }
}
