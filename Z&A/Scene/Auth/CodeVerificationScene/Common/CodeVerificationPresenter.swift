//
//  CodeVerificationPresenter.swift
//  Z&A
//
//  Created by ITHD LLC on 23.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class CodeVerificationPresenter {
    weak var view: CodeVerificationDisplayable?

    init(view: CodeVerificationViewController?) {
        self.view = view
    }
}

extension CodeVerificationPresenter: CodeVerificationPresentable {
    func pressent(interable model: CodeVerificationModel.Response, isResend: Bool) {
        view?.display(interable: CodeVerificationModel.ViewModel(isResend: isResend, isVerify: !isResend))
    }

    func pressent(with failure: String) {
        view?.display(error: failure)
    }
}
