//
//  SignUpConfigurator.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct SignUpConfigurator {
    static func config(with _: String? = nil) -> UIViewController {
        
        let signUpViewController = SignUpViewController.initFromStoryboard(name: Constants.Storyboard.main)
        signUpViewController.router = SignUpRouter(viewController: signUpViewController)
        signUpViewController.interactor = SignUpInteractor(presenter: SignUpPresenter(view: signUpViewController))
        
        return signUpViewController
    }
}
