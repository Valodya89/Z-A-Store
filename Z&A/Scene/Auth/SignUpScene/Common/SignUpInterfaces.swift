//
//  SignUpInterfaces.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

protocol SignUpDisplayable: class {
    /// Display Pressentable `ViewModel`
    /// - Parameter model: `ViewModel for visualisaizing UI`
    func display(interable model: SignUpModel.ViewModel)
    func display(error: String)
}

protocol SignUpPresentable: class {
    /// Pressent Interactable `Request`
    /// - Parameter model: `Response or Entity Model for pressenter`
    func pressent(interable model: SignUpModel.Response)
    func pressent(with failure: String)
}

protocol SignUpInteractable: class {
    /// Interact request from viewModel `Request`
    /// - Parameter model: `Response or Entity Model for pressenter`
    func signUp(_ request: SignUpModel.Request)
}
