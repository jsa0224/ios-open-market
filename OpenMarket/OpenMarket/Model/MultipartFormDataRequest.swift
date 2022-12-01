//
//  MultipartFormDataRequest.swift
//  OpenMarket
//
//  Created by 정선아 on 2022/11/30.
//

import Foundation

final class MultipartFormDataRequest {
    static let shared = MultipartFormDataRequest()
    
    let boundary: String = UUID().uuidString
    var httpBody = NSMutableData()
    
    func addTextField(value: String) {
        httpBody.append(textFormField(value: value))
    }
    
    private func textFormField(value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"params\"\r\n"
        fieldString += "Content-Type: application/json\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    func addDataField(data: Data) {
        httpBody.append(dataFormField(data: data))
    }
    
    private func dataFormField(data: Data) -> Data {
        let fieldData = NSMutableData()
        
        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"images\"; filename=\"som1\"\r\n")
        fieldData.append("Content-Type: image/png\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")
        fieldData.append("--\(boundary)--\r\n")
        
        return fieldData as Data
    }
}

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
