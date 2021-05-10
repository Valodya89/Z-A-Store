//
//  LocalMemoryManager.swift
//  Z&A
//
//  Created by ITHD LLC on 30.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import Foundation


final class LocalMemoryManager {
    
    private let userDefaults = UserDefaults.standard

    
    func store(model: Codable, for key: UserDefaultsKey) {
        userDefaults.set(model, forKey: key.rawValue)
//        userDefaults.setStruct(model, forKey: key.rawValue)
//        do {
//            try userDefaults.setObjectt(model, forKey: key.rawValue)
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    func storeObj<T: Codable>(model: T, for key: UserDefaultsKey) {
        
        do {
            try userDefaults.setObjectt(model, forKey: key.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getUsername(for key: UserDefaultsKey) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
    
    func remove(for key: UserDefaultsKey) {
        return userDefaults.removeObject(forKey: key.rawValue)
    }
    
    func fetchCard(for key: UserDefaultsKey) -> CardSuggestedModel? {
        do {
            return try userDefaults.getObject(forKey: key.rawValue, castTo: CardSuggestedModel.self)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchBrendList(for key: UserDefaultsKey) -> BrendList? {
        do {
            return try userDefaults.getObject(forKey: key.rawValue, castTo: BrendList.self)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchBrendDetailsList(for key: UserDefaultsKey) -> BrendDetailsList? {
        do {
            return try userDefaults.getObject(forKey: key.rawValue, castTo: BrendDetailsList.self)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}


enum UserDefaultsKey: String {
    case card
    case username
    case brendList
    case brendDetailsList
}


extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}
