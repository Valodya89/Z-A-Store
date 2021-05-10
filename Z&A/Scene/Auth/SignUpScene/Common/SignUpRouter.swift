//
//  SignUpRouter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

protocol SignUpRouterInterface: class {
    func route(to module: SignUpIRouter)
}

final class SignUpRouter: SignUpRouterInterface {
    weak var fromViewController: SignUpViewController?

    init(viewController: SignUpViewController?) {
        fromViewController = viewController
    }

    func route(to module: SignUpIRouter) {
        switch module {
        case .signIn:
            fromViewController?.navigate(type: .root(hideBar: true), module: module, completion: nil)
        case .codeVerification:
            fromViewController?.navigate(type: .push(hideBar: true), module: module, completion: nil)
        }
    }
}
