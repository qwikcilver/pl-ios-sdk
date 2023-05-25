//
//  File.swift
//  
//
//  Created by Macbook on 12/05/23.
//

import Foundation
@testable import pl_ios_sdk_library

class CardDetailResponseStub {
    static func getMaskedCardDetailResponseStub() -> CardDetailResponse {
        let cardDetailResponse = CardDetailResponse()
        cardDetailResponse.cardNumber = "XXXX XXXX XXXX XXXX"
        cardDetailResponse.cardValidFromDate = "XX/XX"
        cardDetailResponse.cardValidToDate = "XX/XX"
        cardDetailResponse.cvv2 = "XXX"
        return cardDetailResponse
    }
}
