//
//  PineLabsSDK.swift
//  CamStarter
//
//  Created by Macbook on 21/03/23.
//

import Foundation
import UIKit

public protocol PliossdkResponseDelegate: AnyObject {
    func didReceivePliossdkResponse(_ data: PLKYCResponse)
    func didReceivePliossdkCardResponse(_ data: PLCardResponse)
}

@available(iOS 10.0, *)
public class PineLabsSDK {
    
    private var url: String
    private var delegate: PliossdkResponseDelegate?
    
    public init(url: String,delegate : PliossdkResponseDelegate) {
        self.url = url
        self.delegate = delegate
    }
    
    public func getKycManager() -> KYCManager? {
        return KYCManager.getKycManager(url: self.url,delegate: delegate!)
    }
    
    @available(iOS 11.0, *)
    public func getCardManager() -> CardManager? {
        return CardManager.getCardManager(url: self.url, delegate: delegate!)
    }
}
