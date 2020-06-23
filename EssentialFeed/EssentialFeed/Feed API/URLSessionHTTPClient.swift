//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by panditpakhurde on 24/04/20.
//  Copyright © 2020 Quikr. All rights reserved.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    public func get(from url: URL, completion: @escaping(HTTPClient.Result)-> Void) {
        session.dataTask(with: url) { data,response,error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            }
            else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
    
}

