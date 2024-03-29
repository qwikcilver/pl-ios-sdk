//
//  CardManagementService.swift
//  Pliossdk
//
//  Created by Macbook on 03/04/23.
//

import Foundation
import UIKit
//import Cuckoo

@available(iOS 11.0, *)
class CardManagementService {
    
    private var baseUrl: String?
    var randomKey: String?
    public var pinePerksSecret: PinePerksSecret?
    private var pinePerksSession: PinePerksSession?
    private var textField = UITextField()
    private var screenShotEnable = true
    private var selectedVersion:String = Version.Version_2.rawValue
    private var timeout:Int = 15

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getRandomKey() -> String? {
        randomKey = EncryptDecryptUtils.generateEncryptionKey()
        return randomKey
    }
    
    func setCredentials(session: PinePerksSession, clientKey: String, referenceNumber: String, credential: String) {
        pinePerksSecret = PinePerksSecret(clientKey: clientKey, referenceNumber: referenceNumber, credential: credential)
       
        self.pinePerksSession = session
        URLSessionDataTaskHandler.setSelectedVersion(selectedVersion: selectedVersion)
        URLSessionDataTaskHandler.setAPITimeout(timeout: timeout)
        print("\(SDKConstants.TAG) SDK initialized successfully.")
    }
    
    func setSelectedVersion(selectedVersion:String){
        self.selectedVersion = selectedVersion
    }
    
    func setAPITimeout(_ newValue:Int){
        self.timeout = newValue
    }
    
    func getDecryptedCardDetails(body: CardDetailResponse) -> CardDetailResponse {
        body.cardNumber = EncryptDecryptUtils.decryptData(workingKey: randomKey!, data: body.cardNumber!)
        body.cardValidFromDate = EncryptDecryptUtils.decryptData(workingKey: randomKey!, data: body.cardValidFromDate!)
        body.cardValidToDate = EncryptDecryptUtils.decryptData(workingKey: randomKey!, data: body.cardValidToDate!)
        body.cvv2 = EncryptDecryptUtils.decryptData(workingKey: randomKey!, data: body.cvv2!)
        return body
    }
    
    func showCardDetails() {
        do {
            try validatePinePerksCredentials()
            screenShotEnable = false
            var storedSessionId: String?
            if let cardId = pinePerksSession?.getCardId(), !cardId.isEmpty {
                print("\(SDKConstants.TAG) Valid sessionId found.")
                storedSessionId = cardId
            }
            let cardDetailRequest = CardDetailRequest(clientKey: (pinePerksSecret?.getClientKey())!, referenceNumber: (pinePerksSecret?.getReferenceNumber())!, sessionId: storedSessionId)
            
            callViewCardAPI(cardDetailRequest: cardDetailRequest, event: Event.showCard)
        }
        catch let error {
            // Handle the error here
            print("\(SDKConstants.TAG) An error occurred: \(error.localizedDescription)")
            return
        }
    }
    
    func maskCardDetails() {
        screenShotEnable = true
        let cardDetailResponse = CardDetailResponse()
        let plCardResponse = PLCardResponse.init(responseCode: ResponseCodes.SUCCESS.rawValue,responseMessage: ResponseMessage.SUCCESS.rawValue,event: Event.hideCard.rawValue)
        
        updateCardInfo(event: Event.hideCard, decrptedDetail: cardDetailResponse, plCardResponse: plCardResponse)
    }
    
    func updateCardInfo(event: Event,decrptedDetail: CardDetailResponse,plCardResponse: PLCardResponse) {
        NotificationCenter.default.post(name: NSNotification.Name("CardDetailUpdated"), object: decrptedDetail)
        NotificationCenter.default.post(name: NSNotification.Name("CardExipiryUpdated"), object: decrptedDetail)
        NotificationCenter.default.post(name: NSNotification.Name("CardCvvUpdated"), object: decrptedDetail)
        NotificationCenter.default.post(name: NSNotification.Name("CardIssueUpdated"), object: decrptedDetail)
    }
    
