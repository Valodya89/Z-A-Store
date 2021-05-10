//
//  BrandDetailConfigurator.swift
//  Z&A
//
//  Created by ITHD LLC on 25.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct BrandDetailConfigurator {
    static func config(brandName: String, brandDetailUrl: String) -> UIViewController {
        
        let brandDetailViewController = BrandDetailViewController.initFromStoryboard(name: Constants.Storyboard.main)
//        brandDetailViewController.router = BrandDetailRouter(viewController: brandDetailViewController)
//        brandDetailViewController.interactor = BrandDetailInteractor(presenter: BrandDetailPresenter(view: brandDetailViewController))
        brandDetailViewController.brandName = brandName
        brandDetailViewController.brandDetailUrl = brandDetailUrl
        return brandDetailViewController
    }
}
