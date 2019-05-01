//
//  MainViewController.swift
//  MNIST-iOS
//
//  Created by Hanif Sugiyanto on 01/05/19.
//  Copyright © 2019 Personal Organization. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var lblPredict: UILabel!
    @IBOutlet weak var drawView: DrawView!
    /// Model
    let model = mnistCNN()
    /// Core Image Context
    let context = CIContext()
    var pixelBuffer: CVPixelBuffer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPredict.isHidden = true
        
        // Set the pixel buffer dimensions - Remember it's grayscale
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault,
                            28,
                            28,
                            kCVPixelFormatType_OneComponent8,
                            attrs,
                            &pixelBuffer)
    }

    @IBAction func tappedReset(_ sender: Any) {
        drawView.lines = []
        drawView.setNeedsDisplay()
        lblPredict.isHidden = true
    }
    
    @IBAction func tappedPredict(_ sender: Any) {
        // Fancy Image conversions
        let viewContext = drawView.getViewContext()
        let cgImage = viewContext?.makeImage()
        let ciImage = CIImage(cgImage: cgImage!)
        context.render(ciImage, to: pixelBuffer!)
        // Predict
        let output = try? model.prediction(image: pixelBuffer!)
        
        // Output
        lblPredict.text = output?.classLabel
        lblPredict.isHidden = false
    }
}