    func validateViewCardOTP(otp: String, event: Event = Event.showCardOtp) throws {
        do {
            try validatePinePerksCredentials()
            if pinePerksSecret?.checksum == nil {
                throw PineLabsSDKException(message: ResponseMessage.CHECKSUM_MISSING.rawValue)
            }
            if otp.count != 6 {
                throw PineLabsSDKException(message: ResponseMessage.INVALID_OTP.rawValue)
            }
        } catch let error {
            // Handle the error here
            print("\(SDKConstants.TAG) An error occurred: \(error.localizedDescription)")
            throw PineLabsSDKException(message: ResponseMessage.INVALID_OTP.rawValue)
        }
        
        if event == Event.showCardOtp {
            let validateOTPRequest = ValidateOTPRequest(checksum: (pinePerksSecret?.checksum!)!, otp: otp)
            callValidateViewCardOTPAPI(validateOTPRequest: validateOTPRequest, event: event)
        } else {
            let validateOTPRequest = ValidateOTPRequest(checksum: (pinePerksSecret?.checksum!)!, otp: otp)
            callValidateChangePinOTPAPI(validateOTPRequest: validateOTPRequest, event: event)
        }
    }
    
    func changePin(pin: String) throws {
        do {
            try validatePinePerksCredentials()
            if pin.count != 4  {
                throw PineLabsSDKException(message: ResponseMessage.INVALID_PIN.rawValue)
            }
        } catch {
            print("\(SDKConstants.TAG) An error occurred: \(error.localizedDescription)")
            throw PineLabsSDKException(message: ResponseMessage.INVALID_PIN.rawValue)
        }
        
        guard let encryptedPin = EncryptDecryptUtils.encryptData(pin, symmetricKey: randomKey!) else {
            print("\(SDKConstants.TAG) PIN encryption failed")
            return
        }
        print("\(SDKConstants.TAG) PIN encrypted")
        let changePinRequest = ChangePinRequest(cardPIN: encryptedPin, referenceNumber: pinePerksSecret!.referenceNumber, clientKey: pinePerksSecret!.clientKey)
        callChangePinAPI(changePinRequest: changePinRequest, event: Event.changePin)
    }
    
    func resendOTP() {
        do {
            try validatePinePerksCredentials()
            if pinePerksSecret?.checksum == nil {
                throw PineLabsSDKException(message: ResponseMessage.CHECKSUM_MISSING.rawValue)
            }
        } catch let error {
            print("\(SDKConstants.TAG) An error occurred: \(error.localizedDescription)")
            return
        }
        
        let resendOtpRequest = ResendOtpRequest(checksum: pinePerksSecret!.checksum!)
        callResendOTPAPI(resendOtpRequest: resendOtpRequest, event: Event.resendOtp)
    }
    
