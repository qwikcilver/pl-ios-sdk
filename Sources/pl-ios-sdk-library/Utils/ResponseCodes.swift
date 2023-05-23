//
//  ResponseCodes.swift
//  Pliossdk
//
//  Created by Macbook on 23/03/23.
//

import Foundation

public enum ResponseCodes: Int {
    case CAMERA_ERROR = 1002
    case PERMISSION_ERROR = 1003
    case SELFIE_VALIDATION_ERROR = 1004
    case ENCRYPTION_ERROR = 1006
    case SELFIE_READ_ERROR = 1005
    case UNKNOWN_HOST_EXCEPTION = 1000
    case SOCKET_TIMEOUT_EXCEPTION = 1001
    case IO_EXCEPTION = 1007
    case EMPTY_BODY = 1099
    case SDK_EXCEPTION = 1008
    case SUCCESS = 0
    case VIEW_CARD = 2001
    case VALIDATE_OTP = 2002
    case SET_PIN = 2003
    case SET_PIN_VALIDATE_OTP = 2004
    case INVALID_OTP = 2005
}
