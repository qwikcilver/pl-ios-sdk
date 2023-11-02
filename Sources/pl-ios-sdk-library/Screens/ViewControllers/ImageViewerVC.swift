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
    var credential:String = ""
    var selectedVersion:String = Version.Version_2.rawValue
    var timeout:Int = 15
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
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
       
        guard let selfieImageData = EncryptedSelfieValidationImage.getEncryptedSelfieImage(base64Image: base64Data, ckycUniqueId: ckycUniqueId) else {
            let PLKYCResponse = PLKYCResponse(responseCode: ResponseCodes.ENCRYPTION_ERROR.rawValue, responseMessage: ResponseMessage.ENCRYPTION_ERROR.rawValue)
            print("\(SDKConstants.TAG) Error while encryption", PLKYCResponse)
            self.dismissAllController(data: PLKYCResponse)
            return
        }
        let validationEvent = Event.selfieValidation.description
        let pinePerksKycService = PinePerksKYCService(baseUrl: url!, credential: credential, selectedVersion:selectedVersion)
        
        pinePerksKycService.setAPITimeout(timeout)
        pinePerksKycService.selfieValidation(ckycUniqueId: ckycUniqueId, selfieImageData: selfieImageData) {response, code in
            print("\(SDKConstants.TAG) Image validation completed")
            
            DispatchQueue.main.async {
                if(response != nil){
                    self.dismissAllController(data: response!)
                }
                else {
                    let plKycResponse = PLKYCResponse(responseCode: ResponseCodes.SDK_EXCEPTION.rawValue, responseMessage: ResponseMessage.SDK_EXCEPTION.rawValue, event:validationEvent)
                    self.dismissAllController(data: plKycResponse)
                    print("\(SDKConstants.TAG) Empty body received from API call")
                }
                
            }
        }
    }
}
