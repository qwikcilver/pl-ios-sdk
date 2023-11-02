//
//  PineLabsSDKV2.swift
//  pl-ios-sdk
//
//  Created by Isak sayyed on 18/08/23.
//

import UIKit
import Foundation


@available(iOS 10.0, *)
public class PineLabsSDKV2 :PineLabsSDK{
    private var _authToken :String = ""
    var authToken:String  {
        get {
            return "Bearer "+_authToken
        }
        set(newValue){
            _authToken = newValue
        }
    }
    private var _version:String = Version.Version_2.rawValue
    var version :String {
        print("\(SDKConstants.TAG) Initialized version: \(_version)")
        return _version
    }
    
}

