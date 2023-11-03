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
    
    var url: String
    var delegate: PliossdkResponseDelegate?
    private var _timeout :Int = 15
    public var timeout:Int  {
        get {
            return _timeout
        }
        set(newValue){
            _timeout = newValue
        }
    }
    
    public init(url: String,delegate : PliossdkResponseDelegate) {
        self.url = url
        self.delegate = delegate
    }
    
    public func getKycManager() -> KYCManager? {
        return KYCManager.getKycManager(from :self, delegate: delegate!,url: self.url)
    }
    
    @available(iOS 11.0, *)
    public func getCardManager() -> CardManager? {
        return CardManager.getCardManager(from :self, delegate: delegate!,url: self.url)
    }
}
