//
//  CardExpiryDateLabel.swift
//  Pliossdk
//
//  Created by Macbook on 03/04/23.
//

import Foundation
import UIKit
import NetworkExtension

public class CardExpiryDateLabel : UILabel {
    private let DEFAULT_CARD_EXPIRY = "MM/YY"
    private static var VIEW_ID = UIView().hashValue
    private let IDENTIFIER = "plCardExpiryDateView" + String(CardExpiryDateLabel.VIEW_ID)
    override public var text: String? {
        get {
            return nil
        }
        set {
            super.text = newValue
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        text = DEFAULT_CARD_EXPIRY
        NotificationCenter.default.addObserver(self, selector: #selector(handleCardDetailUpdated(_:)), name: NSNotification.Name("CardExipiryUpdated"), object: nil)
    }
    
    @objc func handleCardDetailUpdated(_ notification: Notification) {
        guard let cardDetailResponse = notification.object as? CardDetailResponse else {
            return
        }
        updatelbl(Event.showCard, cardDetailResponse: cardDetailResponse)
    }
    
    public  func updatelbl(_ eventType: Event, cardDetailResponse: CardDetailResponse) {
        print("\(SDKConstants.TAG) [CardNumberTextView] Subscriber notified for event: \(eventType)")
        var expiry = DEFAULT_CARD_EXPIRY
        if eventType == Event.showCard || eventType == Event.showCardOtp {
            expiry = getFormattedExpiryDate(cardDetailResponse.cardValidToDate ?? DEFAULT_CARD_EXPIRY)
        }
        DispatchQueue.main.async {
            self.text = expiry
        }
    }
    
    private func getFormattedExpiryDate(_ cardValidToDate: String) -> String {
        let month = String(cardValidToDate.prefix(2))
        let year = String(cardValidToDate.suffix(2))
        return month + "/" + year
    }
}
