//
//  MainViewController.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class MainViewController: UITabBarController, StoryboardInitializable {
    
    lazy var homeVC: UIViewController = {
        let vc = CardConfigurator.config()
        vc.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "ic_home_tb"), selectedImage: #imageLiteral(resourceName: "ic_home_tb"))
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isHidden = true
        return nc
    }()
    
    lazy var brandListVC: UIViewController = {
        let vc = BrandListConfigurator.config()
        vc.tabBarItem = UITabBarItem(title: "Brands", image: #imageLiteral(resourceName: "ic_brand_tb"), selectedImage: #imageLiteral(resourceName: "ic_brand_tb"))
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isHidden = true
        return nc
    }()
    
    lazy var aboutUsVC: UIViewController = {
        let vc = AboutUsViewController.initFromStoryboard(name: Constants.Storyboard.main)
        vc.tabBarItem = UITabBarItem(title: "About Us", image: #imageLiteral(resourceName: "ic_about_tb"), selectedImage: #imageLiteral(resourceName: "ic_about_tb"))
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isHidden = true
        return nc
    }()

    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTabBar()
    }
    
    /// Configure tab bar
    private func configTabBar() {
        viewControllers = [homeVC, brandListVC, aboutUsVC]
        selectedIndex = 0
    }
}
