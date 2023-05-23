//
//  CardNumberTextView.swift
//  Pliossdk
//
//  Created by Macbook on 04/04/23.
//

import Foundation
import UIKit
import NetworkExtension

public class CardNumberTextView: UILabel {
    private let DEFAULT_CARD_NUMBER = "XXXX XXXX XXXX XXXX"
    private static var VIEW_ID = UIView().hashValue
    private let IDENTIFIER = "plCardNumberView" + String(CardNumberTextView.VIEW_ID)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        self.text = DEFAULT_CARD_NUMBER
        self.backgroundColor = .blue
        self.textColor = .red
    }
    
    func update(_ eventType: Event, cardDetailResponse: CardDetailResponse) {
        print("\(SDKConstants.TAG) [CardNumberTextView] Subscriber notified for event: \(eventType)")
        guard let viewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController,
              let textView = viewController.view.subviews.filter({$0.accessibilityIdentifier == IDENTIFIER}).first as? UILabel else {
                  return
              }
        var card = DEFAULT_CARD_NUMBER
        if eventType == Event.showCard {
            card = getFormattedCardNumber(cardDetailResponse.cardNumber ?? "1234567890123456")
        }
        DispatchQueue.main.async {
            textView.text = card
        }
    }
    
    private func getFormattedCardNumber(_ cardNumber: String) -> String {
        if cardNumber.count == 16 {
            let index1 = cardNumber.index(cardNumber.startIndex, offsetBy: 4)
            let index2 = cardNumber.index(index1, offsetBy: 5)
            let index3 = cardNumber.index(index2, offsetBy: 5)
            return "\(cardNumber[..<index1]) \(cardNumber[index1..<index2]) \(cardNumber[index2..<index3]) \(cardNumber[index3...])"
        } else if cardNumber.count == 14 {
            let index1 = cardNumber.index(cardNumber.startIndex, offsetBy: 4)
            let index2 = cardNumber.index(index1, offsetBy: 6)
            return "\(cardNumber[..<index1]) \(cardNumber[index1..<index2]) \(cardNumber[index2...])"
        } else {
            return cardNumber
        }
    }
}
