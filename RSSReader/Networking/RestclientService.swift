//
//  RestclientService.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//


import Foundation

class RestClientService {
    
    var urlBase: String
    var urlSession: URLSession = URLSession(configuration: .default)
    let scheme : HTTPScheme
    
    init(urlBase : String, scheme : HTTPScheme = .http) {
        self.urlBase = urlBase
        self.scheme = scheme
    }
    
    func dataRequest<T,S>(endpoint: String,
                        queryItems: [URLQueryItem]? = nil,
                        body : S? = nil,
                        method : HTTPMethod,
                        token: String? = nil,
                        returnType: T.Type,
                        completionHandler: @escaping (T) -> Void,
                        errorHandler: @escaping (ErrorData) -> Void) where T : Codable, S : Codable {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = self.urlBase
        urlComponents.path = endpoint
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            errorHandler(.badURLFormatError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        if let body = body,
           let data = try? JSONEncoder().encode(body) {
                request.httpBody = data
        }
        
        if let token = token {
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data else {
                    DispatchQueue.main.async {
                        errorHandler(.networkingError)
                        
                    }
                    return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            } catch {
                DispatchQueue.main.async {
                    errorHandler(.badFormatError)
                }
            }
            
        }
        dataTask.resume()
    }
    
    func dataRequest<T>(endpoint: String,
                        queryItems: [URLQueryItem]? = nil,
                        method : HTTPMethod,
                        token: String? = nil,
                        returnType: T.Type,
                        completionHandler: @escaping (T) -> Void,
                        errorHandler: @escaping (ErrorData) -> Void) where T : Codable {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = self.urlBase
        urlComponents.path = endpoint
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            errorHandler(.badURLFormatError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        if let token = token {
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data else {
                    DispatchQueue.main.async {
                        errorHandler(.networkingError)
                        
                    }
                    return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            } catch {
                DispatchQueue.main.async {
                    errorHandler(.badFormatError)
                }
            }
            
        }
        dataTask.resume()
    }
    
    func performTask(request : URLRequest) {
        
    }
}

enum ErrorData : Error {
    
    case networkingError
    case badRequestError
    case badFormatError
    case badURLFormatError
}

enum HTTPMethod : String{
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

enum HTTPScheme : String {
    case http = "http"
    case https = "https"
}
