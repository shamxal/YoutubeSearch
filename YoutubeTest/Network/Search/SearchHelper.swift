//
//  SearchHelper.swift
//  YoutubeTest
//
//  Created by Shamkhal Guliyev on 08.07.22.
//

import Foundation

enum SearchEndpoint: String {
    case searchQuery = "search_query"
}

enum SearchHelper {
    case searchQuery
    
    var path: String {
        switch self {
        case .searchQuery:
            return NetworkHelper.shared.requestUrl(url: SearchEndpoint.searchQuery.rawValue)
        }
    }
}

