//
//  HomeInterfaces.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

protocol HomeDisplayable: class {
    /// Display Pressentable `ViewModel`
    /// - Parameter model: `ViewModel for visualisaizing UI`
    func display(interable model: HomeModel.ViewModel)
    func display(error: String)
}

protocol HomePresentable: class {
    /// Pressent Interactable `Request`
    /// - Parameter model: `Response or Entity Model for pressenter`
    func pressent(interable model: HomeModel.Response)
    func pressent(with failure: String)
}

protocol HomeInteractable: class {
    /// Interact request from viewModel `Request`
    /// - Parameter model: `Response or Entity Model for pressenter`
    func addCard(_ request: HomeModel.Request)
}
