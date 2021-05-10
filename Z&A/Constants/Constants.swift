//
//  Constants.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

struct Constants {
    struct Storyboard {
        static var main = "Main"
    }
    
    struct NotificationName {
        static let updateCard = NSNotification.Name("updateCard")
    }

    struct Images {
        static var logoLightIcon = "z&a_stores_icon"
        static var logoDarkIcon = "z&a_stores2_icon"
        static var blackBgIcon = "black_bg_icon"
        static var goldBgIcon = "gold_bg_icon"
        static var qrBlackIcon = "qr_code_black_icon"
        static var qrGoldIcon = "qr_code_gold_icon"
    }

    struct Requests {
//        static let BASE_URL = "http://5.63.162.11:8443/v2/api-docs"
        static var BASE_URL = "http://dcm-api.zastores.am:8080/" // http://62.171.157.66:8040/
        static let facebookURL = "https://www.facebook.com/zastores.am/"
        static let instagramURL = "https://www.instagram.com/za_stores_official/"
        static let zaURL = "https://zastores.am/"
    }
}
