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

struct DrawItem {
    var path: UIBezierPath
    var tool: DrawingTool
}

class CanvasView: UIView {
    var items: [DrawItem] = [] {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        items.forEach { item in
            item.path.lineWidth = item.tool.lineWidth
            if let fillColor = item.tool.fillColor {
                fillColor.setFill()
                item.path.fill(with: .normal, alpha: fillColor.cgColor.alpha)
            }
            if let strokeColor = item.tool.strokeColor {
                strokeColor.setStroke()
                item.path.stroke(with: .normal, alpha: strokeColor.cgColor.alpha)
            }
        }
    }
}

class DrawController: UIViewController {
    @IBOutlet private weak var canvas: CanvasView!

    private var toolController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToolController") as! ToolController
    
    private var drawingTool: DrawingTool = .base
    private var items: [DrawItem] = []
    private var currentItem: DrawItem?
    
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
        let path = UIBezierPath()
        path.move(to: location)
        currentItem = DrawItem(path: path, tool: drawingTool)
        updateItems()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: canvas)
        currentItem?.path.addLine(to: location)
        updateItems()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: canvas)
        currentItem?.path.addLine(to: location)
        if let itemToSave = currentItem {
            items.append(itemToSave)
        }
        currentItem = nil
        updateItems()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentItem = nil
        updateItems()
    }
    
    private func updateItems() {
        canvas.items = (items + [currentItem]).compactMap { $0 }
    }
    
    @IBAction private func clearPressed() {
        items = []
        updateItems()
    }
    
    @IBAction private func editPressed() {
        toolController.becomeFirstResponder()
    }
    
    @IBAction private func actionPressed() {
        let imageToShare = UIGraphicsImageRenderer(size: canvas.frame.size).image { canvas.layer.render(in: $0.cgContext) }
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction private func pinchAppeared(_ recognizer: UIPinchGestureRecognizer) {
        let originalScale = recognizer.scale
        let scale = 1 - (1 - originalScale) / 30
        let pinchCenter = recognizer.location(in: view)
        let targetSize = CGSize(width: canvas.frame.width * scale, height: canvas.frame.height * scale)
        let targetOrigin = CGPoint(x: pinchCenter.x - targetSize.width / 2, y: pinchCenter.y - targetSize.height / 2)
        canvas.frame = CGRect(origin: targetOrigin, size: targetSize)
        canvas.items.forEach { $0.path.apply(.init(scaleX: scale, y: scale)) }
        updateItems()
    }
}

extension DrawController: ToolControllerDelegate {
    func toolController(_ toolController: ToolController, didChangedDrawingTool drawingTool: DrawingTool) {
        self.drawingTool = drawingTool
    }
}
