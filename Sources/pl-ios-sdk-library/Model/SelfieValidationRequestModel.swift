//
//  SelfieValidationRequestModel.swift
//  CamStarter
//
//  Created by Macbook on 17/03/23.
//

class SelfieValidationRequestModel: Decodable {
    var ckycUniqueId: String?
    var selfieImageData: String?
    
    init(ckycUniqueId: String?, selfieImageData: String?) {
        self.ckycUniqueId = ckycUniqueId
        self.selfieImageData = selfieImageData
    }
}

