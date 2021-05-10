//
//  SplashRouter.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

protocol SplashRouterInterface: class {
    func route(to module: SplashIRouter)
}

final class SplashRouter: SplashRouterInterface {
    weak var fromViewController: UIViewController?

    init(controller: UIViewController) {
        fromViewController = controller
    }

    func route(to module: SplashIRouter) {
        switch module {
        case .home:
            fromViewController?.navigate(type: .root(hideBar: true), module: module, completion: nil)
        case .signIn:
            fromViewController?.navigate(type: .root(hideBar: true), module: module, completion: nil)
        case .main:
            fromViewController?.navigate(type: .root(hideBar: true), module: module, completion: nil)
        }
    }
}
