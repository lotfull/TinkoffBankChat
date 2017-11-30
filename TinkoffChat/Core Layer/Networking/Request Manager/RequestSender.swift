//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

struct RequestConfig<T> {
    let request: IRequest
    let parser: AnyParser<T>
}

enum Result<T> {
    case success(T)
    case error(String)
}

class RequestSender: IRequestSender {
    private let session = URLSession.shared
    
    func send<T>(config: RequestConfig<T>, completion: @escaping (Result<T>) -> Void) {
        let urlRequest = config.request.urlRequest
        session.dataTask(with: urlRequest) { (data, _, error) in
            switch error {
            case .some(let error):
                completion(Result.error(error.localizedDescription))
            case .none:
                guard let data = data, let parsedModel = config.parser.parse(data: data) else {
                    completion(Result.error("Received data couldn't be parsed"))
                    return
                }
                completion(Result.success(parsedModel))
            }
        }.resume()
    }
}
