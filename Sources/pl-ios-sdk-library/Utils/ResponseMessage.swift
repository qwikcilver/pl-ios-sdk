//
//  ResponseMessage.swift
//  Pliossdk
//
//  Created by Macbook on 23/03/23.
//

import Foundation

public enum ResponseMessage: String {
    
    case CAMERA_ERROR = "Could not start the camera"
    case PERMISSION_ERROR = "Permission not satisfied"
    case SELFIE_VALIDATION_ERROR = "Error occurred when initiating selfie validation"
    case ENCRYPTION_ERROR = "Error occurred while encryption"
    case SELFIE_READ_ERROR = "Could not read the captured selfie of the user from the device"
    case UNKNOWN_HOST_EXCEPTION = "Either the host is incorrect or there is network connectivity issues"
    case SOCKET_TIMEOUT_EXCEPTION = "It is taking longer time than usual! Please retry after sometime"
    case IO_EXCEPTION = "Could not establish a connection with the server. Please retry after sometime"
    case EMPTY_BODY = "Empty response received from the API"
    case VALIDATION_ERROR = "Validation error"
    case SDK_EXCEPTION = "An exception occurred in SDK"
    case SDK_NOT_INITIALIZED = "SDK not initialized with URL"
    case SDK_CREDS_NOT_SET = "SDK credentials not set"
    case INVALID_PIN = "Provide a valid 4 digit PIN"
    case INVALID_OTP = "Provide a valid 6 digit OTP"
    case CHECKSUM_MISSING = "Checksum not set. Initiate view card or set pin first."
    case SUCCESS = "Successful"
    
}
