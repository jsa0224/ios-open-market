//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation
import UIKit

struct NetworkManager {
    public static let publicNetworkManager = NetworkManager()
    
    func getJSONData<T: Codable>(url: String, type: T.Type, completion: @escaping (T) -> Void) {
        HTTPManager.shared.requestGet(url: url) { data in
            guard let data: T = JSONConverter.shared.decodeData(data: data) else {
                return
            }
            
            completion(data)
        }
    }
    
    func getImageData(url: URL, completion: @escaping (UIImage) -> ()) {
        let cachedKey = NSString(string: "\(url)")
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            return completion(cachedImage)
        }
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                completion(image)
            }
        }
    }
}
