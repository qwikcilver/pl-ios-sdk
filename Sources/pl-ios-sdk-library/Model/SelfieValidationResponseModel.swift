//
//  SelfieValidationResponseModel.swift
//  CamStarter
//
//  Created by Macbook on 17/03/23.
//

class SelfieValidationResponseModel: Decodable {
    public var ckycUniqueId: String?
    public var kycLink: String?
    public var responseMessage: String?
    public var responseCode: Int = 0
    
    init(ckycUniqueId: String?, kycLink: String?, responseMessage: String?, responseCode: Int) {
        self.ckycUniqueId = ckycUniqueId
        self.kycLink = kycLink
        self.responseMessage = responseMessage
        self.responseCode = responseCode
    }
    
    init(){}
}

