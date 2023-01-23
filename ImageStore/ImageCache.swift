//
//  ImageCache.swift
//
//  Created by Ashish Badak on 10/01/23.
//

import Foundation
import UIKit

public enum ImageError: Error {
    case noData
}

public typealias ImageCallback = (Result<UIImage, ImageError>) -> Void

public class ImageCache {
    private var cache = NSCache<NSURL, UIImage>()
    private var imageDownloader = ImageDownloader()
    
    static let shared: ImageCache = ImageCache()
    
    private func image(forKey key: URL) -> UIImage? {
        cache.object(forKey: key as NSURL)
    }
    
    private func setImage(_ image: UIImage, forKey key: URL) {
        cache.setObject(image, forKey: key as NSURL)
    }
    
    public func fetchImage(
        for url: URL,
        completion: @escaping ImageCallback
    ) {
        if let cachedImage = image(forKey: url) {
            completion(.success(cachedImage))
            return
        }
        
        imageDownloader.fetchImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.setImage(image, forKey: url)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
