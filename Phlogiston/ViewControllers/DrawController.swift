//
//  ViewController.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 29/04/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

struct DrawingTool {
    var fillColor: UIColor?
    var strokeColor: UIColor?
    var lineWidth: CGFloat = 1
    
    static let base = DrawingTool(fillColor: .black, strokeColor: .black, lineWidth: 1)
}

class DrawController: UIViewController {
    @IBOutlet private weak var canvas: UIView!

    private var toolController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToolController") as! ToolController
    
    private var drawingTool: DrawingTool = .base
    private var currentPath: UIBezierPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: canvas)
        
        currentPath = UIBezierPath()
        currentPath?.move(to: location)
        
        let shLayer = CAShapeLayer()
        shLayer.fillColor = drawingTool.fillColor?.cgColor
        shLayer.strokeColor = drawingTool.strokeColor?.cgColor
        shLayer.lineWidth = drawingTool.lineWidth
        canvas.layer.addSublayer(shLayer)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: canvas)
        
        guard let currentPath = self.currentPath,
            let shLayer = canvas.layer.sublayers?.last as? CAShapeLayer else { return }
        currentPath.addLine(to: location)
        shLayer.path = currentPath.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: canvas)
        
        guard let currentPath = self.currentPath,
            let shLayer = canvas.layer.sublayers?.last as? CAShapeLayer else { return }
        currentPath.addLine(to: location)
        shLayer.path = currentPath.cgPath
        
        self.currentPath = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPath = nil
        canvas.layer.sublayers?.last?.removeFromSuperlayer()
    }
    
    @IBAction private func clearPressed() {
        canvas.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    @IBAction private func editPressed() {
        toolController.drawingTool = drawingTool
        toolController.becomeFirstResponder()
    }
    
    @IBAction private func actionPressed() {
        let imageToShare = UIGraphicsImageRenderer(size: canvas.frame.size).image { canvas.layer.render(in: $0.cgContext) }
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    var originalRect: CGRect = .zero
    var originalScale: CGFloat = 1
    var lastScale: CGFloat = 1
    var currentScale: CGFloat = 1 {
        didSet { canvas.layer.setAffineTransform(.init(scaleX: currentScale, y: currentScale)) }
    }
    @IBAction private func pinchAppeared(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            originalRect = canvas.frame
        case .changed:
            lastScale = recognizer.scale
            let pinchCenter = recognizer.location(in: view)
            let targetSize = CGSize(width: originalRect.size.width * lastScale, height: originalRect.size.height * lastScale)
            let targetOrigin = CGPoint(x: pinchCenter.x - targetSize.width / 2, y: pinchCenter.y - targetSize.height / 2)
            currentScale = originalScale * lastScale
            canvas.frame = CGRect(origin: targetOrigin, size: targetSize)
        case .ended:
            originalRect = canvas.frame
            currentScale = originalScale * lastScale
            originalScale = currentScale
        case .cancelled, .failed:
            canvas.frame = originalRect
            currentScale = originalScale
        case .possible:
            ()
        @unknown default:
            ()
        }
        
    }
}

extension DrawController: ToolControllerDelegate {
    func toolController(_ toolController: ToolController, didChangedDrawingTool drawingTool: DrawingTool) {
        self.drawingTool = drawingTool
    }
}
