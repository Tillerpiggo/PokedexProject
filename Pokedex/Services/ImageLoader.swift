//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/21/23.
//

import Foundation
import UIKit

class ImageLoader {
    func loadImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(URLError(.badURL)))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            guard let _ = response else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
            DispatchQueue.main.sync {
                completion(.success(image))
            }
        }.resume()
    }
}
