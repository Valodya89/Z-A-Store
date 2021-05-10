//
//  StoryboardInitializable.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

/// Collapse Initialble identity
/// * Identifier * to get Controllers Storyboard Identitiy
protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    /// Storyboard Identity
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

    /// Init Self From storyboard
    /// - Parameter name: Storyboard Name
    static func initFromStoryboard(name: String) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
