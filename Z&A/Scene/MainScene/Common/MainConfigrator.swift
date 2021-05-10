//
//  MainConfigrator.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

import UIKit

struct MainConfigrator {
    static func config(with username: String) -> UIViewController {
        let mainViewController = MainViewController.initFromStoryboard(name: Constants.Storyboard.main)
        mainViewController.username = username
        return mainViewController
    }
}
