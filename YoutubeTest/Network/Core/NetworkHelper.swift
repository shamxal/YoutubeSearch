//
//  NetworkHelper.swift
//  YoutubeTest
//
//  Created by Shamkhal Guliyev on 08.07.22.
//

import Foundation

enum Api: String {
    case baseURL = "https://www.youtube.com/results?"
}

enum HttpMethod: String {
    case get = "GET"
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    func requestUrl(url: String) -> String {
        Api.baseURL.rawValue + url
    }
}
