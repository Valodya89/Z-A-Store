//
//  CodeVerificationIRouter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

enum CodeVerificationIRouter: IRouter {
    case signIn

    var module: UIViewController? {
        switch self {
        case .signIn:
            return SignInConfigurator.config()
        }
    }
}
