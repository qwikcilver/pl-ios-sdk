//
//  ImageViewerVC.swift
//  CamStarter
//
//  Created by Macbook on 15/03/23.

import UIKit
import AVFoundation

@available(iOS 10.0, *)
class ImageViewerVC: UIViewController  {
    
    @IBOutlet weak var selfieImageView: UIImageView!
    var capturedImage = UIImage()
    var pinePerksUsername = ""
    var ckycUniqueId = ""
    public var url : String? = nil
    var yourImage = UIImage()
    var mainVC = UIViewController()
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    var base64Data = ""
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextBtn.tintColor = UIColor.white
        self.cancel.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selfieImageView.image = capturedImage
    }
    
    // MARK: - Button actions
    @IBAction func CancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        SwiftLoader.show(animated: true)
        initiateSelfieValidation(capturedImage.jpegData(compressionQuality: 1)!)
    }
    
    // MARK: - Selfie validation
    /**
     Initiate selfie validation with the captured image data.
     - Parameters:
     - imageCapturedUri: The image data captured from the camera.
     */
    func initiateSelfieValidation(_ imageCapturedUri: Data) {
        
        let imageData = capturedImage.jpegData(compressionQuality: 1)
        base64Data = imageData?.base64EncodedString() ?? ""
        guard let imageByte = getImageByte(imageCapturedUri) else {
           
            let PLKYCResponse = PLKYCResponse(responseCode: ResponseCodes.SELFIE_VALIDATION_ERROR.rawValue, responseMessage: ResponseMessage.SELFIE_VALIDATION_ERROR.rawValue)
            print("\(SDKConstants.TAG)" , PLKYCResponse)
            self.dismissAllController(data: PLKYCResponse)
            return
        }
        guard let selfieImageData = EncryptedSelfieValidationImage.getEncryptedSelfieImage(base64Image: base64Data, ckycUniqueId: ckycUniqueId) else {
            let PLKYCResponse = PLKYCResponse(responseCode: ResponseCodes.ENCRYPTION_ERROR.rawValue, responseMessage: ResponseMessage.ENCRYPTION_ERROR.rawValue)
            print("\(SDKConstants.TAG)", PLKYCResponse)
            self.dismissAllController(data: PLKYCResponse)
            return
        }
        let validationEvent = Event.selfieValidation.description
        let pinePerksKycService = PinePerksKYCService(baseUrl: url!, pinePerksUsername: pinePerksUsername)
        pinePerksKycService.selfieValidation(ckycUniqueId: ckycUniqueId, selfieImageData: selfieImageData) {response, code in
            print("\(SDKConstants.TAG) end loader")
            print("\(SDKConstants.TAG) end loader111",ResponseCodes.self)
            print("\(SDKConstants.TAG) end loader2",ResponseMessage.self)
            DispatchQueue.main.async {
                if(response != nil){
                    self.dismissAllController(data: response!)
                }
                else {
                    let plKycResponse = PLKYCResponse(responseCode: ResponseCodes.SDK_EXCEPTION.rawValue, responseMessage: ResponseMessage.SDK_EXCEPTION.rawValue, event:validationEvent)
                    self.dismissAllController(data: plKycResponse)
                    print("\(SDKConstants.TAG) Empty Body")
                }
                
            }
        }
    }
    
    // MARK: - Image processing
    
    func getImageByte(_ uri: Data) -> Data? {
        let bufferSize = 1024
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        guard let inputStream = try? InputStream(data: uri) else {
            let PLKYCResponse = PLKYCResponse(responseCode: ResponseCodes.SELFIE_READ_ERROR.rawValue, responseMessage: ResponseMessage.SELFIE_READ_ERROR.rawValue)
            print("\(SDKConstants.TAG)" ,PLKYCResponse)
            print("\(SDKConstants.TAG) end loader get imagebyte")
            DispatchQueue.main.async {
                self.dismissAllController(data: PLKYCResponse)
            }
            return nil
        }
        let byteBuffer = NSMutableData()
        var len = 0
        while inputStream.hasBytesAvailable {
            len = inputStream.read(&buffer, maxLength: bufferSize)
            if len > 0 {
                byteBuffer.append(buffer, length: len)
            }
        }
        return byteBuffer as Data
    }
}
