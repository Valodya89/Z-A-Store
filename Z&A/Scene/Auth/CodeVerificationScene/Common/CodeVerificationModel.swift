//
//  CodeVerificationModel.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

public struct CodeVerificationModel {
    public struct Request {
        // Request Data Model Type
        var verificationCode: String
        var username: String
    }

    struct Response: Codable {
        // Response Data Model Type
    }

    struct ViewModel {
        // ViewModel Type
        var isResend = false
        var isVerify = false
    }
}

