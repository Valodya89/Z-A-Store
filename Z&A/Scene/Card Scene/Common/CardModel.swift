//
//  CardModel.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

struct CardSuggestedModel: Codable {
    var ownerName: String
    var ownerSurname: String
    var ownerPhone: String
    var ownerEmail: String
    var creationDate: Double
    var activeUntil: UInt
    var code: UInt
    var type: String
    var useCount: Int
}

struct CardModel: Codable {
    struct Request {}

    struct Response {
        var responseData: Data
    }

    struct ViewModel {}
}

public struct CodableImage: Codable {
    public var string: String

    var toImage: UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}

public struct TimeConvertr: Codable {
    public var unixtimeInterval: UInt

    var toString: String? {
        var unixtimeIntervalBySeccond: UInt = 0
        if "\(unixtimeInterval)".count > 10 {
            unixtimeIntervalBySeccond = unixtimeInterval / 1000
        } else {
            unixtimeIntervalBySeccond = unixtimeInterval
        }
        let date = Date(timeIntervalSince1970: TimeInterval(unixtimeIntervalBySeccond))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "GMT+04:00")
        return dateFormatter.string(from: date)
    }
}
