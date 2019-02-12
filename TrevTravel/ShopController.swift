//
//  ShopController.swift
//  TrevTravel
//
//  Created by Song Liu on 2019-02-10.
//  Copyright © 2019 TrevTravel. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CoreML
import SafariServices

class ShopController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    var avSession = AVCaptureSession()
    let mlModel = Fruit()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSession()
    }
    

    func setUpSession() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = discoverySession.devices.first else {
            print(NSLocalizedString("nocamera", comment: ""))
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            avSession.addInput(input)
            avSession.sessionPreset = AVCaptureSession.Preset.high
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.alwaysDiscardsLateVideoFrames = true
            let videoQueue = DispatchQueue(label: "meta", attributes: .concurrent)
            videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
            avSession.addOutput(videoOutput)
            
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
        } catch {
            print(error)
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: avSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer.frame = cameraView.frame
        cameraView.layer.addSublayer(previewLayer)
        
        avSession.startRunning()
        
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            detectCoreML(pixelBuffer: pixelBuffer)
            
        }
    }
    
    
    func detectCoreML(pixelBuffer:CVImageBuffer) {
        func completion(request: VNRequest, error: Error?) {
            guard let observe = request.results as? [VNClassificationObservation] else { return }
            for classification in observe {
                if classification.confidence > 0.6 {
                    print(classification.identifier, classification.confidence)
                }
            }
            
            if let topResult = observe.first {
                DispatchQueue.main.sync {
                    if topResult.confidence > 0.9 {
                        // When confidence > 0.85, alert for the result fruit
                        
                        let title = topResult.identifier
                        let msg = "\n" + NSLocalizedString("moreinfo", comment: "")
                        
                        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: NSLocalizedString("close", comment: ""), style: .cancel, handler: nil)
                        let okAction = UIAlertAction(title: NSLocalizedString("more", comment: ""), style: .default, handler: { action in
                            // OPEN link in Safari
                            if let webURL = URL(string: "https://en.wikipedia.org/wiki/" + topResult.identifier) {
                                let config = SFSafariViewController.Configuration()
                                let svc = SFSafariViewController(url: webURL , configuration: config)
                                self.present(svc, animated: true)
                            }
                        })
                        
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        
//                        alertController.addAction(UIAlertAction(title: "Info on wiki", style: .default, handler:  { action in
//                            // OPEN link in Safari
//                            if let webURL = URL(string: "https://en.wikipedia.org/wiki/" + topResult.identifier) {
//                                    let config = SFSafariViewController.Configuration()
//                                    let svc = SFSafariViewController(url: webURL , configuration: config)
//                                    self.present(svc, animated: true)
//                            }
//
//                        }))
//                        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
//                        present(alertController, animated: true, completion: nil)
                        
                        
//                        self.nameLabel.text = topResult.identifier
//                        self.nameLabel.text = topResult.identifier + String(format: ", %.0f", topResult.confidence * 100) + "%"
                    } else {
                        self.nameLabel.text = NSLocalizedString("focus", comment: "")
                    }
                }
            }
            
        }
        do {
            let model = try VNCoreMLModel(for: mlModel.model)
            let request = VNCoreMLRequest(model: model, completionHandler: completion)
            request.imageCropAndScaleOption = .centerCrop
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    

    

}





