//
//  PineLabsSDKV1.swift
//  pl-ios-sdk
//
//  Created by Isak sayyed on 17/08/23.
//

import UIKit
import Foundation


@available(iOS 10.0, *)
public class PineLabsSDKV1 :PineLabsSDK{
    private var _username :String = ""
    public var username:String  {
        get {
            return _username
        }
        set(newValue){
            _username = newValue
        }
    }
    private var _version:String = Version.Version_1.rawValue
    var version :String {
        print("\(SDKConstants.TAG) Initialized version: \(_version)")
        return _version
    }
    
}

