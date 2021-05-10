//
//  Repository.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 30.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

final class Repository {
    
    private let networkManager = NetworkManager()
    
    /// Sign In
    func signIn(_ signInBody: SignInModel.Request, complition: @escaping (Result<SignInModel.Response, NetworkError>) -> ()) {
        
        networkManager.requestToPath(ZaAPITypes.signIn(signInBody).path, method: .post, params: ZaAPITypes.signIn(signInBody).parameters) { (response, success) in
            
//            guard let response = response else {
//                complition(.failure(.serverError))
//                return
//            }
            
            if let error = response as? String, !success {
                complition(.failure(.responseError(error)))
                return
            }
            
            if success, let result = ZaConverter<SignInModel.Response>.parseJson(data: response as Any) {
                // success case
                print("SUCCESS --->>>>> \(String(describing: result))")
                complition(.success(result))
            } else {
                // error case
                var errorMessage = "Something went wrong"
                if let errMessage = response as? String {
                    errorMessage = errMessage
                }
                complition(.failure(.responseError(errorMessage)))
            }
        }
    }
    
    /// Sign Up
    func signUp(_ signUpBody: SignUpModel.Request, complition: @escaping (Result<SignUpModel.Response, NetworkError>) -> ()) {
        
        networkManager.requestToPath(ZaAPITypes.signUp(signUpBody).path, method: .post, params: ZaAPITypes.signUp(signUpBody).parameters) { (response, success) in
            
//            guard let response = response else {
//                complition(.failure(.serverError))
//                return
//            }
            
            if let error = response as? String, !success {
                complition(.failure(.responseError(error)))
                return
            }
            
            if success, let result = ZaConverter<SignUpModel.Response>.parseJson(data: response as Any) {
                // success case
                print("SUCCESS --->>>>> \(String(describing: result))")
                complition(.success(result))
            } else {
                // error case
                var errorMessage = "Something went wrong"
                if let errMessage = response as? String {
                    errorMessage = errMessage
                }
                complition(.failure(.responseError(errorMessage)))
            }
        }
    }
    
    /// Resend verification code
    func resendCode(_ username: String, complition: @escaping (Result<CodeVerificationModel.Response, NetworkError>) -> ()) {
        
        networkManager.requestToPath(ZaAPITypes.resend.path + "?username=\(username)", method: .post, params: nil) { (response, success) in
            
//            guard let response = response, success else {
//                complition(.failure(.serverError))
//                return
//            }
            
            if let error = response as? String, !success {
                complition(.failure(.responseError(error)))
                return
            }
            
            if success {
                if response != nil, let result = ZaConverter<CodeVerificationModel.Response>.parseJson(data: response as Any) {
                    complition(.success(result))
                    print("SUCCESS --->>>>> \(String(describing: result))")
                } else {
                    complition(.success(CodeVerificationModel.Response()))
                }
                
            } else {
                // error case
                var errorMessage = "Something went wrong"
                if let errMessage = response as? String {
                    errorMessage = errMessage
                }
                complition(.failure(.responseError(errorMessage)))
            }
        }
    }
    
    /// Verify verification code
    func verifyCode(_ codeVerificationBody: CodeVerificationModel.Request, complition: @escaping (Result<CodeVerificationModel.Response, NetworkError>) -> ()) {
        
        networkManager.requestToPath(ZaAPITypes.verify(codeVerificationBody).path, method: .post, params: ZaAPITypes.verify(codeVerificationBody).parameters) { (response, success) in
            
//            guard let response = response else {
//                complition(.failure(.serverError))
//                return
//            }
            
            if let error = response as? String, !success {
                complition(.failure(.responseError(error)))
                return
            }
            
            if success {
                if response != nil, let result = ZaConverter<CodeVerificationModel.Response>.parseJson(data: response as Any) {
                    complition(.success(result))
                    print("SUCCESS --->>>>> \(String(describing: result))")
                } else {
                    complition(.success(CodeVerificationModel.Response()))
                }
            } else {
                // error case
                var errorMessage = "Something went wrong"
                if let errMessage = response as? String {
                    errorMessage = errMessage
                }
                complition(.failure(.responseError(errorMessage)))
            }
        }
    }
    
    
    /// Verify verification code
    func getCard(_ codeVerificationBody: HomeModel.Request, complition: @escaping (Result<HomeModel.Response, NetworkError>) -> ()) {
        
        networkManager.requestToPath(ZaAPITypes.getCard.path + "\(codeVerificationBody.pin)?deviceId=\(codeVerificationBody.deviceId)&username=\(codeVerificationBody.username)", method: .get, params: nil) { (response, success) in
            
//            guard let response = response else {
//                complition(.failure(.serverError))
//                return
//            }
            
            if let error = response as? String, !success {
                complition(.failure(.responseError(error)))
                return
            }
            
            if success {
                if response != nil, let result = ZaConverter<HomeModel.Response>.parseJson(data: response as Any) {
                    complition(.success(result))
                    print("SUCCESS --->>>>> \(String(describing: result))")
                } else {
                    complition(.success(HomeModel.Response()))
                }
            } else {
                // error case
                var errorMessage = "Something went wrong"
                if let errMessage = response as? String {
                    errorMessage = errMessage
                }
                complition(.failure(.responseError(errorMessage)))
            }
        }
    }
}
