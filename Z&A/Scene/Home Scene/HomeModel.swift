//
//  HomeModel.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//  Clean Swift Architecture, Template Autor Dose.

import UIKit

struct HomeModel {
    struct Request {
        // Request Data Model Type
        var pin: String
        var username: String
        var deviceId = ""
        
        internal init(username: String, pin: String) {
            self.username = username
            self.pin = pin
            self.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        }
    }

    struct Response: Codable {
        // Response Data Model Type
        var ownerName: String?
        var ownerSurname: String?
        var ownerPhone: String?
        var ownerEmail: String?
        var creationDate: Double?
        var activeUntil: UInt?
        var code: UInt?
        var type: String?
        var useCount: Int?
    }

    struct ViewModel {
        // ViewModel Type
        var cardModel: CardSuggestedModel
    }
}
