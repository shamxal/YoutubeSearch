//
//  SearchManager.swift
//  YoutubeTest
//
//  Created by Shamkhal Guliyev on 08.07.22.
//

import Foundation

protocol SearchManagerProtocol {
    func getSearchQuery(text: String, completion: @escaping(NSArray)->(), failure: @escaping(String)->())
}

class SearchManager: SearchManagerProtocol {
    static let shared = SearchManager()
    
    private let userAgent: String = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15"
    
    func getSearchQuery(text: String, completion: @escaping (NSArray) -> (), failure: @escaping (String) -> ()) {
        fetchData(url: SearchHelper.searchQuery.path + "=\(text)") { result in
            completion(result)
        } failure: { error in
            failure(error)
        }
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            guard let result = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length)) else {
                return [] // pattern does not match the string
            }
            return (1 ..< result.numberOfRanges).map {
                nsString.substring(with: result.range(at: $0))
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchData(url: String, completion: @escaping (NSArray) -> (), failure: @escaping(String)->()) -> Void {
        let url = url.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.httpMethod = HttpMethod.get.rawValue
            request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
            
            let session = URLSession.init(configuration: URLSessionConfiguration.default)
            session.dataTask(with: request) { [weak self] data, response, error in
                if let data = data {
                   let contents = String(data: data, encoding: .utf8)
                    
                    let pattern = "ytInitialData[^{]*(.*?);*</script>"
                    if let regex = self?.matchesForRegexInText(regex: pattern, text: contents!) {
                        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: Data(regex[0].utf8), options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        let content1 = jsonResult["contents"] as! NSDictionary;
                        let twoColumnSearchResultsRenderer = content1["twoColumnSearchResultsRenderer"] as! NSDictionary;
                        let primaryContents = twoColumnSearchResultsRenderer["primaryContents"] as! NSDictionary;
                        let sectionListRenderer = primaryContents["sectionListRenderer"] as! NSDictionary;
                        let contents2 = sectionListRenderer["contents"] as! NSArray;
                        let itemSectionRenderer = contents2[0] as! NSDictionary;
                        let contents3 = itemSectionRenderer["itemSectionRenderer"] as! NSDictionary;
                        let contentsFinal = contents3["contents"] as! NSArray
                        completion(contentsFinal)
                    } else {
                        failure("Error happened")
                    }
                }
            }.resume()
        } else {
            failure("Error happened")
        }
    }
}

