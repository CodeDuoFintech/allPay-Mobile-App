//
//  FirstViewController.swift
//  yaPay
//
//  Created by Angelos Constantinides on 10/06/2017.
//  Copyright © 2017 Angelos Constantinides. All rights reserved.
//

import UIKit
import AVFoundation

class PaymentViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    @IBOutlet var m_ScannerView: UIView!
    @IBOutlet weak var m_OptionsView: UIView!

    
    @IBOutlet weak var m_MerchantLabel: UILabel!
    @IBOutlet weak var m_AmountLabel: UILabel!
    
    
    private var m_CaptureSession:AVCaptureSession?
    private var m_VideoPreviewLayer:AVCaptureVideoPreviewLayer?
    private var qrCodeFrameView:UIView?
    private var m_Message: String?
    private var m_MerchantID : String?
    private var m_Amount : Double?
    private var m_PaymentReferenceID : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            self.m_CaptureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            self.m_CaptureSession?.addInput(input)
            
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            self.m_CaptureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            self.m_VideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.m_CaptureSession)
            self.m_VideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.m_VideoPreviewLayer?.frame = self.m_ScannerView.layer.bounds
            self.m_ScannerView.layer.addSublayer(self.m_VideoPreviewLayer!)
            
            // Start video capture.
            self.m_CaptureSession?.startRunning()
            
            self.qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                self.m_ScannerView.addSubview(qrCodeFrameView)
                self.m_ScannerView.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0
        {
            qrCodeFrameView?.frame = CGRect.zero
            self.m_Message = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode
        {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = self.m_VideoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                self.m_Message = metadataObj.stringValue
                let valuesArray : [String] = self.m_Message!.components(separatedBy: ";")
                
                self.m_MerchantLabel.text = valuesArray[0]
                self.m_AmountLabel.text = valuesArray[1]

                
                
                self.m_CaptureSession?.stopRunning()
            }
        }
    }
    
    func getMessage() -> String
    {
        return self.m_Message!
    }
    
}
