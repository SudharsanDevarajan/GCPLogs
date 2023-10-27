//
//  File.swift
//  
//
//  Created by htcuser on 26/10/23.
//

import Foundation


class GCPNetworking{
    
    static let shared = GCPNetworking()
    
    private init() {} // Private initializer to prevent external instantiation
    
    struct HttpHeader {
        static var contentTypeKey = "Content-Type"
        static var contentTypeValue = "application/json"
        static var auth = "Authorization"
        static let bearer = "Bearer"
    }
    
    struct GCPError{
        static let invalidURL = "GCPLogs - Invalid URL"
        static let  invalidRequest = "GCPLogs - Invalid Request"
        static let  invalidStatusCode = "GCPLogs - Invalid Status Code"
        static let  invalidResponse = "GCPLogs - Invalid Response"
        static let parsingError = "GCPLogs - Error in Parsing response"
        static let  failedToLogging = "GCPLogs - Failed to Login"
    }

    struct HttpMethod{
        static let post = "POST"
    }
    
    func logData(with url: String,token: String, params: [String: Any]) {
        
        guard let request = createRequest(url, token, params) else{ return }
        // Create a data task with the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check if a response was received
            guard let httpResponse = response as? HTTPURLResponse else {
                print(GCPError.invalidResponse)
                return
            }
            
            // Check the status code in the response
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        print("GCPLogs - success: \(json)")
                    } catch {
                        print("\(GCPError.parsingError) \(error)")
                    }
                } else {
                    print(GCPError.failedToLogging)
                }
            } else {
                print("\(GCPError.invalidStatusCode) \(httpResponse.statusCode)")
            }
        }.resume()
        
    }
    
    private func createRequest(_ gcpURL: String,_ gcpToken: String, _ logData: [String: Any]) -> URLRequest?{
        
        guard let url = URL(string: gcpURL) else {
            print(GCPError.invalidURL)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue(HttpHeader.contentTypeValue, forHTTPHeaderField: HttpHeader.contentTypeKey)
        request.setValue("\(HttpHeader.bearer) \(gcpToken)", forHTTPHeaderField: HttpHeader.auth)
        request.httpMethod = HttpMethod.post
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: logData, options: .prettyPrinted)
        }catch{
            print(GCPError.invalidRequest)
        }
        return request
    }
}
