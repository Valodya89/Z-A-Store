//
//  CardConfigurator.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/30/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct CardConfigurator {
    static func config() -> UIViewController {
        
        let localMemoryManager = LocalMemoryManager()
        
        let cardViewController = CardViewController.initFromStoryboard(name: Constants.Storyboard.main)
        cardViewController.router = CardRouter(viewController: cardViewController)
        cardViewController.userName = localMemoryManager.getUsername(for: .username) ?? ""
        return cardViewController
    }
}
