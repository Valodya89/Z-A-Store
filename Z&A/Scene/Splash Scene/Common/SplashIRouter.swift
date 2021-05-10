//
//  SplashIRouter.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

enum SplashIRouter: IRouter {
    case home(_ username: String)
    case signIn
    case main(_ username: String)

    var module: UIViewController? {
        switch self {
        case .home(let username):
            return HomeConfigurator.config(with: username)
        case .signIn:
            return SignInConfigurator.config()
        case let .main(username):
            return MainConfigrator.config(with: username)
        }
    }
}
