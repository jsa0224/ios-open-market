//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import UIKit

struct NetworkManager {
    public static let publicNetworkManager = NetworkManager()
    
    func getJSONData<T: Codable>(url: String, type: T.Type) async throws -> T? {
        guard let data = try await HTTPManager.shared.requestGet(url: url) else { return nil }

        return JSONConverter.shared.decodeData(data: data)
    }
    
    func getImageData(url: String) async throws -> UIImage? {
        let cachedKey = NSString(string: "\(url)")

        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            return cachedImage
        }

        guard let data = try await HTTPManager.shared.requestGet(url: url) else { return nil }

        guard let image = UIImage(data: data) else {
            return nil
        }

        return image
    }
}
