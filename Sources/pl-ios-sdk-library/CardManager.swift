//
//  CardManager.swift
//  Pliossdk
//
//  Created by Macbook on 24/03/23.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
public class CardManager {

    public var credential:String = ""
    public var selectedVersion:String = Version.Version_2.rawValue
    public var timeout:Int = 15
    public var delegate: PliossdkResponseDelegate?
    public var url: String? = nil
    public static let mCardManager = CardManager()
    public var cardNumberLbl: CardNumberLabel?
    public var cvv: CardCvvLabel?
    public var cardExpiryText: CardExpiryDateLabel?
    public var newView: UIViewController?
    private let pinePerksSession = PinePerksSession.sessionPK
    private var cardManagementService : CardManagementService?
    public init() {
    }
    
    public static func getCardManager(from instance :PineLabsSDK,delegate : PliossdkResponseDelegate,url: String) -> CardManager {
        CardManager.mCardManager.url = url
        CardManager.mCardManager.delegate = delegate
        
        setUpCardManager(from:instance)
        return CardManager.mCardManager
    }
    
    private static func setUpCardManager(from instance:PineLabsSDK){
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
        CardManager.mCardManager.credential = newValue
    }
    
    private static func setSelectedVersion(_ newValue:String){
        CardManager.mCardManager.selectedVersion = newValue
    }
    
    private static func setAPITimeout(_ newValue:Int){
        CardManager.mCardManager.timeout = newValue
    }
    
    private func setUrl(url: String) {
        self.url = url
    }
    
    public func getRandomKey() -> String? {
        cardManagementService = CardManagementService(baseUrl: url!)
        return cardManagementService?.getRandomKey()
    }
    
    private func setRandomKey(randomKey: String) {
    }
    
    public func openCardViewLink(controller: UIViewController?) throws {
        if url == nil || url == "" {
            throw PineLabsSDKException(message: ResponseMessage.SDK_NOT_INITIALIZED.rawValue)
        }
        let storyboard = UIStoryboard(name: "CardManagement", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(withIdentifier: "CardWebViewVC") as! CardWebViewVC
        vc.url = url
        vc.mainVC = controller!
        controller?.present(vc, animated: true)
    }
    
    public func setCredentials(clientKey: String, referenceNumber: String) {
        cardManagementService?.setSelectedVersion(selectedVersion: selectedVersion)
        cardManagementService?.setAPITimeout(self.timeout)
        
        cardManagementService?.setCredentials(session: pinePerksSession, clientKey: clientKey, referenceNumber: referenceNumber, credential: credential)
        print("\(SDKConstants.TAG) Credentials set successfully")

    }
    
    public func showCardDetails(view: UIViewController) {
        newView = view
        cardManagementService?.showCardDetails()
    }
    
    public func maskCardDetails(view: UIViewController) {
        newView = view
        cardManagementService?.maskCardDetails()
    }
    
    public func validateViewCardOTP(otp: String) {
        do {
            try cardManagementService?.validateViewCardOTP(otp: otp)
        } catch {
            
        }
    }
    
    public func changePin(pin: String) {
        do {
            try cardManagementService?.changePin(pin: pin)
        } catch {
            
        }
    }
    
    public func validateChangePinOTP(otp: String) {
        do {
            try cardManagementService?.validateViewCardOTP(otp: otp,event: Event.changePinOtp)
        } catch {
            
        }
    }
    
    public func resendOTP() {
        cardManagementService?.resendOTP()
    }
    
    public func clearSession() {
        pinePerksSession.clearCardId()
    }
}

