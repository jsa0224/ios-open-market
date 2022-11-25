//
//  JSONConverter.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation

final class JSONConverter {
    static let shared = JSONConverter()
    
    func decodeData<T: Codable>(data: Data) -> T? {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            guard let error = error as? DecodingError else { return nil }
            
            switch error {
            case .dataCorrupted(let context):
                print(context.codingPath, context.debugDescription, context.underlyingError ?? "", separator: "\n")
                return nil
            default :
                return nil
            }
        }
    }
}
