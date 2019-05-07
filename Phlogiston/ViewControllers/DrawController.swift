//
//  ViewController.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 29/04/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

class DrawController: UIViewController {
    @IBOutlet private weak var canvas: UIView!
    @IBOutlet private var zoomController: ZoomController!
    
    private var toolController = ToolController()
    private var currentProcessor: DrawProcessor = CoreProcessor()
    
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
        currentProcessor.touchBegan(locationInCanvas: touch.location(in: canvas), canvasLayer: canvas.layer)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentProcessor.touchMoved(locationInCanvas: touch.location(in: canvas))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        currentProcessor.touchEnded(locationInCanvas: touch.location(in: canvas))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentProcessor.touchCancelled(locationInCanvas: nil)
    }
    
    @IBAction private func clearPressed() {
        canvas.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    @IBAction private func editPressed() {
        toolController.drawingTool = currentProcessor.drawingTool
        toolController.becomeFirstResponder()
    }
    
    @IBAction private func actionPressed() {
        let imageToShare = UIGraphicsImageRenderer(size: canvas.frame.size).image { canvas.layer.render(in: $0.cgContext) }
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

extension DrawController: ToolControllerDelegate {
    func toolController(_ toolController: ToolController, didChangedDrawingTool drawingTool: DrawingTool) {
        currentProcessor.drawingTool = drawingTool
    }
}
