//
//  APIService.swift
//  GitHubCommunity
//
//  Created by Steffi on 6/13/25.
//
import Foundation

enum APIMethod: String {
    case get = "GET", post = "POST"
}

protocol APIServiceProtocol {
    var session: URLSession { get }
    func sendRequest<T: Decodable>(url: URL, method: APIMethod, body: Data?, queries: [String: String]?) async throws -> T
}

class APIService: APIServiceProtocol {
    var session: URLSession = .shared
    private let authToken: String?
    
    init(token: String? = nil) {
        self.authToken = token
    }
    
    func sendRequest<T: Decodable>(url: URL, method: APIMethod, body: Data? = nil, queries: [String: String]? = nil) async throws -> T {
        // Compose request via url components
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        //  Make sure url is valid
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await session.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(T.self, from: data)
    }
}
