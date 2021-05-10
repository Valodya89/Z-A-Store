//
//  CyrcleButton.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/27/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class CyrcleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

final class CyrcleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
