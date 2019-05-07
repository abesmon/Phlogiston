//
//  CGPoint_ext.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 07/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

extension CGPoint {
    func midInBetween(to other: CGPoint) -> CGPoint {
        return CGPoint(x: (x + other.x) / 2, y: (y + other.y) / 2)
    }
    
    func added(_ other: CGPoint) -> CGPoint {
        return CGPoint(x: x + other.x, y: y + other.y)
    }
    
    static func random(withForce force: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat.random(in: -force...force), y: CGFloat.random(in: -force...force))
    }
}
