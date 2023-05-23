//
//  CardIssueDateLabel.swift
//  Pliossdk
//
//  Created by Macbook on 03/04/23.
//

import Foundation
import UIKit
import NetworkExtension

public class CardIssueDateLabel : UILabel {
    private let DEFAULT_CARD_ISSUE = "MM/YY"
    private static var VIEW_ID = UIView().hashValue
    private let IDENTIFIER = "plCardIssuDateView" + String(CardIssueDateLabel.VIEW_ID)
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
        text = DEFAULT_CARD_ISSUE
    }
    
    public func update(_ eventType: Event, cardDetailResponse: CardDetailResponse) {
        print("\(SDKConstants.TAG) [CardNumberTextView] Subscriber notified for event: \(eventType)")
        var issue = DEFAULT_CARD_ISSUE
        if eventType == Event.showCard || eventType == Event.showCardOtp {
            issue = getFormattedIssueDate(cardDetailResponse.cardValidFromDate ?? "02/28")
        }
        DispatchQueue.main.async {
            self.text = issue
        }
    }
    
    private func getFormattedIssueDate(_ cardValidFromDate: String) -> String {
        return cardValidFromDate
    }
}

