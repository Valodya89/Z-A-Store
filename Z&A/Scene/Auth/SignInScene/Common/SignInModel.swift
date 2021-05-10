//
//  SignInModel.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

public struct SignInModel {
    public struct Request {
        
        // Request Data Model Type
        var username: String
        var password: String
        var deviceId = ""
        
        internal init(username: String, password: String) {
            self.username = username
            self.password = password
            self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        }
    }

    struct Response: Codable {
        // Response Data Model Type
        let user: User?
        let card: CardSuggestedModel?
        
        struct User: Codable {
            let id: UInt?
            let name: String?
            let surname: String?
            let code: String?
            let username: String?
            let password: String?
            let status: String?
            let cardPin: String?
        }
    }

    struct ViewModel {
        // ViewModel Type
//        var cardModel: CardSuggestedModel
        let username: String
        let card: CardSuggestedModel?
    }
}
