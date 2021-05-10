//
//  HomeRouter.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

protocol HomeRouterInterface: class {
    func route(to module: HomeIRouter)
}

final class HomeRouter: HomeRouterInterface {
    weak var fromViewController: HomePageViewController?

    init(viewController: HomePageViewController?) {
        fromViewController = viewController
    }

    func route(to module: HomeIRouter) {
        switch module {
        case .card:
            fromViewController?.navigate(type: .presentWithNavigation(fullScreen: true, hideBar: false, isModal: true), module: module, completion: nil)
        }
    }
}
