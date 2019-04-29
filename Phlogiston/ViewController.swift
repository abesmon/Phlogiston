//
//  ViewController.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 29/04/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var drawingView: DrawingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func clearPressed() {
        drawingView.clear()
    }
}

class DrawingView: UIView {
    var paths: [UIBezierPath] = []
    
    var currentPath: UIBezierPath?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        currentPath = UIBezierPath()
        currentPath?.move(to: location)
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        currentPath?.addLine(to: location)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentPath = self.currentPath else { return }
        self.currentPath = nil
        paths.append(currentPath)
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentPath = nil
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        (paths + [currentPath]).compactMap { $0 }.forEach { path in
            UIColor.blue.setStroke()
            path.stroke()
            UIColor.red.setFill()
            path.fill()
        }
    }
    
    func clear() {
        paths = []
        currentPath = nil
        setNeedsDisplay()
    }
}

