//
//  HomeInteractor.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

final class HomeInteractor {
    var presenter: HomePresentable?

    init(presenter: HomePresentable) {
        self.presenter = presenter
    }
}

extension HomeInteractor: HomeInteractable {
    
    func addCard(_ request: HomeModel.Request) {
        
        
        let repository = Repository()

        repository.getCard(request) { result in
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
}
