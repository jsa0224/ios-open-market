//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/23.
//

import Foundation
import UIKit.UIImage

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
