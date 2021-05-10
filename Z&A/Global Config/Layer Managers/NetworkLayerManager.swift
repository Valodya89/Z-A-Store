//
//  NetworkLayerManager.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import Foundation

struct APIS {
//    static var API_URL = "http://3.12.116.34/items/"
    static var API_URL = "http://dcm-api.zastores.am:8080/items/" //"http://62.171.157.66:8040/items/"
    static var BASE_URL = "http://dcm-api.zastores.am:8080/"
}

enum NetworkManagerErrors: Error {
    case badRequest
    case badResponse
    case badURL
}

enum NetworkManagerRequestCases {
    case get
    case post(params: [String: Any]?)
}

class NetworkLayerManager {
    private var url: URL?
    private var caseType: NetworkManagerRequestCases
    var base64: String = ""
    var request: URLRequest?

    init(posURL: URL, caseType: NetworkManagerRequestCases = .get, query _: OperationQueue?) {
        url = posURL

        self.caseType = caseType
        authUserAdmin()
    }

    init(posRequest: URLRequest, caseType: NetworkManagerRequestCases = .get, query _: OperationQueue?) {
        request = posRequest
        self.caseType = caseType
        authUserAdmin()
    }

    public func addPinCode(code: String) {
        url = URL(string: url!.absoluteString + code + "?")
    }

    public func addUniqId(id: String) {
        url = URL(string: url!.absoluteString + "deviceId=" + String(id))
    }

    private func authUserAdmin() {
        let headerParams = "user:user123*+-"
        let data = headerParams.data(using: String.Encoding.utf8)
        base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("base64 = \(base64)")
    }

    public func doRequest(completion: @escaping (Result<Data, NetworkManagerErrors>) -> Void) {
        self.request = URLRequest(url: url!)
        guard var request = request else { fatalError("Cant find URLRequest please change constructor params") }
        if case let .post(params) = caseType {
            request.httpMethod = "POST"
            request.addValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params ?? [], options: .prettyPrinted)

            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let httpResponse = response as? HTTPURLResponse,
                    !(200 ... 299).contains(httpResponse.statusCode) {
                    print("Request status code = \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(Result.failure(.badResponse))
                    }
                }
                
                guard error == nil else {
                    completion(Result.failure(.badRequest))
                    return
                }
                guard let data = data else { return }

                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                    print("JSON = \(json)")
                }
                DispatchQueue.main.async {
                    completion(Result.success(data))
                }
            }.resume()

        } else if case .get = caseType {
            request.httpMethod = "GET"
            request.addValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in

                if let httpResponse = response as? HTTPURLResponse,
                    !(200 ... 299).contains(httpResponse.statusCode) {
                    print("Request status code = \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(Result.failure(.badResponse))
                    }
                }

                guard error == nil else { return }
                guard let data = data else { return }
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                    print("JSON = \(json)")
                }

                DispatchQueue.main.async {
                    completion(Result.success(data))
                }
            }.resume()
        }
    }
}
