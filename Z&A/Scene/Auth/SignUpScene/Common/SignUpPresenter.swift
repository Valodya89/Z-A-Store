//
//  SignUpPresenter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class SignUpPresenter {
    weak var view: SignUpDisplayable?

    init(view: SignUpViewController?) {
        self.view = view
    }
}

extension SignUpPresenter: SignUpPresentable {
    func pressent(interable model: SignUpModel.Response) {
        if let username = model.username {
            let signUpViewModel = SignUpModel.ViewModel(username: username)
            view?.display(interable: signUpViewModel)
        } else {
            view?.display(error: "Something went wrong")
        }
    }

    func pressent(with failure: String) {
        view?.display(error: failure)
    }
}
