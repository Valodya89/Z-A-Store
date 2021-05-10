//
//  CodeVerificationConfigurator.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct CodeVerificationConfigurator {
    static func config(with username: String) -> UIViewController {
        let codeVerificationViewController = CodeVerificationViewController.initFromStoryboard(name: Constants.Storyboard.main)
        codeVerificationViewController.router = CodeVerificationRouter(viewController: codeVerificationViewController)
        codeVerificationViewController.interactor = CodeVerificationInteractor(presenter: CodeVerificationPresenter(view: codeVerificationViewController))
        codeVerificationViewController.username = username

        return codeVerificationViewController
    }
}
