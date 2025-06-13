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


class APIService {
    
    func sendRequest<T: Decodable>(url: URL, method: APIMethod, body: Data? = nil, queries: [String: String]? = nil) async -> Result<T, Error> {
        // Compose request via url components
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        //  Make sure url is valid
        guard let url = urlComponents.url else {
            return .failure(URLError(.badURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/vnd.github+json"
        ]
        
//        request.allHTTPHeaderFields = [
//            "Content-Type" : "application/vnd.github+json",
//            "Authentication": "Bearer " + "YOUR_GITHUB_TOKEN" //TODO: Replace token here
//        ]
//        request.httpBody = try body()?
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // For response checking only
            data.prettyPrint()
            
            /// Decode the JSON response into the PostResponse struct.
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            
            return .success(decodedResponse)
        } catch {
            print("Error info: \(error)")
            return .failure(error)
        }
    
    }
    
 
}
