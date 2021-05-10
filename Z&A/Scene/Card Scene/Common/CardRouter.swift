//
//  CardRouter.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/31/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

protocol CardRouterInterface: class {
    func route(to module: CardIRouter)
}

final class CardRouter: CardRouterInterface {
    weak var fromViewController: CardViewController?

    init(viewController: CardViewController?) {
        fromViewController = viewController
    }

    func route(to module: CardIRouter) {
        switch module {
        case .addCard:
            fromViewController?.navigate(type: .present(fullScreen: false), module: module, completion: nil)
        case .signIn:
            fromViewController?.navigate(type: .root(hideBar: true), module: module, completion: nil)
        case .previewQR:
            fromViewController?.navigate(type: .present(fullScreen: false), module: module, completion: nil)
        }
    }
}
