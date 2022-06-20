//
//  Networking.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case requestError(Error)
    case noData
    case decodingError(DecodingError)
}

class Networking {
    private static var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private static var urlSession: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    
    static func request<T: Decodable>(
        responseType: T.Type,
        urlString: String,
        completion: @escaping (_ result: Result<T, NetworkingError>) -> Void
    ) {
        let mainThreadCompletion = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let url = URL(string: urlString) else {
            mainThreadCompletion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                mainThreadCompletion(.failure(.requestError(error)))
                return
            }
            
            guard let data = data else {
                mainThreadCompletion(.failure(.noData))
                return
            }
            
            do {
                let decodedData = try Networking.jsonDecoder.decode(T.self, from: data)
                mainThreadCompletion(.success(decodedData))
            } catch let error as DecodingError {
                mainThreadCompletion(.failure(.decodingError(error)))
            } catch {
                mainThreadCompletion(.failure(.requestError(error)))
            }
        }
        
        task.resume()
    }
}
