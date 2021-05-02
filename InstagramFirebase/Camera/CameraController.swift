//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 03/05/2021.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "selectedHome"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let capturePhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "selectedHome"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleCapturePhoto(){
        print("hsadgjaskgdkas")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
    }
    
    fileprivate func setupHUD(){
        view.addSubview(capturePhotoButton)
        
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        }
        catch let err {
            print("Could not set camera input: ", err)
        }
        
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)

        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}
