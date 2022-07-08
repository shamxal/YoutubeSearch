//
//  Search.swift
//  YoutubeTest
//
//  Created by Shamkhal Guliyev on 08.07.22.
//

import Foundation

struct Search: Codable {
    var id: String = UUID().uuidString
    var thumbUrl: String?
    var videoUrl: String?
}
