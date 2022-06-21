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
    
    private static var jsonEncoder: JSONEncoder = {
        let decoder = JSONEncoder()
        return decoder
    }()
    
    private static var urlSession: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    
    static func request<T: Decodable>(
        responseType: T.Type,
        endpoint: Endpoint,
        completion: @escaping (_ result: Result<T, NetworkingError>) -> Void
    ) {
        let mainThreadCompletion = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let url = endpoint.fullURL else {
            mainThreadCompletion(.failure(.invalidURL))
            return
        }
        
        print("---> HTTP Request: \(endpoint.method.httpMethod) \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.httpMethod
        request.httpBody = endpoint.body
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            logResponse(response, originalURL: url)
            
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
    
    private static func logResponse(_ response: URLResponse?, originalURL: URL) {
        guard let response = response else {
            print("<--- HTTP Request failed: \(originalURL)")
            return
        }
        
        let statusCode = ((response as? HTTPURLResponse)?.statusCode).map(String.init) ?? "unknown status code"
        let contentLength = response.expectedContentLength
        let url = response.url?.absoluteString ?? "unknown URL"
        print("<--- HTTP Response: \(url)\n\tStatus code: \(statusCode)\n\tContent Length: \(contentLength)")
    }
}
