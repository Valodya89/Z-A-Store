//
//  HomePresenter.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

final class HomePresenter {
    weak var view: HomeDisplayable?

    init(view: HomePageViewController?) {
        self.view = view
    }
}

extension HomePresenter: HomePresentable {
    func pressent(interable model: HomeModel.Response) {
        
        let card = CardSuggestedModel(
            ownerName: model.ownerName ?? "",
            ownerSurname: model.ownerSurname ?? "",
            ownerPhone: model.ownerPhone ?? "",
            ownerEmail: model.ownerEmail ?? "",
            creationDate: model.creationDate ?? 0,
            activeUntil: model.activeUntil ?? 0,
            code: model.code ?? 0,
            type: model.type ?? "",
            useCount: model.useCount ?? 0)
        let localMemoryManager = LocalMemoryManager()
        localMemoryManager.storeObj(model: card, for: .card)
        view?.display(interable: HomeModel.ViewModel(cardModel: card))
    }

    func pressent(with failure: String) {
        view?.display(error: failure)
    }
}
