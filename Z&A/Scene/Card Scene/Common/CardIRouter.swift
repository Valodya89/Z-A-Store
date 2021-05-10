//
//  CardIRouter.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/31/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

enum CardIRouter: IRouter {
    case addCard(_ username: String)
    case signIn
    case previewQR(_ card: CardSuggestedModel)

    var module: UIViewController? {
        switch self {
        case .addCard(let username):
            return HomeConfigurator.config(with: username)
        case .signIn:
            return SignInConfigurator.config()
        case .previewQR(let card):
            return PreviewQrConfigurator.config(with: card)
        }
    }
}
