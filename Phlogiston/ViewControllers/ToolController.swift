//
//  ToolController.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 30/04/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit
import ChromaColorPicker

protocol ToolControllerDelegate: AnyObject {
    func toolController(_ toolController: ToolController, didChangedDrawingTool drawingTool: DrawingTool)
}

class ToolController: UIViewController {
    @IBOutlet private weak var alphaSlider: UISlider!
    @IBOutlet private weak var withFillSwitch: UISwitch!
    @IBOutlet private weak var chromaPicker: ChromaColorPicker!
    
    weak var delegate: (ToolControllerDelegate & UIResponder)?
    
    private var color: UIColor!
    private var alpha: CGFloat!
    private var withFill: Bool!
    
    var drawingTool: DrawingTool {
        get {
            let color = self.color.withAlphaComponent(alpha)
            return DrawingTool(fillColor: withFill ? color : nil, strokeColor: color, lineWidth: 1)
        }
        set {
            // Variables
            alpha = newValue.strokeColor?.cgColor.alpha
            withFill = newValue.fillColor != nil
            color = newValue.strokeColor
            
            // Controls
            if isViewLoaded {
                alphaSlider.value = Float(alpha)
                withFillSwitch.isOn = withFill
                chromaPicker.adjustToColor(color)
            }
        }
    }

    override var canBecomeFirstResponder: Bool { return true }
    override var inputView: UIView? { return view }
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 44)))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))], animated: false)
        return toolbar
    }
    
    override var next: UIResponder? { return delegate }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chromaPicker.supportsShadesOfGray = true
        chromaPicker.delegate = self
        
        alphaSlider.value = Float(alpha)
        withFillSwitch.isOn = withFill
        chromaPicker.adjustToColor(color)
    }
    
    @IBAction private func alphaSliderChanged() {
        alpha = CGFloat(alphaSlider.value)
        delegate?.toolController(self, didChangedDrawingTool: drawingTool)
    }
    
    @IBAction private func withFillSwitchChanged() {
        withFill = withFillSwitch.isOn
        delegate?.toolController(self, didChangedDrawingTool: drawingTool)
    }
    
    @IBAction private func chromaChanged() {
        color = chromaPicker.currentColor
        delegate?.toolController(self, didChangedDrawingTool: drawingTool)
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}

extension ToolController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        self.color = color
        delegate?.toolController(self, didChangedDrawingTool: drawingTool)
    }
}
