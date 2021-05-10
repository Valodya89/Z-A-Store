//
//  BrandListConfigurator.swift
//  Z&A
//
//  Created by ITHD LLC on 25.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct BrandListConfigurator {
    static func config(with _: String? = nil) -> UIViewController {
        
        let brandListViewController = BrandListViewController.initFromStoryboard(name: Constants.Storyboard.main)
        brandListViewController.router = BrandListRouter(viewController: brandListViewController)
//        brandListViewController.interactor = BrandListInteractor(presenter: BrandListPresenter(view: brandListViewController))
        return brandListViewController
    }
}
