//
//  BrandListIRouter.swift
//  Z&A
//
//  Created by ITHD LLC on 25.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

enum BrandListIRouter: IRouter {
    case brandDetail(brandName: String, brandDetailUrl: String)

    var module: UIViewController? {
        switch self {
        case let .brandDetail(brandName, brandDetailUrl):
            return BrandDetailConfigurator.config(brandName: brandName, brandDetailUrl: brandDetailUrl)
        }
    }
}
