//
//  PixabayAPIRequest.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol PixabayImagesRequest: IRequest {
    typealias QueryParameters = [String: String]
    
    var apiKey: String { get }
    var urlRequest: URLRequest { get }
    var queryParameters: QueryParameters { get }
}

extension PixabayImagesRequest {
    var apiKey: String {
        return "7217317-93c7464b4fc13908868d6e7e9"
    }
    
    var baseURL: String {
        return "https://pixabay.com/api?"
    }
    
    var urlRequest: URLRequest {
        let queryString = prepareQueryStringFrom(queryParameters)
        let urlString = baseURL + queryString
        guard let url = URL(string: urlString) else {
            preconditionFailure("\(urlString) couldn't be parsed to URL")
        }
        return URLRequest(url: url)
    }
    
    private func prepareQueryStringFrom(_ queryParameters: QueryParameters) -> String {
        return queryParameters.flatMap({
            "\($0.key)=\($0.value)" }).joined(separator: "&")
    }
}

class PixabayEditorChoiceImagesRequest: PixabayImagesRequest {
    var queryParameters: [String: String] {
        return ["key": apiKey,
                "imageType": "photo",
                "editors_choice": "true",
                "per_page": "100",
        ]
    }
}

class PixabayCarImagesRequest: PixabayImagesRequest {
    var queryParameters: [String: String] {
        return ["key": apiKey,
                "q": "car",
                "imageType": "photo",
                "per_page": "100",
        ]
    }
}
