//
//  PinePerksKYCTest.swift
//  
//
//  Created by Macbook on 12/05/23.
//

import XCTest
import Network
@testable import pl_ios_sdk_library

class PinePerksKYCTest: XCTestCase {

    private var pinePerksKycService: PinePerksKYCService!

    override func setUp() {
        super.setUp()
        pinePerksKycService = PinePerksKYCService(baseUrl: "https://apiuat.pineperks.in", credential: "te9zvDWnZ1nMqB2KViWnbw==",selectedVersion: "v1")
    }
    
    func testGivenCkycUniqueIdAndImageData_WhenDetailIsBlank_thenReturnSDKResponse() throws {
        pinePerksKycService.selfieValidation(ckycUniqueId: "", selfieImageData: "") { response, error in
            XCTAssertEqual(response?.responseCode, 1004)
        }
    }
    
    func testGivenCkycUniqueIdAndImageData_WhenDetailsArePassed_thenReturnSDKResponse() throws {
        // Arrange
        let mockKYCService = MockPinePerksKYCService(baseUrl: "https://example.com", credential: "testUser",selectedVersion: "v1")
        
        let ckycUniqueId = "rVoJ8Ku-swAYxuqi2Ue3yyUXHHVBCnNaRlfAAAQ7m.YyOCvgwi4b1HgOBdZYW7pIytdb4JZw9bptHo8ArAioLWvahlpt0d7Wqg528Xsfw741"
        let imageData = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQ4AAAEcCAYAAAA2r1o1AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJc"
        
        mockKYCService.selfieValidation(ckycUniqueId: ckycUniqueId, selfieImageData: imageData) { response, error in
            XCTAssertTrue(mockKYCService.isSelfieValidationCalled)
            XCTAssertEqual(response?.responseCode, 0)
            XCTAssertEqual(response?.responseMessage, "Successful")
        }
    }

}

