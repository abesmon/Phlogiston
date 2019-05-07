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
    var drawingTool: DrawingTool = .base
    
    func touchBegan(locationInCanvas: CGPoint, canvasLayer: CALayer) {
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
        guard let currentPath = self.currentPath,
            let shLayer = currentLayer as? CAShapeLayer else { return }
        currentPath.addLine(to: locationInCanvas)
        shLayer.path = currentPath.cgPath
    }
    
    func touchEnded(locationInCanvas: CGPoint) {
        guard let currentPath = self.currentPath,
            let shLayer = currentLayer as? CAShapeLayer else { return }
        currentPath.addLine(to: locationInCanvas)
        shLayer.path = currentPath.cgPath
        
        self.currentPath = nil
        self.currentLayer = nil
    }
    
    func touchCancelled(locationInCanvas: CGPoint?) {
        self.currentLayer?.removeFromSuperlayer()
        
        self.currentPath = nil
        self.currentLayer = nil
    }
}
