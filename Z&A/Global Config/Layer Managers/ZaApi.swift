//
//  ZaApi.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 29.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

public enum ZaAPITypes {
    // Auth
    case signIn(_ signInBody: SignInModel.Request)
    case signUp(_ signUpBody: SignUpModel.Request)
    case verify(_ codeVerificationBody: CodeVerificationModel.Request)
    case resend
    case getCard

    case non
}

extension ZaAPITypes {
    public var path: String {
        switch self {
        case .signIn:
            return "api/accounts/sign-in"
        case .signUp:
            return "api/accounts/register"
        case .verify:
            return "api/accounts/verify"
        case .resend:
            return "api/accounts/resend"
        case .getCard:
            return "items/"
        case .non:
            return ""
        }
    }
}

extension ZaAPITypes {
    public var parameters: [String: Any] {
        switch self {
        case let .signIn(signInBody):
            return [
                "deviceId": signInBody.deviceId,
                "username": signInBody.username,
                "password": signInBody.password,
            ]
        case let .signUp(signUpBody):
            return [
                "name": signUpBody.name,
                "surname": signUpBody.surname,
                "username": signUpBody.username,
                "password": signUpBody.password,
            ]
        case let .verify(codeVerificationBody):
            return [
                "username": codeVerificationBody.username,
                "code": codeVerificationBody.verificationCode
            ]
        case .resend:
            return [:]
        case .getCard:
            return [:]
        case .non:
            return [:]
        }
    }
}

//extension DgsAPI {
//    func convertModelToDictionary<T: Encodable>(_ model: T) ->  [String : Any] {
//        do {
//            return try model.asDictionary()
//        } catch {
//            return [:]
//        }
//    }
//}

class ZaAPI: NSObject {
    
    static let shared = ZaAPI()
    var requestName: ZaAPITypes = .non
}


extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
