//
//  RestApi.swift
//  Desafio Mobfiq
//
//  Created by Pro on 05/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class RestApiClient {
    
    var endpoint : String?
    
    convenience init(endpoint: String) {
        self.init()
        self.endpoint = endpoint
    }
    
    func post(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "POST", completion: completion)
    }
    
    func put(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "PUT", completion: completion)
    }
    
    func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ sucess: Bool, _ object: AnyObject?) -> ()) {
        if let endpoint = self.endpoint {
            request.url = URL(string: endpoint)
        }
        
        request.httpMethod = method
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let body = String(data: data, encoding: .utf8)!
                if let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode {
                    completion(true, body as AnyObject)
                } else {
                    completion(false, body as AnyObject)
                }
            }
        }
        task.resume()
    }
}
