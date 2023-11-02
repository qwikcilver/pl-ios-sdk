//
//  PineLabsSDKV1.swift
//  pl-ios-sdk
//
//  Created by Isak sayyed on 17/08/23.
//

import Foundation

class PineLabsSDKV1 :PineLabsSDK{
    private var _username :String = ""
    var username:String  {
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

