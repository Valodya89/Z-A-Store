//
//  BrandListRouter.swift
//  Z&A
//
//  Created by ITHD LLC on 25.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

protocol BrandListRouterInterface: class {
    func route(to module: BrandListIRouter)
}

final class BrandListRouter: BrandListRouterInterface {
    weak var fromViewController: BrandListViewController?

    init(viewController: BrandListViewController?) {
        fromViewController = viewController
    }

    func route(to module: BrandListIRouter) {
        switch module {
        case .brandDetail:
            fromViewController?.navigate(type: .push(hideBar: true), module: module, completion: nil)
        }
    }
}
