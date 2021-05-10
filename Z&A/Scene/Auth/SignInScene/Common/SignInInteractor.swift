//
//  SignInInteractor.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class SignInInteractor {
    var presenter: SignInPresentable?

    init(presenter: SignInPresentable) {
        self.presenter = presenter
    }
}

extension SignInInteractor: SignInInteractable {
    
   
    
    func signIn(_ request: SignInModel.Request) {
        
        if !validate(request) { return }
        let repository = Repository()

        repository.signIn(request) { result in
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
    
    private func validate(_ request: SignInModel.Request) -> Bool {
        var isValid = true
        if request.username == "" {
            self.presenter?.pressent(with: "Username can not be empty")
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
        }
        return isValid
    }
}
