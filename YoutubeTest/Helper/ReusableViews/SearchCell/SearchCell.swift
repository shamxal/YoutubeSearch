//
//  SearchCell.swift
//  YoutubeTest
//
//  Created by Shamkhal Guliyev on 08.07.22.
//

import UIKit
import WebKit

class SearchCell: UICollectionViewCell {
    @IBOutlet private weak var webView: WKWebView!
    
    func configure(data: String) {
        let url = URL(string: data)
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}
