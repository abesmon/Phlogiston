//
//  ViewController.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 29/04/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

struct DrawItem {
    var path: UIBezierPath
    var fillColor: UIColor?
    var strokeColor: UIColor?
}

class DrawingView: UIView {
    var items: [DrawItem] = [] {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        items.forEach { item in
            item.fillColor?.setFill()
            item.strokeColor?.setStroke()
            item.path.fill()
            item.path.stroke()
        }
    }
}

class DrawController: UIViewController {
    @IBOutlet private weak var drawingView: DrawingView!
    private var toolsHelper: ToolsHelper!
    
    private var items: [DrawItem] = []
    private var currentItem: DrawItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolsHelper = ToolsHelper(owner: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: drawingView)
        let path = UIBezierPath()
        path.move(to: location)
        currentItem = DrawItem(path: path, fillColor: UIColor.black.withAlphaComponent(0.7), strokeColor: UIColor.black.withAlphaComponent(0.7))
        updateItems()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: drawingView)
        currentItem?.path.addLine(to: location)
        updateItems()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: drawingView)
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
        drawingView.items = (items + [currentItem]).compactMap { $0 }
    }
    
    @IBAction private func clearPressed() {
        items = []
        updateItems()
    }
    
    @IBAction private func editPressed() {
        toolsHelper.becomeFirstResponder()
    }
}

class ToolsHelper: UIResponder {
    private let view = UIView()
    private var owner: UIResponder?
    
    convenience init(owner: UIResponder?) {
        self.init()
        self.owner = owner
    }
    
    override init() {
        super.init()
        view.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: 400))
        view.backgroundColor = .red
        let label = UILabel()
        label.text = "test"
        view.addSubview(label)
    }
    
    override var inputView: UIView? {
        return view
    }
    
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 44)))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))], animated: false)
        return toolbar
    }
    
    override var canBecomeFirstResponder: Bool {
        return owner != nil
    }
    
    override var next: UIResponder? { return owner }
}
