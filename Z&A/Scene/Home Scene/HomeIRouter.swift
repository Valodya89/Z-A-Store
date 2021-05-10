//
//  HomeIRouter.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

enum HomeIRouter: IRouter {
    case card

    var module: UIViewController? {
        switch self {
        case .card:
            return CardConfigurator.config()
        }
    }
}
