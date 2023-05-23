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
    
    public static func getCardManager(url: String,delegate : PliossdkResponseDelegate) -> CardManager {
        CardManager.mCardManager.url = url
        CardManager.mCardManager.delegate = delegate
        return CardManager.mCardManager
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
    
    public func openCardViewLink(controller: UIViewController?) {
        let storyboard = UIStoryboard(name: "CardManagement", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(withIdentifier: "CardWebViewVC") as! CardWebViewVC
        vc.url = url
        vc.mainVC = controller!
        controller?.present(vc, animated: true)
    }
    
    public func setCredentials(clientKey: String, referenceNumber: String, username: String) {
        cardManagementService?.setCredentials(session: pinePerksSession, clientKey: clientKey, referenceNumber: referenceNumber, username: username)
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
        cardManagementService?.validateViewCardOTP(otp: otp)
    }
    
    public func changePin(pin: String) {
        cardManagementService?.changePin(pin: pin)
    }
    
    public func validateChangePinOTP(otp: String) {
        cardManagementService?.validateViewCardOTP(otp: otp,event: Event.changePinOtp)
    }
    
    public func resendOTP() {
        cardManagementService?.resendOTP()
    }
    
    public func clearSession() {
        pinePerksSession.clearCardId()
    }
}

