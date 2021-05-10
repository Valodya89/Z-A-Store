//
//  CodeVerificationRouter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

protocol CodeVerificationRouterInterface: class {
    func route(to module: CodeVerificationIRouter)
}

final class CodeVerificationRouter: CodeVerificationRouterInterface {
    weak var fromViewController: CodeVerificationViewController?

    init(viewController: CodeVerificationViewController?) {
        fromViewController = viewController
    }

    func route(to module: CodeVerificationIRouter) {
        switch module {
        case .signIn:
            fromViewController?.navigate(type: .root(hideBar: true), module: module, completion: nil)
        }
    }
}

