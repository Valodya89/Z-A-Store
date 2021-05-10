//
//  HomeConfiguration.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

struct HomeConfigurator {
    static func config(with username: String) -> UIViewController {
        let homePageViewController = HomePageViewController.initFromStoryboard(name: Constants.Storyboard.main)
        homePageViewController.router = HomeRouter(viewController: homePageViewController)
        homePageViewController.interactor = HomeInteractor(presenter: HomePresenter(view: homePageViewController))
        homePageViewController.username = username

        return homePageViewController
    }
}
