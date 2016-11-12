//
//  AVFoundationViewController.swift
//  DeviceFrameworksDemo
//
//  Created by Harley Trung on 4/11/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit
import AVFoundation

class AVFoundationViewController: UIViewController {
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureImageView: UIImageView!

    @IBAction func takeButtonDidTap(_ sender: UIButton) {
        capturePhoto()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // NOTE: If you plan to upload your photo to Parse,
        // you will likely need to change your preset to AVCaptureSessionPresetHigh or AVCaptureSessionPresetMedium to keep the size under the 10mb Parse max.
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

        let input: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: backCamera)

        if session!.canAddInput(input) {
            session!.addInput(input)
            // The remainder of the session setup will go here...
        }

        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]

        if session!.canAddOutput(stillImageOutput) {
            session!.addOutput(stillImageOutput)
            // Configure the Live Preview here...
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        if let videoPreviewLayer = videoPreviewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
            videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            previewView.layer.addSublayer(videoPreviewLayer)
        }

        session!.startRunning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = previewView.bounds
    }

    func capturePhoto() {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            // Code for photo capture goes here...
            stillImageOutput?.captureStillImageAsynchronously(
                from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                    // Process the image data (sampleBuffer) here to get an image file
                    // we can put in our captureImageView
                    guard sampleBuffer != nil else {
                        print("captureStillImageAsynchronouslyFromConnection error", error.debugDescription)
                        return}

                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.captureImageView.image = image
            })
        }
    }
}
