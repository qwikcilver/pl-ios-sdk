//
//  File.swift
//  
//
//  Created by Macbook on 12/05/23.
//

import Foundation
import XCTest
@testable import pl_ios_sdk_library

@available(iOS 10.0, *)
class KYCManagerTest: XCTestCase,PliossdkResponseDelegate {
    func didReceivePliossdkResponse(_ data: PLKYCResponse) {
        
    }
    
    func didReceivePliossdkCardResponse(_ data: PLCardResponse) {
        
    }
    
    func testGivenContext_whenUrlPassedToMinKycWebViewIsNull_thenWebViewWillNotBeOpened() {
        let pineLabsSDK = PineLabsSDK(url: "", delegate: self)
        let kycManager = pineLabsSDK.getKycManager()
        
        XCTAssertFalse(kycManager != nil)
    }
    
    func testGivenContext_whenRequiredPassedToMinKycWebViewIsEmpty_thenWebViewWillNotBeOpened() {
        let bU = "https://apiuat.pineperks.in"
        let pineLabsSDK = PineLabsSDK(url: bU, delegate: self)
        let kycManager = pineLabsSDK.getKycManager()
        
        XCTAssertFalse(kycManager == nil)
    }
    
    func testGivenContext_whenRequiredPassedToMinKycWebViewIsBlank_thenWebViewWillNotBeOpened() {
        let bU = "https://apiuat.pineperks.in"
        let pineLabsSDK = PineLabsSDK(url: bU, delegate: self)
        let kycManager = pineLabsSDK.getKycManager()
        
        XCTAssertFalse(kycManager == nil)
    }
    
    func testGivenContext_whenUrlPassedToSelfieValidationIsNull_thenActivityWillNotBeOpened() {
        let pineLabsSDK = PineLabsSDK(url: "", delegate: self)
        let kycManager = pineLabsSDK.getKycManager()
        
        XCTAssertFalse(kycManager != nil)
    }
    
    func testGivenContext_whenRequiredDetailsPassedToSelfieValidationIsEmpty_thenActivityWillNotBeOpened() {
        let bU = "https://apiuat.pineperks.in"
        let pineLabsSDK = PineLabsSDK(url: bU, delegate: self)
        let kycManager = pineLabsSDK.getKycManager()
        let mockController = UIViewController()
        XCTAssertThrowsError(try kycManager?.initiateSelfieValidation(controller: mockController,  ckycUniqueId: ""))
    }
    
    func testGivenContext_whenRequiredDetailsPassedToSelfieValidationIsBlanked_thenActivityWillNotBeOpened() {
        let bU = "https://apiuat.pineperks.in"
        let pineLabsSDK = PineLabsSDK(url: bU, delegate: self)
        let kycManager = pineLabsSDK.getKycManager()
        let mockController = UIViewController()
        XCTAssertThrowsError(try kycManager?.initiateSelfieValidation(controller: mockController, ckycUniqueId: ""))
    }
}
