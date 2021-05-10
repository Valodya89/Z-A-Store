//
//  NetworkManager.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 29.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit
import Alamofire

typealias Completion = (_ result: Swift.Result<Any, NetworkError>?) -> ()

public enum BASE_URL: String {
    case dev = "http://dcm-api.zastores.am:8080/items/"
    case prod = "http://dcm-api.zastores.am:8080/"
}

enum HeaderType {
    case application_json
    case multipart_form_data
    case application_x_www_form_urlencoded
}

final class NetworkManager: NSObject {
    
//    private let keychain = KeychainManager()
    
    func requestToPath(_ path: String, method: HTTPMethod, params: [String: Any]?, header: HeaderType = .application_json, completion: @escaping (_ value: Any?,_ status: Bool) -> Void) {
        if path.count == 0 {
            print("Network Error: No request Endpoint")
            return
        }
        
        let url = BASE_URL.prod.rawValue + path
        
        let headerParams = "user:user123*+-"
        let data = headerParams.data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Basic \(base64)",
        ]
        
        switch header {
        case .application_json:
            headers["Accept"] = "application/json"
        case .multipart_form_data:
            headers["Content-Type"] = "multipart/form-data"
        case .application_x_www_form_urlencoded:
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        }
        
//        if let userToken = keychain.getToken() {
//            if userToken.count > 0 {
//                headers["token"] = userToken
//            }
//        }
        print("method = \(method)")
        print("requesr URL = \(url)")
        print("headers = \(headers)")
        print("params = ", params as Any)
        
        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            print("\(method.rawValue) : \(response.response?.statusCode ?? 0) ✉️ \(url) \n \(response)")
            
            switch response.response?.statusCode ?? 0 {
            case 200..<300 where response.data == nil:
                completion(response.value, true)
                return
            case 401:
//                let vc = AuthViewController.initFromStoryboard(name: Constants.Storyboards.auth)
//                let navVC = UINavigationController(rootViewController: vc)
//                UIApplication.shared.keyWindow?.rootViewController = navVC
//                UIApplication.shared.keyWindow?.makeKeyAndVisible()
                return
            case 400..<500:
                completion(self.handleServerError(response.value), false)
                return
            case 500..<600:
                completion(self.handleServerError(response.value), false)
                return
            default: break
            }
            
            switch response.result {
            case .success:
                print(response)
                completion(response.value, true)
                break
            case .failure(let error):
                print(error)
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .dataNotAllowed, .notConnectedToInternet, .timedOut:
                            print("ERROR: dataNotAllowed, notConnectedToInternet or timedOut")
                            completion("Problems with connection", false)
                        default:
                            print("Unmanaged error")
                            completion(response.value, false)
                        }
                    }
                } else {
                    completion(response.value, false)
                }
            }
        }
    }
    
    func requestToQueryPath(_ path: String, method: HTTPMethod, params: [String: Any]?, header: HeaderType = .application_json, completion: @escaping (_ value: Any?,_ status: Bool) -> Void, uploadProgress: ((_ value: Double?,_ status: Bool) -> Void)? = nil) {
        
        if path.count == 0 {
            print("Network Error: No request Endpoint")
            return
        }
        
        let url = BASE_URL.prod.rawValue + path
        
        var headers: HTTPHeaders = [
            "agent": "carrier"
        ]
        
        switch header {
        case .application_json:
            headers = ["Accept": "application/json"]
        case .multipart_form_data:
            headers["Content-Type"] = "multipart/form-data"
        case .application_x_www_form_urlencoded:
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        }
        
        //        if let userToken = keychain.getToken() {
        //            if userToken.count > 0 {
        //                headers["token"] = userToken
        //            }
        //        }
        print("method = \(method)")
        print("requesr URL = \(url)")
        print("headers = \(headers)")
        print("params = ", params as Any)
        
        AF.request(url, method: method, parameters: params, encoding: URLEncoding(destination: .queryString), headers: headers).responseJSON {
            response in
            
            switch response.response?.statusCode ?? 0 {
            case 401:
//                let vc = AuthViewController.initFromStoryboard(name: Constants.Storyboards.auth)
//                let navVC = UINavigationController(rootViewController: vc)
//                UIApplication.shared.keyWindow?.rootViewController = navVC
//                UIApplication.shared.keyWindow?.makeKeyAndVisible()
                return
            case 400..<500:
                completion(self.handleServerError(response.value), false)
                return
            case 500..<600:
                completion(self.handleServerError(response.value), false)
                return
            default: break
            }
            
            switch response.result {
            case .success:
                print(response)
                completion(response.value, true)
                break
            case .failure(let error):
                print(error)
                if let underlyingError = error.underlyingError {
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .dataNotAllowed, .notConnectedToInternet, .timedOut:
                            print("ERROR: dataNotAllowed, notConnectedToInternet or timedOut")
                            completion("Problems with connection", false)
                        default:
                            print("Unmanaged error")
                            completion(response.value, false)
                        }
                    }
                } else {
                    completion(response.value, false)
                }
            }
        }
    }
    
    func handleServerError(_ response: Any?) -> String {
        if let responseValue = response as? [String: Any], !responseValue.isEmpty {
            
            if let error = responseValue["message"] as? String {
                return error
            }
            
            if let errors = responseValue.first?.value as? [String], !errors.isEmpty {
                return errors.first!
            }
        }
        return "Something went wrong.."
    }
}

public enum NetworkError: Error {
    case validatorError(_ errorMessage: String)
    case responseError(_ errorMessage: String)
    case serverError
}
