//
//  SignInRouter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

protocol SignInRouterInterface: class {
    func route(to module: SignInIRouter)
}

final class SignInRouter: SignInRouterInterface {
    weak var fromViewController: SignInViewController?

    init(viewController: SignInViewController?) {
        fromViewController = viewController
    }

    func route(to module: SignInIRouter) {
        switch module {
        case .signUp:
            fromViewController?.navigate(type: .root(hideBar: true), module: module, completion: nil)
        case .main:
            fromViewController?.navigate(type: .root(hideBar: true), module: module, completion: nil)
        }
    }
}
