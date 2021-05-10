//
//  SignInInterfaces.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

protocol SignInDisplayable: class {
    /// Display Pressentable `ViewModel`
    /// - Parameter model: `ViewModel for visualisaizing UI`
    func display(interable model: SignInModel.ViewModel)
    func display(error: String)
}

protocol SignInPresentable: class {
    /// Pressent Interactable `Request`
    /// - Parameter model: `Response or Entity Model for pressenter`
    func pressent(interable model: SignInModel.Response)
    func pressent(with failure: String)
}

protocol SignInInteractable: class {
    /// Interact request from viewModel `Request`
    /// - Parameter model: `Response or Entity Model for pressenter`
    func signIn(_ request: SignInModel.Request)
}
