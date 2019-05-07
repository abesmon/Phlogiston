//
//  DrawProcessor.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 07/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

protocol DrawProcessor {
    var currentLayer: CALayer? { get }
    var drawingTool: DrawingTool { get set }
    
    func touchBegan(locationInCanvas: CGPoint, canvasLayer: CALayer)
    func touchMoved(locationInCanvas: CGPoint)
    func touchEnded(locationInCanvas: CGPoint)
    func touchCancelled(locationInCanvas: CGPoint?)
}