    func validatePinePerksCredentials() throws {
        if baseUrl == nil || baseUrl == "" {
            throw PineLabsSDKException(message: ResponseMessage.SDK_NOT_INITIALIZED.rawValue)
        } else if pinePerksSecret == nil || pinePerksSecret?.credential == nil || pinePerksSecret?.referenceNumber.isEmpty == nil || pinePerksSecret?.clientKey == nil {
            throw PineLabsSDKException(message: ResponseMessage.SDK_CREDS_NOT_SET.rawValue)
        }
    }
    /**
     Calls the API to fetch card details using the given `cardDetailRequest` and `event`.
     If there is no internet connection, prints an error message and returns.
     Otherwise, constructs the URL based on the `baseUrl` and `event`, and makes a URL request using the `URLSessionDataTaskHandler` class.
     
     - Parameters:
     - cardDetailRequest: A `Codable` object representing the card detail request to be sent.
     - event: An `Event` object representing the type of event for which the card detail request is being made.
     */
    private func callViewCardAPI<T: Encodable>(cardDetailRequest: T, event:Event) {
        
        // Check for internet connectivity before making the API call
        guard Internet.isConnected() else {
            print("\(SDKConstants.TAG) check your network connection")
            return
        }
        
        // Construct the URL for the API call and log relevant details
        
        //let url = URL(string: baseUrl! + BaseURLs.getCardDetail)!
        
        // Make the API call using URLSessionDataTaskHandler
        URLSessionDataTaskHandler.fetchCardDetail(baseUrl: baseUrl!, parameters: cardDetailRequest, crednetial: pinePerksSecret!.credential) { [weak self] data, response, error in
            // Unwrap self and handle errors if present
            guard let self = self else { return }
            guard error == nil, let data = data else {
                self.onFailureResponse(error ?? NSError(), event)
                return
            }
            if let httpStatus = response as? HTTPURLResponse{
                let statusCode = httpStatus.statusCode
                print("\(SDKConstants.TAG) Card Response: HttpStatus -- \(statusCode)")
            }
            do {
                let cardDetailResponse = try JSONDecoder().decode(CardDetailResponse.self, from: data)
                var plCardResponse = PLCardResponse(responseCode: cardDetailResponse.responseCode!, responseMessage: cardDetailResponse.responseMessage!, event: event.rawValue)
                print(SDKConstants.TAG, "callViewCardAPI: code:" + "\(cardDetailResponse.responseCode!)" + " msg:" + cardDetailResponse.responseMessage!)
                
                switch cardDetailResponse.responseCode {
                    // If the response code is SUCCESS, update card info and session details if necessary
                case ResponseCodes.SUCCESS.rawValue:
                    print("\(SDKConstants.TAG) success")
                    let decryptedCardDetail = self.getDecryptedCardDetails(body: cardDetailResponse)
                    self.updateCardInfo(event: event, decrptedDetail: decryptedCardDetail, plCardResponse: plCardResponse)
                    // If the response code is VALIDATE_OTP or SET_PIN_VALIDATE_OTP, update session details as necessary
                case ResponseCodes.VALIDATE_OTP.rawValue:
                    //Here we are clearing the cardID and setting the checksum while enterting the OTP and when session is expired
                    self.pinePerksSession?.clearCardId()
                    self.pinePerksSecret?.checksum = cardDetailResponse.checksum
                default:
                    plCardResponse = self.onUnsuccessfulPinePerksResponse(response: plCardResponse)
                }
                // Notify the delegate that a card response has been received
                CardManager.mCardManager.delegate?.didReceivePliossdkCardResponse(plCardResponse)
            } catch {
                // Handle any JSON parsing errors
                self.onFailureResponse(error, event)
                print("\(SDKConstants.TAG)" ,error.localizedDescription)
            }
        }
    }
    
    func callValidateViewCardOTPAPI<T: Encodable>(validateOTPRequest: T, event:Event) {
        // Check for internet connectivity before making the API call
        guard Internet.isConnected() else {
            print("\(SDKConstants.TAG) check your network connection")
            return
        }
        
        // Construct the URL for the API call and log relevant details
        //let url = URL(string: baseUrl! + BaseURLs.validateViewCardOTP)!
        
        // Make the API call using URLSessionDataTaskHandler
        URLSessionDataTaskHandler.validateViewCardOTP(baseUrl: baseUrl!, parameters: validateOTPRequest, credential: pinePerksSecret!.credential) { [weak self] data, response, error in
            // Unwrap self and handle errors if present
            guard let self = self else { return }
            guard error == nil, let data = data else {
                self.onFailureResponse(error ?? NSError(), event)
                return
            }
            
            do {
                let cardDetailResponse = try JSONDecoder().decode(CardDetailResponse.self, from: data)
                var plCardResponse = PLCardResponse(responseCode: cardDetailResponse.responseCode!, responseMessage: cardDetailResponse.responseMessage!, event: event.rawValue)
                print(SDKConstants.TAG, "callValidateViewCardOTPAPI: code:" + "\(cardDetailResponse.responseCode!)" + " msg:" + cardDetailResponse.responseMessage!)
                
                switch cardDetailResponse.responseCode {
                    // If the response code is SUCCESS, update card info and session details if necessary
                case ResponseCodes.SUCCESS.rawValue:
                    print("\(SDKConstants.TAG) success")
                    let decryptedCardDetail = self.getDecryptedCardDetails(body: cardDetailResponse)
                    if let session = decryptedCardDetail.sessionId {
                        if self.pinePerksSession?.setCardId(session) != nil {
                            // do something if necessary
                        }
                    }
                    self.updateCardInfo(event: event, decrptedDetail: decryptedCardDetail, plCardResponse: plCardResponse)
                default:
                    plCardResponse = self.onUnsuccessfulPinePerksResponse(response: plCardResponse)
                }
                // Notify the delegate that a card response has been received
                CardManager.mCardManager.delegate?.didReceivePliossdkCardResponse(plCardResponse)
            } catch {
                // Handle any JSON parsing errors
                self.onFailureResponse(error, event)
                print("\(SDKConstants.TAG)" ,error.localizedDescription)
            }
        }
    }
    
