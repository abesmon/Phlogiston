//
//  ChaoticProcessorVC.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 08/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

class ChaoticProcessorVC: UIViewController {
    @IBOutlet private weak var chaosStepsLabel: UILabel!
    @IBOutlet private weak var chaosStepsStepper: UIStepper!
    private(set) var chaosSteps: Int = 3
    
    @IBOutlet private weak var chaosForceLabel: UILabel!
    @IBOutlet private weak var chaosForceSlider: UISlider!
    private(set) var chaosForce: CGFloat = 50
    
    @IBOutlet private weak var curveChaosForceLabel: UILabel!
    @IBOutlet private weak var curveChaosForceSlider: UISlider!
    private(set) var curveChaosForce: CGFloat = 150

    private let formatter = NumberFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.numberStyle = .decimal
        
        chaosStepsLabel.text = "\(chaosSteps)"
        chaosStepsStepper.value = Double(chaosSteps)
        
        chaosForceLabel.text = formatter.string(from: NSNumber(value: Float(chaosForce)))
        chaosForceSlider.value = Float(chaosForce)
        
        curveChaosForceLabel.text = formatter.string(from: NSNumber(value: Float(curveChaosForce)))
        curveChaosForceSlider.value = Float(curveChaosForce)
    }
    
    @IBAction private func chaosStepsStepperChanged() {
        chaosSteps = Int(chaosStepsStepper.value)
        chaosStepsLabel.text = "\(chaosSteps)"
    }
    
    @IBAction private func chaosForceSliderChanged() {
        chaosForce = CGFloat(chaosForceSlider.value)
        chaosForceLabel.text = formatter.string(from: NSNumber(value: Float(chaosForce)))
    }
    
    @IBAction private func curveChaosForceSliderChanged() {
        curveChaosForce = CGFloat(curveChaosForceSlider.value)
        curveChaosForceLabel.text = formatter.string(from: NSNumber(value: Float(curveChaosForce)))
    }
}
