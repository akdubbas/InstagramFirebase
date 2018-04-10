//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 4/10/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraController : UIViewController
{
    let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dismissButton)
        setUpCaptureSession()
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 17, paddingLeft: 0, paddingBottom: 0, paddingRight: -12, width: 50, height: 50)
    }
    
    func setUpCaptureSession()
    {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input)
            {
                captureSession.addInput(input)
            }
            
        }catch let err{
            print("Error while capturing Session", err)
        }
        //2. setup outputs
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output)
        {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        
    }
    
    @objc func dismissAction()
    {
        dismiss(animated: true, completion: nil)
    }
}
