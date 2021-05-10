//
//  CodeVerificationInteractor.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class CodeVerificationInteractor {
    var presenter: CodeVerificationPresentable?

    init(presenter: CodeVerificationPresentable) {
        self.presenter = presenter
    }
}

extension CodeVerificationInteractor: CodeVerificationInteractable {
    func verify(_ request: CodeVerificationModel.Request) {
        
        if !validate(request) { return }
        let repository = Repository()
        
        repository.verifyCode(request) { result in
            switch result {
            case .success(let response):
                self.presenter?.pressent(interable: response, isResend: false)
            case .failure(let error):
                if case let .responseError(errorMessage) = error {
                    self.presenter?.pressent(with: errorMessage)
                } else {
                    self.presenter?.pressent(with: "Something went wrong")
                }
            }
        }
    }
    
    func resend(_ request: CodeVerificationModel.Request) {
        
        let repository = Repository()

        repository.resendCode(request.username) { result in
            switch result {
            case .success(let response):
                self.presenter?.pressent(interable: response, isResend: true)
            case .failure(let error):
                if case let .responseError(errorMessage) = error {
                    self.presenter?.pressent(with: errorMessage)
                } else {
                    self.presenter?.pressent(with: "Something went wrong")
                }
            }
        }
    }
    
    private func validate(_ request: CodeVerificationModel.Request) -> Bool {
        var isValid = true
        if request.verificationCode.count == 0 {
            self.presenter?.pressent(with: "Validation code is empty")
            isValid = false
        } else if request.verificationCode.count != 5 {
            self.presenter?.pressent(with: "Please fill valid code")
            isValid = false
        }
        return isValid
    }
}
