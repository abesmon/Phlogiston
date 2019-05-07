//
//  DrawingTool.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 07/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

struct DrawingTool {
    var fillColor: UIColor?
    var strokeColor: UIColor?
    var lineWidth: CGFloat = 1
    
    static let base = DrawingTool(fillColor: UIColor(hue: 1, saturation: 1, brightness: 0, alpha: 1), strokeColor: UIColor(hue: 1, saturation: 1, brightness: 0, alpha: 1), lineWidth: 1)
}
