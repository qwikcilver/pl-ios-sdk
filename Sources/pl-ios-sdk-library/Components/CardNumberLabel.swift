//
//  CardNumberLabel.swift
//  Pliossdk
//
//  Created by Macbook on 03/04/23.
//

import Foundation
import UIKit
import NetworkExtension

@IBDesignable
open class CardNumberLabel : UILabel {
    @IBInspectable open var DEFAULT_CARD_NUMBER : String = "XXXX XXXX XXXX XXXX" {
        didSet {
            text = DEFAULT_CARD_NUMBER
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        text = DEFAULT_CARD_NUMBER
        NotificationCenter.default.addObserver(self, selector: #selector(handleCardDetailUpdated(_:)), name: NSNotification.Name("CardDetailUpdated"), object: nil)
    }
    
    @objc func handleCardDetailUpdated(_ notification: Notification) {
        guard let cardDetailResponse = notification.object as? CardDetailResponse else {
            return
        }
        updatelbl(Event.showCard, cardDetailResponse: cardDetailResponse)
    }
    
    public func updatelbl(_ eventType: Event, cardDetailResponse: CardDetailResponse) {
        print("\(SDKConstants.TAG) [CardNumberTextView] Subscriber notified for event: \(eventType)")
        var card = DEFAULT_CARD_NUMBER
        if eventType == Event.showCard || eventType == Event.showCardOtp {
            card = getFormattedCardNumber(cardDetailResponse.cardNumber ?? DEFAULT_CARD_NUMBER)
        }
        DispatchQueue.main.async {
            self.text = card
        }
    }
    
    private func getFormattedCardNumber(_ cardNumber: String) -> String {
        if cardNumber.count == 16 {
            return "\(cardNumber.prefix(4)) \(cardNumber.prefix(8).suffix(4)) \(cardNumber.prefix(12).suffix(4)) \(cardNumber.suffix(4))"
        } else if cardNumber.count == 14 {
            return "\(cardNumber.prefix(4)) \(cardNumber.prefix(10).suffix(6)) \(cardNumber.suffix(4))"
        } else {
            return cardNumber
        }
    }
}

@IBDesignable
open class DefaultLabelContainerView: UIView {
    
    var label: CardNumberLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        label = CardNumberLabel(frame: bounds)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
