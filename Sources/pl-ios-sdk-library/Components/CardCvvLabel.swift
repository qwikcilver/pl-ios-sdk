//
//  CardCvvLabel.swift
//  Pliossdk
//
//  Created by Macbook on 03/04/23.
//

import Foundation
import UIKit
import NetworkExtension

public class CardCvvLabel : UILabel {
    private let DEFAULT_CARD_CVV = "XXX"
    private static var VIEW_ID = UIView().hashValue
    private let IDENTIFIER = "plCardCvvView" + String(CardCvvLabel.VIEW_ID)
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
        self.text = DEFAULT_CARD_CVV
        NotificationCenter.default.addObserver(self, selector: #selector(handleCardDetailUpdated(_:)), name: NSNotification.Name("CardCvvUpdated"), object: nil)
    }
    
    @objc func handleCardDetailUpdated(_ notification: Notification) {
        guard let cardDetailResponse = notification.object as? CardDetailResponse else {
            return
        }
        updatelbl(Event.showCard, cardDetailResponse: cardDetailResponse)
    }
    
    public func updatelbl(_ eventType: Event, cardDetailResponse: CardDetailResponse) {
        print("\(SDKConstants.TAG) [CardNumberTextView] Subscriber notified for event: \(eventType)")
        
        var finalCvv = DEFAULT_CARD_CVV
        if eventType == Event.showCard || eventType == Event.showCardOtp {
            finalCvv = cardDetailResponse.cvv2 ?? DEFAULT_CARD_CVV
        }
        DispatchQueue.main.async {
            self.text = finalCvv
        }
    }
}

