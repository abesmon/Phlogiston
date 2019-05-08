//
//  ProcessorVC.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 08/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

class ProcessorVC: UIViewController {
    @IBOutlet private weak var processorControllerContainer: UIView!
    
    private let processors: [DrawProcessor] = [
        CoreProcessor(),
        ChaoticProcessor()
    ]
    private var selectedProcessorIndex: Int = 0
    var processor: DrawProcessor {
        return processors[selectedProcessorIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateControllerView()
    }
    
    @IBAction private func corePressed() {
        selectedProcessorIndex = 0
        updateControllerView()
    }
    
    @IBAction private func chaoticPressed() {
        selectedProcessorIndex = 1
        updateControllerView()
    }
    
    private func updateControllerView() {
        processorControllerContainer.subviews.forEach { $0.removeFromSuperview() }
        if let view = processor.processorViewController?.view {
            processorControllerContainer.addSubview(view)
            view.frame = CGRect(origin: .zero, size: processorControllerContainer.frame.size)
        }
    }
}
