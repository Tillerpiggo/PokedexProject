//
//  TextLoader.swift
//  Pokedex
//
//  Created by Tyler Gee on 12/22/23.
//

import Foundation
import UIKit

class DataLoader {
    static func loadData<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(URLError(.badURL))) }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(URLError(.badServerResponse))) }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
        }.resume()
    }
}

