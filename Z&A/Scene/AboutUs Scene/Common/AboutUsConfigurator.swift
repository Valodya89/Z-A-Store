//
//  AboutUsConfigurator.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/31/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct AboutUsConfigurator {
    static func config() -> UIViewController {
        let aboutUsViewController = AboutUsViewController.initFromStoryboard(name: Constants.Storyboard.main)
        return aboutUsViewController
    }
}
