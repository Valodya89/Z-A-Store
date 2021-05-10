//
//  CodeVerificationInterfaces.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

protocol CodeVerificationDisplayable: class {
    /// Display Pressentable `ViewModel`
    /// - Parameter model: `ViewModel for visualisaizing UI`
    func display(interable model: CodeVerificationModel.ViewModel)
    func display(error: String)
}

protocol CodeVerificationPresentable: class {
    /// Pressent Interactable `Request`
    /// - Parameter model: `Response or Entity Model for pressenter`
    func pressent(interable model: CodeVerificationModel.Response, isResend: Bool)
    func pressent(with failure: String)
}

protocol CodeVerificationInteractable: class {
    /// Interact request from viewModel `Request`
    /// - Parameter model: `Response or Entity Model for pressenter`
    func verify(_ request: CodeVerificationModel.Request)
    func resend(_ request: CodeVerificationModel.Request)
}
