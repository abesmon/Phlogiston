//
//  NSLayoutConstraint_ext.swift
//  Phlogiston
//
//  Created by Лысенко Алексей Димитриевич on 30/04/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func withMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
    }
}
