//
//  SplashViewController.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/27/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var logoImageView: UIImageView!

    // MARK: - Variables

    let animation = CABasicAnimation(keyPath: "opacity")
    private var router: SplashRouter?
    
    var username: String?
    private let localMemoryManager = LocalMemoryManager()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        
        username = localMemoryManager.getUsername(for: .username)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animationConfig()
    }

    private func config() {
        router = SplashRouter(controller: self)
    }

    // MARK: - Functions

    private func animationConfig() {
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 2.0

        CATransaction.setCompletionBlock {
            self.goToNextVC()
        }

        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        logoImageView.layer.add(animation, forKey: nil)
        CATransaction.commit()
        logoImageView.alpha = 0
    }
    
    private func goToNextVC() {
        if let userName = username {
            router?.route(to: .main(userName))
        } else {
            router?.route(to: .signIn)
        }
    }
}
