//
//  SignInIRouter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

enum SignInIRouter: IRouter {
    case signUp
    case main(_ username: String)

    var module: UIViewController? {
        switch self {
        case .signUp:
            return SignUpConfigurator.config()
        case let .main(username):
            return MainConfigrator.config(with: username)
        }
    }
}
