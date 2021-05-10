//
//  SignUpModel.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

public struct SignUpModel {
    public struct Request {
        // Request Data Model Type
        var name: String
        var surname: String
        var username: String
        var password: String
        var confirmPassword: String
    }

    struct Response: Codable {
        // Response Data Model Type
        let id: UInt
        let name: String?
        let surname: String?
        let code: String?
        let username: String?
        let password: String?
        let status: String?
        let cardPin: String?
    }

    struct ViewModel {
        // ViewModel Type
        let username: String
    }
}
