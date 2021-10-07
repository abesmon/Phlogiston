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
    
    private var toolboxController = ToolboxController()
    private var processor: DrawProcessor { return toolboxController.processorVC.processor }
    private var brush: Brush { return toolboxController.brushVC.brush }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolboxController.context = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        processor.touchBegan(locationInCanvas: touch.location(in: canvas), canvasLayer: canvas.layer, brush: brush)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if let touches = event?.coalescedTouches(for: touch) {
            touches.forEach { processor.touchMoved(locationInCanvas: $0.location(in: canvas)) }
        }
        processor.touchMoved(locationInCanvas: touch.location(in: canvas))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        processor.touchEnded(locationInCanvas: touch.location(in: canvas))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        processor.touchCancelled(locationInCanvas: nil)
    }
    
    @IBAction private func clearPressed() {
        canvas.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    @IBAction private func editPressed() {
        addChild(toolboxController)
        toolboxController.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    @IBAction private func actionPressed(_ sender: UIBarButtonItem?) {
        let imageToShare = UIGraphicsImageRenderer(size: canvas.frame.size).image { canvas.layer.render(in: $0.cgContext) }
        let activityVC = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender?.value(forKey: "view") as? UIView
        present(activityVC, animated: true, completion: nil)
    }
}
