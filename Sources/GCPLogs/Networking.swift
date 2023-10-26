//
//  File.swift
//  
//
//  Created by htcuser on 26/10/23.
//

import Foundation


class Networking{
    
    static let shared = Networking()
    
    private init(){}
    
    @available(iOS 13.0.0, *)
    func logData(_ url: String,_ body: [String:Any],_ token: String) async throws{
        do{
            let request = try createRequest(url, token, body)
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data)
            print("GCPLogs success \(json)")
        }catch NetworkingError.invalidURL{
            throw NetworkingError.invalidURL
        }catch NetworkingError.invalidRequest{
            throw NetworkingError.invalidRequest
        }catch{
            throw NetworkingError.gcpLoginFailed
        }
    }
    
    private func createRequest(_ urlString: String,_ userToken: String, _ body: [String: Any]) throws -> URLRequest{
        
        guard let url = URL(string: urlString) else {
            throw NetworkingError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(HttpHeader.contentTypeValue, forHTTPHeaderField: HttpHeader.contentTypeKey)
        request.setValue("\(HttpHeader.bearer) \(userToken)", forHTTPHeaderField: HttpHeader.auth)
        request.httpMethod = HttpMethod.post
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }catch{
            throw NetworkingError.invalidRequest
        }
        
        return request
    }
}

struct HttpHeader{
    static let contentTypeKey = "Content-Type"
    static let contentTypeValue = "application/json"
    static let auth = "Authorization"
    static let bearer = "Bearer"
}


struct HttpMethod{
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
}


enum NetworkingError: Error{
    case invalidURL
    case invalidRequest
    case gcpLoginFailed
}
