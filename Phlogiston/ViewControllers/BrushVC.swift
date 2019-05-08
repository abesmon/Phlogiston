//
//  BrushVC.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 30/04/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit
import ChromaColorPicker

protocol BrushControllerDelegate: AnyObject {
    func brushController(_ toolController: BrushVC, didChangedBrush brush: Brush)
}

class BrushVC: UIViewController {
    @IBOutlet private weak var alphaSlider: UISlider!
    @IBOutlet private weak var withFillSwitch: UISwitch!
    @IBOutlet private weak var chromaPicker: ChromaColorPicker!
    
    weak var delegate: (BrushControllerDelegate & UIResponder)?
    
    private var color: UIColor = .black
    private var alpha: CGFloat = 1
    private var withFill: Bool = true
    
    var brush: Brush {
        get {
            let color = self.color.withAlphaComponent(alpha)
            return Brush(color: color, withFill: withFill, lineWidth: 1)
        }
        set {
            // Variables
            alpha = newValue.color.cgColor.alpha
            withFill = newValue.withFill
            color = newValue.color
            
            // Controls
            if isViewLoaded {
                alphaSlider.value = Float(alpha)
                withFillSwitch.isOn = withFill
                chromaPicker.adjustToColor(color)
            }
        }
    }
    
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
        delegate?.brushController(self, didChangedBrush: brush)
    }
    
    @IBAction private func withFillSwitchChanged() {
        withFill = withFillSwitch.isOn
        delegate?.brushController(self, didChangedBrush: brush)
    }
    
    @IBAction private func chromaChanged() {
        color = chromaPicker.currentColor
        delegate?.brushController(self, didChangedBrush: brush)
    }
}

extension BrushVC: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        self.color = color
        delegate?.brushController(self, didChangedBrush: brush)
    }
}
