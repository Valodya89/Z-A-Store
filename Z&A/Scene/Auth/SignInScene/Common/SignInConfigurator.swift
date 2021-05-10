//
//  SignInConfigurator.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct SignInConfigurator {
    static func config(with _: String? = nil) -> UIViewController {
        
        let signInViewController = SignInViewController.initFromStoryboard(name: Constants.Storyboard.main)
        signInViewController.router = SignInRouter(viewController: signInViewController)
        signInViewController.interactor = SignInInteractor(presenter: SignInPresenter(view: signInViewController))
        
        return signInViewController
    }
}
