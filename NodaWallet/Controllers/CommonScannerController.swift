//
//  CommonScannerController.swift
//  NodaWallet
//
//  Created by macOsx on 01/04/20.
//  .
//

import UIKit
import GTMBarcodeScanner
import AVFoundation

protocol CommonScannerControllerDelegate {
    func scannedQR(qrCode: String)
}

class CommonScannerController: UIViewController {

    @IBOutlet weak var cancelBttn: UIButton!
    var scanner: BarcodeScanner!
    var isScannerStarted = false
    var delegate:CommonScannerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cancelBttn.setTitle("Cancel".localized(), for: .normal)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.checkCameraAccess()
    }
        
    private func showScanner() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            isScannerStarted = true
            let scanner = BarcodeScanner.create(view: self.view)
            scanner.delegate = self
            scanner.start()
            self.scanner = scanner
        } else {
            print("Dont have camera")
        }
    }
        
    private func checkCameraAccess() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)

        switch cameraAuthorizationStatus {
        case .denied:
            self.showAlert(message: "Go to settings and enable camera permission to continue")
            break
        case .authorized:
            showScanner()
        break
        case .restricted: break

        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    self.showScanner()
                } else {
                    self.showAlert(message: "Go to settings and enable camera permission to continue")
                }
            }
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view = nil
        if isScannerStarted {
            scanner.stop()
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gallery_Action(_ sender: Any) {
        showPhotoLibrary()
    }
    
    func showPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imag = UIImagePickerController()
            self.configPicker(imag: imag)
            imag.sourceType = UIImagePickerController.SourceType.photoLibrary;
            self.present(imag, animated: true, completion: nil)
        }
    }
    
    func configPicker(imag : UIImagePickerController) {
        imag.navigationBar.isTranslucent = false
        imag.navigationBar.barTintColor = UIColor.black // Background color
        imag.navigationBar.tintColor = UIColor.white// Cancel button ~ any UITabBarButton items
        imag.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        imag.delegate = self
        imag.allowsEditing = isEditing
    }
        
        
}

extension CommonScannerController: GTMBarcodeCoreDelegate {

    func lightnessChange(needFlashButton: Bool) {
       
    }
    
    func barcodeRecognized(result: BarcodeResult) {
        self.dismiss(animated: true) {
            self.delegate?.scannedQR(qrCode: result.barcode)
        }
    }
    
    func barcodeForPhoto(result: BarcodeResult?) {
        if let re = result {
            print("----------> result = \(re.barcode)")
        } else {
        }
    }
}

extension CommonScannerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage  {
                let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                    let ciImage:CIImage=CIImage(image:image)!
                    var qrCodeLink=""
                
                    let features=detector.features(in: ciImage)
                    for feature in features as! [CIQRCodeFeature] {
                        qrCodeLink += feature.messageString!
                    }
                          
                    if qrCodeLink=="" {
                    } else {
                        self.dismiss(animated: true) {
                            self.delegate?.scannedQR(qrCode: qrCodeLink)
                        }
                    }
            }
        }
        
    }
    
}
