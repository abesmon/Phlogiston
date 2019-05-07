//
//  ZoomController.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 07/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

class ZoomController: NSObject {
    @IBOutlet private weak var view: UIView!
    
    var originalRect: CGRect = .zero
    var originalScale: CGFloat = 1
    var lastScale: CGFloat = 1
    var currentScale: CGFloat = 1 {
        didSet { view.layer.setAffineTransform(.init(scaleX: currentScale, y: currentScale)) }
    }
    
    @IBAction private func pinchAppeared(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            originalRect = view.frame
        case .changed:
            lastScale = recognizer.scale
            let pinchCenter = recognizer.location(in: view)
            let targetSize = CGSize(width: originalRect.size.width * lastScale, height: originalRect.size.height * lastScale)
            let targetOrigin = CGPoint(x: pinchCenter.x - targetSize.width / 2, y: pinchCenter.y - targetSize.height / 2)
            currentScale = originalScale * lastScale
            view.frame = CGRect(origin: targetOrigin, size: targetSize)
        case .ended:
            originalRect = view.frame
            currentScale = originalScale * lastScale
            originalScale = currentScale
        case .cancelled, .failed:
            view.frame = originalRect
            currentScale = originalScale
        case .possible:
            ()
        @unknown default:
            ()
        }
    }
}
