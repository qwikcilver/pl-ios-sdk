//
//  File.swift
//  
//
//  Created by Macbook on 12/05/23.
//

import Foundation
import UIKit
import XCTest
@testable import pl_ios_sdk_library

@available(iOS 11.0, *)
class CardManagerTest: XCTestCase,PliossdkResponseDelegate {
    func didReceivePliossdkResponse(_ data: PLKYCResponse) {
        
    }
    
    func didReceivePliossdkCardResponse(_ data: PLCardResponse) {
        
    }
    
    var cardManagementService: CardManagementService!
    var cardManager: CardManager!
    
    override func setUp() {
        super.setUp()
        cardManager = CardManager()
    }
    
    func testGivenContext_whenUrlPassedToPinePerksWebViewIsNull_thenWebViewWillNotBeOpened() {
        let pineLabsSDK = PineLabsSDK(url: "", delegate: self)
        let cardManager = pineLabsSDK.getCardManager()
        let mockController = UIViewController()
        XCTAssertThrowsError(try cardManager?.openCardViewLink(controller: mockController))
    }
    
    func testGivenContext_whenUrlPassedToPinePerksWebViewIsEmpty_thenWebViewWillNotBeOpened() {
        let pineLabsSDK = PineLabsSDK(url: "", delegate: self)
        let cardManager = pineLabsSDK.getCardManager()
        let mockController = UIViewController()
        XCTAssertThrowsError(try cardManager?.openCardViewLink(controller: mockController))
    }
    
    func testGivenContext_whenUrlPassedToPinePerksWebViewIsBlank_thenWebViewWillNotBeOpened() {
        let pineLabsSDK = PineLabsSDK(url: "", delegate: self)
        let cardManager = pineLabsSDK.getCardManager()
        let mockController = UIViewController()
        XCTAssertThrowsError(try cardManager?.openCardViewLink(controller: mockController))
    }
    
    func testGivenInitializeRequest_WhenUrlIsPassed_ThenReturnKey() {
        let pineLabsSDK = PineLabsSDK(url: "https://apiuat.pineperks.in", delegate: self)
        let cardManager = pineLabsSDK.getCardManager()
        let key = cardManager?.getRandomKey()
        XCTAssertNotNil(key)
    }
}
