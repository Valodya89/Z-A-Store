//
//  PreviewQrConfigurator.swift
//  Z&A
//
//  Created by ITHD LLC on 30.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct PreviewQrConfigurator {
    static func config(with card: CardSuggestedModel? = nil) -> UIViewController {
        
        let previewQrViewController = PreviewQrViewController.initFromStoryboard(name: Constants.Storyboard.main)
//        signInViewController.router = SignInRouter(viewController: signInViewController)
//        signInViewController.interactor = SignInInteractor(presenter: SignInPresenter(view: signInViewController))
        previewQrViewController.card = card
        return previewQrViewController
    }
}
