//
//  KYCManager.swift
//  CamStarter
//
//  Created by Macbook on 15/03/23.
//

import Foundation
import UIKit

@available(iOS 10.0, *)
public class KYCManager {
    public var url : String? = nil
    public static let mKycManager = KYCManager()
    public var message = ""
    public var delegate: PliossdkResponseDelegate?
    private init(){}
    
    public func initiateSelfieValidation(controller: UIViewController?,pinePerksUsername: String , ckycUniqueId: String ) {
        if (url != nil && !pinePerksUsername.isEmpty &&
            url != nil && controller != nil && !ckycUniqueId.isEmpty) {
            let storyboard = UIStoryboard(name: "SelfieValidation", bundle: Bundle.module)
            let vc = storyboard.instantiateViewController(withIdentifier: "selfie") as! SelfieValidationVC
            vc.pinePerksUsername = pinePerksUsername
            vc.ckycUniqueId = ckycUniqueId
            vc.url = url
            vc.mainVC = controller!
            controller?.present(vc, animated: true)
        }
    }
    
    public static func getKycManager(url: String,delegate : PliossdkResponseDelegate) -> KYCManager {
        KYCManager.mKycManager.url = url
        KYCManager.mKycManager.delegate = delegate
        return KYCManager.mKycManager
    }
}
