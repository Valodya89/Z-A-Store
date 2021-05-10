//
//  SignInPresenter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class SignInPresenter {
    weak var view: SignInDisplayable?

    init(view: SignInViewController?) {
        self.view = view
    }
}

extension SignInPresenter: SignInPresentable {
    func pressent(interable model: SignInModel.Response) {
        if let username = model.user?.username {
            let localMemoryManager = LocalMemoryManager()
            let signInViewModel = SignInModel.ViewModel(username: username, card: model.card)
            localMemoryManager.store(model: username, for: .username)
            if let cardModel = model.card {
                localMemoryManager.storeObj(model: cardModel, for: .card)
            }
            view?.display(interable: signInViewModel)
        } else {
            view?.display(error: "Something went wrong")
        }
    }

    func pressent(with failure: String) {
        view?.display(error: failure)
    }
}
