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
    
    private var chaosSteps: Int = 3
    private var chaosForce: CGFloat = 50
    private var curveChaosForce: CGFloat = 150
    
    func touchBegan(locationInCanvas: CGPoint, canvasLayer: CALayer, drawingTool: DrawingTool) {
        currentPath = UIBezierPath()
        currentPath?.move(to: locationInCanvas)
        
        let shLayer = CAShapeLayer()
        shLayer.fillColor = drawingTool.fillColor?.cgColor
        shLayer.strokeColor = drawingTool.strokeColor?.cgColor
        shLayer.lineWidth = drawingTool.lineWidth
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
        (0..<chaosSteps).forEach { chaosStepIndex in
            let x = (movementVector.width / CGFloat(chaosSteps)) * CGFloat(chaosStepIndex)
            let y = (movementVector.height / CGFloat(chaosSteps)) * CGFloat(chaosStepIndex)
            
            let chaotedLocation = currentPoint.added(CGPoint(x: x, y: y)).added(.random(withForce: chaosForce))
            let controlPoint = currentPoint.midInBetween(to: chaotedLocation).added(.random(withForce: curveChaosForce))
            currentPath.addQuadCurve(to: chaotedLocation, controlPoint: controlPoint)
        }
        shLayer.path = currentPath.cgPath
    }
    
    private func finalize() {
        self.currentPath = nil
        self.currentLayer = nil
    }
}
