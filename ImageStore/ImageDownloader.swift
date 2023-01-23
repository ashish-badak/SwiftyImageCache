//
//  ImageDownloader.swift
//
//  Created by Ashish Badak on 10/01/23.
//

import Foundation
import UIKit

class ImageDownloader {
    private var completionCallbacks = [URL: [ImageCallback]]()
    
    func fetchImage(
        from url: URL,
        completion: @escaping ImageCallback
    ) {
        if completionCallbacks[url] != nil {
            completionCallbacks[url]?.append(completion)
            return
        } else {
            completionCallbacks[url] = [completion]
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) {
            [weak self] (data, response, error) in
            
            defer {
                self?.completionCallbacks.removeValue(forKey: url)
            }
            
            guard error == nil, let image = data?.image else {
                self?.completionCallbacks[url]?.forEach { callback in
                    callback(.failure(.noData))
                }
                return
            }
            
            self?.completionCallbacks[url]?.forEach { callback in
                callback(.success(image))
            }
        }.resume()
    }
}

extension Data {
    var image: UIImage? {
        UIImage(data: self)
    }
}
