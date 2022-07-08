//
//  SearchViewModel.swift
//  YoutubeTest
//
//  Created by Shamkhal Guliyev on 08.07.22.
//

import Foundation

class SearchViewModel {
    var searchItems = [Search]()
    var searchItemtCallback: (()->())?
    var errorCallback: ((String)->())?
    
    func getVideos(text: String) {
        SearchManager.shared.getSearchQuery(text: text) { [weak self] result in
            self?.handleResult(result: result)
        } failure: { [weak self] errorMessage in
            self?.errorCallback?(errorMessage)
        }
    }
    
    func handleResult(result: NSArray) {
        for resultItem in result {
            let videoRenderer = (resultItem as! NSDictionary)["videoRenderer"]
            if ((videoRenderer) != nil) {
                let videoId = (videoRenderer as! NSDictionary)["videoId"]
                let thumbnail = (videoRenderer as! NSDictionary)["thumbnail"]
                let thumbnails = (thumbnail as! NSDictionary)["thumbnails"] as! NSArray
                let bigThumb = thumbnails.lastObject
                let bigThumbUrl = (bigThumb as! NSDictionary)["url"]
                let videoUrl = String(format: "https://www.youtube.com/embed/%@", videoId as! CVarArg);
                let searchItem = Search(thumbUrl: bigThumbUrl as? String, videoUrl: videoUrl)
                searchItems.append(searchItem)
            }
        }
        searchItemtCallback?()
    }
}
