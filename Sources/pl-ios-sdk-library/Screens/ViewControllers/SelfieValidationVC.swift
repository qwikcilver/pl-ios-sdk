//
//  SelfieValidationVC.swift
//  CamStarter
//
//  Created by Macbook on 15/03/23.
//

import UIKit
import AVFoundation

@available(iOS 10.0, *)
class SelfieValidationVC: UIViewController ,AVCapturePhotoCaptureDelegate {
    
    
    
    // MARK: @IBOutlet
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var flipBtn: UIButton!
    @IBOutlet weak var click: UIButton!
    @IBOutlet weak var validateBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!
    @IBOutlet weak var back: UIButton!
    
    // MARK: Local Variables
    var captureDevice : AVCaptureDevice!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    public var url : String? = nil
    var isFromFrontCamera = true
    var credential:String = ""
    var selectedVersion:String = Version.Version_2.rawValue
    var timeout:Int = 15
    var ckycUniqueId = ""
    var mainVC = UIViewController()
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.click.tintColor = UIColor.white
        self.flipBtn.tintColor = UIColor.white
        self.back.tintColor = UIColor.white
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(SDKConstants.TAG) Selfie validation screen")
        isFromFrontCamera = true
        checkPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(captureSession != nil){
            self.captureSession.stopRunning()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            permissionDeniedResponse()
            print("\(SDKConstants.TAG) Denied, request permission from settings")
        case .restricted:
            permissionDeniedResponse()
            print("\(SDKConstants.TAG) Restricted, device owner must approve")
        case .authorized:
            print("\(SDKConstants.TAG) Authorized, proceed")
            DispatchQueue.main.async {
                self.flipCamera()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("\(SDKConstants.TAG) Permission granted, proceed")
                    DispatchQueue.main.async {
                        self.flipCamera()
                    }
                } else {
                    print("\(SDKConstants.TAG) Permission denied")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                        self.permissionDeniedResponse()
                    }
                }
            }
        @unknown default:
            print("\(SDKConstants.TAG) Unknwon")
        }
    }
    
    func permissionDeniedResponse() {
        let PLKYCResponse = PLKYCResponse(responseCode: ResponseCodes.PERMISSION_ERROR.rawValue, responseMessage: ResponseMessage.PERMISSION_ERROR.rawValue)
        print("\(SDKConstants.TAG)" ,PLKYCResponse.responseMessage)
        self.dismissAllController(data: PLKYCResponse)
    }
    
    func flipCamera(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        var lensFacing = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        if(isFromFrontCamera){
            isFromFrontCamera = false
            lensFacing = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        }else{
            isFromFrontCamera = true
            lensFacing = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: lensFacing!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            let PLKYCResponse = PLKYCResponse(responseCode: ResponseCodes.CAMERA_ERROR.rawValue, responseMessage: ResponseMessage.CAMERA_ERROR.rawValue)
            print("\(SDKConstants.TAG)",PLKYCResponse)
            DispatchQueue.main.async {
                self.dismissAllController(data: PLKYCResponse)
            }
        }
        if error == nil && captureSession!.canAddInput(input) {
            stillImageOutput = AVCapturePhotoOutput()
            captureSession.addInput(input)
            captureSession.addOutput(stillImageOutput)
            setupLivePreview()
        }
        else{
        }
    }
    
    func setupLivePreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        DispatchQueue.main.async {
            self.previewLayer.frame = self.previewView.bounds
            self.flipBtn.bringSubviewToFront(self.previewView)
            self.click.bringSubviewToFront(self.previewView)
        }
    }
    
    @IBAction func flipBtn(_ sender: Any) {
        print("\(SDKConstants.TAG) started session")
        self.flipCamera()
    }
    
    @available(iOS 11.0, *)
    @IBAction func clickBtn(_ sender: UIButton) {
        didTapCamera()
    }
    
    @available(iOS 11.0, *)
    func didTapCamera() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("\(SDKConstants.TAG) Image fetched")
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        let image = UIImage(data: imageData)!
        showImaViewer(image: image)
    }
    
    func showImaViewer(image: UIImage) {
        let storyboard = UIStoryboard(name: "SelfieValidation", bundle: Bundle.module)
        let vc = storyboard.instantiateViewController(withIdentifier: "viewer") as! ImageViewerVC
        vc.capturedImage = image
        vc.credential = self.credential
        vc.ckycUniqueId = self.ckycUniqueId
        vc.selectedVersion = self.selectedVersion
        vc.url = self.url
        vc.mainVC = mainVC
        vc.timeout = timeout
        self.present(vc, animated: true)
    }
}
