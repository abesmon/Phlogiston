//
//  CoreProcessor.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 07/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

class CoreProcessor: DrawProcessor {
    private var currentPath: UIBezierPath?
    var currentLayer: CALayer?
    
    func touchBegan(locationInCanvas: CGPoint, canvasLayer: CALayer, brush: Brush) {
        currentPath = UIBezierPath()
        currentPath?.move(to: locationInCanvas)
        
        let shLayer = CAShapeLayer()
        shLayer.strokeColor = brush.color.cgColor
        shLayer.fillColor = brush.withFill ? shLayer.strokeColor : nil
        shLayer.lineWidth = brush.lineWidth
        currentLayer = shLayer
        
        canvasLayer.addSublayer(shLayer)
    }
    
    func touchMoved(locationInCanvas: CGPoint) {
        proceed(locationInCanvas: locationInCanvas)
    }
    
    func touchEnded(locationInCanvas: CGPoint) {
        proceed(locationInCanvas: locationInCanvas)
        finalize()
    }
    
    func touchCancelled(locationInCanvas: CGPoint?) {
        self.currentLayer?.removeFromSuperlayer()
        finalize()
    }
    
    private func proceed(locationInCanvas: CGPoint) {
        guard let currentPath = self.currentPath,
            let shLayer = currentLayer as? CAShapeLayer else { return }
        currentPath.addLine(to: locationInCanvas)
        shLayer.path = currentPath.cgPath
    }
    
    private func finalize() {
        self.currentPath = nil
        self.currentLayer = nil
    }
    
    var processorViewController: UIViewController? { return nil }
}
