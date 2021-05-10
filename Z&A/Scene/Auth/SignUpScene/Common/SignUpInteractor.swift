//
//  SignUpInteractor.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class SignUpInteractor {
    var presenter: SignUpPresentable?

    init(presenter: SignUpPresentable) {
        self.presenter = presenter
    }
}

extension SignUpInteractor: SignUpInteractable {
    func signUp(_ request: SignUpModel.Request) {
        
        if !validate(request) { return }
        let repository = Repository()

        repository.signUp(request) { result in
            switch result {
            case .success(let response):
                self.presenter?.pressent(interable: response)
            case .failure(let error):
                if case let .responseError(errorMessage) = error {
                    self.presenter?.pressent(with: errorMessage)
                } else {
                    self.presenter?.pressent(with: "Something went wrong")
                }
            }
        }
    }
    
    private func validate(_ request: SignUpModel.Request) -> Bool {
        var isValid = true
        if request.name == "" {
            self.presenter?.pressent(with: "First name can not be empty")
            isValid = false
        } else if request.surname == "" {
            self.presenter?.pressent(with: "Last name can not be empty")
            isValid = false
        } else if request.username == "" {
            self.presenter?.pressent(with: "Email can not be empty")
            isValid = false
        } else if !request.username.isValidEmail() {
            self.presenter?.pressent(with: "Invalid email")
            isValid = false
        } else if request.password == "" {
            self.presenter?.pressent(with: "Password can not be empty")
            isValid = false
        } else if request.password.count < 8 {
            self.presenter?.pressent(with: "Password must contains minimum 8 charackters")
            isValid = false
        } else if request.password != request.confirmPassword {
            self.presenter?.pressent(with: "Passwords don't match")
            isValid = false
        }
        return isValid
    }
}
