//
//  Brush.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 07/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

struct Brush {
    var color: UIColor
    var withFill: Bool
    var lineWidth: CGFloat
    
    static let base = Brush(color: .black, withFill: true, lineWidth: 1)
}
