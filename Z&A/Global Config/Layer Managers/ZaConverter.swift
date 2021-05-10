//
//  ZaConverter.swift
//  Z&A
//
//  Created by ITHD LLC on 29.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

class ZaConverter<T: Decodable> : NSObject {
    
    static func toJson(data: Any) -> String {
        
        do {
            let jsonByte = try
                JSONSerialization.data(withJSONObject: data)
            let jsonData = String(data: jsonByte , encoding: String.Encoding.utf8)
            guard let json = jsonData else {
                return ""
            }
            
            return json
        } catch let _ {
            return ""
        }
    }
    
    static func parseJson(data: Any) -> T? {
        
        do {
            let jsonString = toJson(data: data)
            let jsonData = Data(jsonString.utf8)
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: jsonData)
            return result
        } catch let error {
            print(error)
            return nil
        }
    }
}
