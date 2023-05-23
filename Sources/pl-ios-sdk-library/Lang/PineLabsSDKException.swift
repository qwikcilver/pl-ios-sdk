//
//  PineLabsSDKException.swift
//  Pliossdk
//
//  Created by Macbook on 09/04/23.
//

import Foundation

public class PineLabsSDKException: Error {
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    var errorMessage: String {
        return message
    }
}

