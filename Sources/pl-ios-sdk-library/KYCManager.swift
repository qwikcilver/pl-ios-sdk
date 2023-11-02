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
    
    public var credential:String = ""
    public var selectedVersion:String = Version.Version_2.rawValue
    public var timeout:Int = 15
    public var url : String? = nil
    public static let mKycManager = KYCManager()
    public var message = ""
    public var delegate: PliossdkResponseDelegate?
    private init(){}
    
    public func initiateSelfieValidation(controller: UIViewController?,ckycUniqueId: String ) throws {
        if (url != nil && !credential.isEmpty &&
            url != nil && controller != nil && !ckycUniqueId.isEmpty) {
            let storyboard = UIStoryboard(name: "SelfieValidation", bundle: Bundle.module)
            let vc = storyboard.instantiateViewController(withIdentifier: "selfie") as! SelfieValidationVC
            vc.credential = credential
            vc.ckycUniqueId = ckycUniqueId
            vc.url = url
            vc.mainVC = controller!
            vc.timeout = timeout
            vc.selectedVersion = selectedVersion
            controller?.present(vc, animated: true)
        }
        else {
            throw PineLabsSDKException(message: ResponseMessage.SDK_NOT_INITIALIZED.rawValue)
        }
        print("\(SDKConstants.TAG) Initialized Selife Vaildation")
    }
    
    public static func getKycManager(from instance :PineLabsSDK,delegate : PliossdkResponseDelegate,url: String) -> KYCManager? {
        if url == "" {
            return nil
        }
        KYCManager.mKycManager.url = url
        KYCManager.mKycManager.delegate = delegate
     
        setUpKYCManager(from:instance)
     
        return KYCManager.mKycManager
    }
    
    private static func setUpKYCManager(from instance:PineLabsSDK){
        if let versionV1Instance = instance as? PineLabsSDKV1 {
            setCredentials(versionV1Instance.username)
            setSelectedVersion(versionV1Instance.version)
                }else if let versionV2Instance = instance as? PineLabsSDKV2{
                    setCredentials(versionV2Instance.authToken)
                    setSelectedVersion(versionV2Instance.version)
                 }else {
                     print("\(SDKConstants.TAG) the instance is of unkown class")
                }
            setAPITimeout(instance.timeout)
    }
    
    private static func setCredentials(_ newValue:String){
        KYCManager.mKycManager.credential = newValue
    }
    
    private static func setSelectedVersion(_ newValue:String){
        KYCManager.mKycManager.selectedVersion = newValue
    }
    
    private static func setAPITimeout(_ newValue:Int){
        KYCManager.mKycManager.timeout = newValue
    }
}

