//
//  PLCardResponse.swift
//  Pliossdk
//
//  Created by Macbook on 09/04/23.
//

import Foundation
public class PLCardResponse {
    
    public  var responseCode: Int
    public var responseMessage: String
    public var event: String
    
    init(responseCode: Int = 0, responseMessage: String = "", event: String = "") {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.event = event
    }
    
    var description: String {
        return "PLCardResponse{responseCode=\(responseCode), responseMessage='\(responseMessage)', event='\(event)'}"
    }
}
