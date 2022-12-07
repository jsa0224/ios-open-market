//
//  HTTPManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import UIKit

enum NetworkError: Error {
    case clientError
    case missingData
    case serverError
}

class HTTPManager {
    static let shared = HTTPManager()
    
    func requestGet(url: String, completion: @escaping (Data) -> ()) {
        guard let validURL = URL(string: url) else {
            handleError(error: NetworkError.clientError)
            return
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.get
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else {
                self.handleError(error: NetworkError.missingData)
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                if let response = urlResponse as? HTTPURLResponse {
                    print(response.statusCode)
                }
                return
            }
            
            guard error == nil else {
                self.handleError(error: NetworkError.serverError)
                return
            }
            
            completion(data)
        }.resume()
    }
    
    func requestPOST(url: String, encodingData: Data, images: [UIImage], complete: @escaping (Data) -> ()) {
        guard let validURL = URL(string: url) else {
            handleError(error: NetworkError.clientError)
            return
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.post
        urlRequest.addValue("fdbf32bf-6941-11ed-a917-5fe377d02b55", forHTTPHeaderField: "identifier")
        urlRequest.setValue("multipart/form-data; boundary=\(MultipartFormDataRequest.shared.boundary)", forHTTPHeaderField: "Content-Type")
        MultipartFormDataRequest.shared.addTextField(value: String(data: encodingData, encoding: .utf8) ?? "")
        MultipartFormDataRequest.shared.addDataField(images: images)
        
        urlRequest.httpBody = MultipartFormDataRequest.shared.httpBody as Data
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else {
                self.handleError(error: NetworkError.missingData)
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                if let response = urlResponse as? HTTPURLResponse {
                    print(response.statusCode)
                }
                return
            }
            
            guard error == nil else {
                self.handleError(error: NetworkError.serverError)
                return
            }
            
            complete(data)
        }.resume()
    }
    
    func requestPATCH(url: String, encodingData: Data, completion: @escaping (Data) -> ()) {
        guard let validURL = URL(string: url) else {
            handleError(error: NetworkError.clientError)
            return
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.patch
        urlRequest.addValue("fdbf32bf-6941-11ed-a917-5fe377d02b55", forHTTPHeaderField: "identifier")
        urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
        urlRequest.httpBody = encodingData
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else {
                self.handleError(error: NetworkError.missingData)
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                if let response = urlResponse as? HTTPURLResponse {
                    print(response.statusCode)
                }
                return
            }
            
            guard error == nil else {
                self.handleError(error: NetworkError.serverError)
                return
            }
            
            completion(data)
        }.resume()
    }
    
    func requestDELETE(url: String, encodingData: Data, complete: @escaping (Data) -> ()) {
        guard let validURL = URL(string: url) else {
            handleError(error: NetworkError.clientError)
            return
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.delete
        urlRequest.addValue("fdbf32bf-6941-11ed-a917-5fe377d02b55", forHTTPHeaderField: "identifier")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = encodingData
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                self.handleError(error: NetworkError.missingData)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                return
            }
            
            guard error == nil else {
                self.handleError(error: NetworkError.serverError)
                return
            }
            
            complete(data)
        }.resume()
    }
    
    func handleError(error: NetworkError) {
        switch error {
        case .clientError:
            print("ERROR: 클라이언트 요청 오류")
        case .missingData:
            print("ERROR: 데이터 유실")
        case .serverError:
            print("ERROR: 서버 오류")
        }
    }
}
