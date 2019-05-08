//
//  ChaoticProcessor.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 07/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

class ChaoticProcessor: DrawProcessor {
    private var currentPath: UIBezierPath?
    var currentLayer: CALayer?
    
    private var chaoticProcessorVC = ChaoticProcessorVC()
    var processorViewController: UIViewController? { return chaoticProcessorVC }
    
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
        let currentPoint = currentPath.currentPoint
        let movementVector = CGSize(width: locationInCanvas.x - currentPoint.x, height: locationInCanvas.y - currentPoint.y)
        (0..<chaoticProcessorVC.chaosSteps).forEach { chaosStepIndex in
            let x = (movementVector.width / CGFloat(chaoticProcessorVC.chaosSteps)) * CGFloat(chaosStepIndex)
            let y = (movementVector.height / CGFloat(chaoticProcessorVC.chaosSteps)) * CGFloat(chaosStepIndex)
            
            let chaotedLocation = currentPoint.added(CGPoint(x: x, y: y)).added(.random(withForce: chaoticProcessorVC.chaosForce))
            let controlPoint = currentPoint.midInBetween(to: chaotedLocation).added(.random(withForce: chaoticProcessorVC.curveChaosForce))
            currentPath.addQuadCurve(to: chaotedLocation, controlPoint: controlPoint)
        }
        shLayer.path = currentPath.cgPath
    }
    
    private func finalize() {
        self.currentPath = nil
        self.currentLayer = nil
    }
}
