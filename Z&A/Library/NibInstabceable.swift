//
//  NibInstabceable.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

public protocol NibInstantiatable {
    static func nibName() -> String
}

extension NibInstantiatable {
    /// Nib name
    static func nibName() -> String {
        return String(describing: self)
    }
}

extension NibInstantiatable where Self: UIView {
    /// Load Nib
    static func loadNib() -> UINib {
        return UINib(nibName: nibName(), bundle: Bundle(for: self))
    }

    /// Load and get nib frin Bundle
    static func fromNib() -> Self {
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
        return nib!.first as! Self
    }
}
