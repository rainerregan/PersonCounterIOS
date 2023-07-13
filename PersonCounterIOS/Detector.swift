//
//  Detector.swift
//  PersonCounterIOS
//
//  Created by Rainer Regan on 13/07/23.
//

import Foundation
import UIKit
import AVFoundation
import Vision

extension ViewController {
    func setupDetector() {
        let modelURL = Bundle.main.url(forResource: "YOLOv3", withExtension: "mlmodelc")
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            
            self.requests = [recognitions]
            
        } catch let error {
            print(error)
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            if let results = request.results {
                self.extractDetections(results)
            }
        })
    }
    
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil
        
        var personCounter: Int = 0
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {continue}
            
            if objectObservation.labels.first?.identifier == "person" {
                personCounter += 1
                
                // Transformations
                let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
                
                let transformBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
                
                let boxLayer = self.drawBoundingBox(bounds: transformBounds, label: objectObservation.labels.first?.identifier ?? "nil")
                
                detectionLayer.addSublayer(boxLayer)
            }
            
        }
        
        self.delegate?.didNumberUpdated(total: personCounter)
    }
    
    func setupLayers() {
        detectionLayer = CALayer()
        detectionLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        detectionLayer.zPosition = 1
        self.view.layer.addSublayer(detectionLayer)
    }
    
    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }
    
    func drawBoundingBox(bounds: CGRect, label: String) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = CGColor.init(red: 7.0, green: 8.0, blue: 7.0, alpha: 1.0)
        // Create a text layer
        let textLayer = CATextLayer()
        textLayer.string = label // Set the text content
        textLayer.foregroundColor = UIColor.black.cgColor // Set the text color
        textLayer.font = UIFont.systemFont(ofSize: 14.0) // Set the font
        textLayer.alignmentMode = .center // Set the alignment
        textLayer.frame = CGRect(x: 0, y: 0, width: boxLayer.frame.width, height: 60) // Adjust the frame as per your requirements

        boxLayer.addSublayer(textLayer)
        return boxLayer
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch let error {
            print(error)
        }
    }
}
