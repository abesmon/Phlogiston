//
//  ToolController.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 30/04/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

protocol ToolControllerDelegate: AnyObject {
    func toolController(_ toolController: ToolController, didChangedDrawingTool drawingTool: DrawingTool)
}

class ToolController: UIViewController {
    @IBOutlet private weak var alphaSlider: UISlider!
    @IBOutlet private weak var withFillSwitch: UISwitch!
    @IBOutlet private weak var hueSlider: UISlider!
    
    weak var delegate: (ToolControllerDelegate & UIResponder)?
    
    var drawingTool: DrawingTool {
        let color = UIColor(hue: CGFloat(hueSlider.value), saturation: 1, brightness: 1, alpha: CGFloat(alphaSlider.value))
        return DrawingTool(fillColor: withFillSwitch.isOn ? color : nil, strokeColor: color, lineWidth: 1)
    }

    override var canBecomeFirstResponder: Bool { return true }
    override var inputView: UIView? { return view }
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 44)))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))], animated: false)
        return toolbar
    }
    
    override var next: UIResponder? { return delegate }
    
    @IBAction private func alphaSliderChanged() {
        delegate?.toolController(self, didChangedDrawingTool: drawingTool)
    }
    
    @IBAction private func withFillSwitchChanged() {
        delegate?.toolController(self, didChangedDrawingTool: drawingTool)
    }
    
    @IBAction private func hueSliderChanged() {
        delegate?.toolController(self, didChangedDrawingTool: drawingTool)
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}