    func callChangePinAPI<T: Encodable>(changePinRequest: T, event:Event) {
        // Check for internet connectivity before making the API call
        guard Internet.isConnected() else {
            print("\(SDKConstants.TAG) check your network connection")
            return
        }
        
        // Construct the URL for the API call and log relevant details
       // let url = URL(string: baseUrl! + BaseURLs.changePin)!
        
        // Make the API call using URLSessionDataTaskHandler
        URLSessionDataTaskHandler.changePin(baseUrl: baseUrl!, parameters: changePinRequest, credential:pinePerksSecret!.credential) { [weak self] data, response, error in
            // Unwrap self and handle errors if present
            guard let self = self else { return }
            guard error == nil, let data = data else {
                self.onFailureResponse(error ?? NSError(), event)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse{
                let statusCode = httpStatus.statusCode
                print("\(SDKConstants.TAG) Card Response: HttpStatus -- \(statusCode)")
            }
            
            do {
                let pinePerksResponse = try JSONDecoder().decode(PinePerksResponse.self, from: data)
                var plCardResponse = PLCardResponse(responseCode: pinePerksResponse.responseCode!, responseMessage: pinePerksResponse.responseMessage!, event: event.rawValue)
                print(SDKConstants.TAG, "callChangePinAPI: code:" + "\(pinePerksResponse.responseCode!)" + " msg:" + pinePerksResponse.responseMessage!)
                
                switch pinePerksResponse.responseCode {
                    // If the response code is SUCCESS, update card info and session details if necessary
                case ResponseCodes.SET_PIN_VALIDATE_OTP.rawValue:
                    //Here we are Setting the checksum
                    self.pinePerksSecret?.checksum = pinePerksResponse.checksum
                default:
                    plCardResponse = self.onUnsuccessfulPinePerksResponse(response: plCardResponse)
                }
                
                // Notify the delegate that a card response has been received
                CardManager.mCardManager.delegate?.didReceivePliossdkCardResponse(plCardResponse)
            } catch {
                // Handle any JSON parsing errors
                self.onFailureResponse(error, event)
                print("\(SDKConstants.TAG)" ,error.localizedDescription)
            }
        }
    }
    
    func callValidateChangePinOTPAPI<T: Encodable>(validateOTPRequest: T, event:Event) {
        // Check for internet connectivity before making the API call
        guard Internet.isConnected() else {
            print("\(SDKConstants.TAG) check your network connection")
            return
        }
        
        // Construct the URL for the API call and log relevant details
       // let url = URL(string: baseUrl! + BaseURLs.validateChangePinOTP)!
      
        // Make the API call using URLSessionDataTaskHandler
        URLSessionDataTaskHandler.validateChangePinOTP(baseUrl: baseUrl!, parameters: validateOTPRequest, credential: pinePerksSecret!.credential) { [weak self] data, response, error in
            // Unwrap self and handle errors if present
            guard let self = self else { return }
            guard error == nil, let data = data else {
                self.onFailureResponse(error ?? NSError(), event)
                return
            }
            do {
                let pinePerksResponse = try JSONDecoder().decode(PinePerksResponse.self, from: data)
                var plCardResponse = PLCardResponse(responseCode: pinePerksResponse.responseCode!, responseMessage: pinePerksResponse.responseMessage!, event: event.rawValue)
                print(SDKConstants.TAG, "callValidateChangePinOTPAPI: code:" + "\(pinePerksResponse.responseCode!)" + " msg:" + pinePerksResponse.responseMessage!)
                
                switch pinePerksResponse.responseCode {
                    // If the response code is SUCCESS, update card info and session details if necessary
                case ResponseCodes.SUCCESS.rawValue:
                    
                    print("")
                default:
                    plCardResponse = self.onUnsuccessfulPinePerksResponse(response: plCardResponse)
                }
                // Notify the delegate that a card response has been received
                CardManager.mCardManager.delegate?.didReceivePliossdkCardResponse(plCardResponse)
            } catch {
                // Handle any JSON parsing errors
                self.onFailureResponse(error, event)
                print("\(SDKConstants.TAG)" ,error.localizedDescription)
            }
        }
    }
    
    func callResendOTPAPI<T: Encodable>(resendOtpRequest: T, event:Event) {
        // Check for internet connectivity before making the API call
        guard Internet.isConnected() else {
            print("\(SDKConstants.TAG) check your network connection")
            return
        }
        // Construct the URL for the API call and log relevant details
        //let url = URL(string: baseUrl! + BaseURLs.resendOTPApi)!
        
        // Make the API call using URLSessionDataTaskHandler
        URLSessionDataTaskHandler.resendOTP(baseUrl: baseUrl!, parameters: resendOtpRequest, crdential: pinePerksSecret!.credential) { [weak self] data, response, error in
            // Unwrap self and handle errors if present
            guard let self = self else { return }
            guard error == nil, let data = data else {
                self.onFailureResponse(error ?? NSError(), event)
                return
            }
            do {
                let pinePerksResponse = try JSONDecoder().decode(PinePerksResponse.self, from: data)
                var plCardResponse = PLCardResponse(responseCode: pinePerksResponse.responseCode!, responseMessage: pinePerksResponse.responseMessage!, event: event.rawValue)
                print(SDKConstants.TAG, "callResendOTPAPI: code:" + "\(pinePerksResponse.responseCode!)" + " msg:" + pinePerksResponse.responseMessage!)
                
                switch pinePerksResponse.responseCode {
                    // If the response code is SUCCESS, update card info and session details if necessary
                case ResponseCodes.SUCCESS.rawValue:
                    //do something with success
                    print("")
                default:
                    plCardResponse = self.onUnsuccessfulPinePerksResponse(response: plCardResponse)
                }
                // Notify the delegate that a card response has been received
                CardManager.mCardManager.delegate?.didReceivePliossdkCardResponse(plCardResponse)
            } catch {
                // Handle any JSON parsing errors
                self.onFailureResponse(error, event)
                print("\(SDKConstants.TAG)" ,error.localizedDescription)
            }
        }
    }
    
    func onUnsuccessfulPinePerksResponse(response: PLCardResponse) -> PLCardResponse {
        print("\(SDKConstants.TAG) onUnsuccessfulResponse: HttpStatus -- \(response.responseCode)")
        if response.responseMessage.isEmpty {
            response.responseCode = ResponseCodes.EMPTY_BODY.rawValue
            response.responseMessage = ResponseMessage.EMPTY_BODY.rawValue
        }
        return response
    }
    
    private func onFailureResponse(_ t: Error, _ event: Event) {
        print("\(SDKConstants.TAG) API execution failed.")
        print("\(SDKConstants.TAG) Cause: \(t.localizedDescription)")
        print("\(SDKConstants.TAG) StackTrace: \(t)")
        let plCardResponse = PLCardResponse()
        if let unknownHostException = t as? URLError, unknownHostException.code == URLError.Code.cannotFindHost {
            plCardResponse.responseCode = ResponseCodes.UNKNOWN_HOST_EXCEPTION.rawValue
            plCardResponse.responseMessage = ResponseMessage.UNKNOWN_HOST_EXCEPTION.rawValue
        } else if let socketTimeoutException = t as? URLError, socketTimeoutException.code == URLError.Code.timedOut {
            plCardResponse.responseCode = ResponseCodes.SOCKET_TIMEOUT_EXCEPTION.rawValue
            plCardResponse.responseMessage = ResponseMessage.SOCKET_TIMEOUT_EXCEPTION.rawValue
        } else if let IO_EXCEPTION = t as? URLError, IO_EXCEPTION.code == URLError.Code.dnsLookupFailed{
            plCardResponse.responseCode = ResponseCodes.IO_EXCEPTION.rawValue
            plCardResponse.responseMessage = ResponseMessage.IO_EXCEPTION.rawValue
        } else if let pineLabsSDKException = t as? PineLabsSDKException {
            plCardResponse.responseCode = ResponseCodes.SDK_EXCEPTION.rawValue
            plCardResponse.responseMessage = pineLabsSDKException.message
        } else {
            plCardResponse.responseCode = ResponseCodes.EMPTY_BODY.rawValue
            plCardResponse.responseMessage = ResponseMessage.EMPTY_BODY.rawValue
        }
        plCardResponse.event = event.rawValue
        CardManager.mCardManager.delegate?.didReceivePliossdkCardResponse(plCardResponse)
    }
}

