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
    
    func requestToServer(with url: URL) async throws -> Data {
        let data = try await URLSession.shared.data(from: url)

        return data.0
    }
    
    func requestGet(url: String) async throws -> Data? {
        guard let validURL = URL(string: url) else { return nil }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.get

        return try await requestToServer(with: validURL)
    }
    
    func requestPost(url: String, encodingData: Data, images: [UIImage]) async throws -> Data? {
        guard let validURL = URL(string: url) else { return nil }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.post
        urlRequest.addValue("fdbf32bf-6941-11ed-a917-5fe377d02b55", forHTTPHeaderField: "identifier")
        urlRequest.setValue("multipart/form-data; boundary=\(MultipartFormDataRequest.shared.boundary)", forHTTPHeaderField: "Content-Type")
        MultipartFormDataRequest.shared.addTextField(value: String(data: encodingData, encoding: .utf8) ?? "")
        MultipartFormDataRequest.shared.addDataField(images: images)
        
        urlRequest.httpBody = MultipartFormDataRequest.shared.httpBody as Data
        
        return try await requestToServer(with: validURL)
    }
    
    func requestPatch(url: String, encodingData: Data, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let validURL = URL(string: url) else {
            completion(.failure(.clientError))
            return
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.patch
        urlRequest.addValue("fdbf32bf-6941-11ed-a917-5fe377d02b55", forHTTPHeaderField: "identifier")
        urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
        urlRequest.httpBody = encodingData
        
//        requestToServer(with: urlRequest, completion: completion)
    }
    
    func requestDelete(url: String, encodingData: Data, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let validURL = URL(string: url) else {
            completion(.failure(.clientError))
            return
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = HTTPMethod.delete
        urlRequest.addValue("fdbf32bf-6941-11ed-a917-5fe377d02b55", forHTTPHeaderField: "identifier")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = encodingData
        
//        requestToServer(with: urlRequest, completion: completion)
    }
}
