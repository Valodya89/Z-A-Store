//
//  SignUpIRouter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

enum SignUpIRouter: IRouter {
    case signIn
    case codeVerification(username: String)

    var module: UIViewController? {
        switch self {
        case .signIn:
            return SignInConfigurator.config()
        case .codeVerification(let username):
            return CodeVerificationConfigurator.config(with: username)
        }
    }
}
