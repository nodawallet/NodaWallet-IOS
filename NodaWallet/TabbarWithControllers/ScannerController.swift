//
//  ScannerController.swift
//  NodaWallet
//
//  n 06/03/20.
//  .
//

import UIKit
import GTMBarcodeScanner
import AVFoundation
import WalletConnect

class ScannerController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    
    var scanner: BarcodeScanner!
    var isScannerStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationView.theme_backgroundColor = [Constants.NavigationColor.lightMode, Constants.NavigationColor.darkMode]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.checkCameraAccess()
    }
    
    private func showScanner() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
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
        case .restricted:
            
        break

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
        if isScannerStarted {
            self.view = nil
            scanner.stop()
        }
    }
    
    @IBAction func gallery_Tapped(_ sender: Any) {
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


extension ScannerController: GTMBarcodeCoreDelegate {

    func lightnessChange(needFlashButton: Bool) {
       
    }
    
    func barcodeRecognized(result: BarcodeResult) {
        print("----------> result = \(result.barcode)")
        if let walletConnectVc = self.storyboard?.instantiateViewController(withIdentifier: "WalletConnectControllerID") as? WalletConnectController {
            walletConnectVc.qrCodeString = result.barcode
            self.navigationController?.pushViewController(walletConnectVc, animated: true)
           // self.present(walletConnectVc, animated: true, completion: nil)
        }
    }
    
    func barcodeForPhoto(result: BarcodeResult?) {
        if let re = result {
            print("----------> result = \(re.barcode)")
        } else {
        }
    }
}

extension ScannerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                        print("nothing")
                    } else {
                        print("message: \(qrCodeLink)")
                        if let walletConnectVc = self.storyboard?.instantiateViewController(withIdentifier: "WalletConnectControllerID") as? WalletConnectController {
                            walletConnectVc.qrCodeString = qrCodeLink
                            self.navigationController?.pushViewController(walletConnectVc, animated: true)
                        }
                    }
            }
        }
        
    }
    
}
