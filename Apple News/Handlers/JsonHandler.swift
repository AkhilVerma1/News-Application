//
//  JsonHandler.swift
//  Apple News
//
//  Created by Akhil on 04/10/20.
//

import Foundation

protocol APIDataSource{
    func apiData(articles: Articles)
}

protocol SearchAPIDataSource{
    func searchAPIData(articles: Articles)
}

class JsonHandler{
    var dataSource: APIDataSource?
    var delegate: SearchAPIDataSource?
    
    func fetchDataFromAPIByParameters(language: String, country: String, pageSize: Int, pageNumber :Int ){
      //  debugPrint("json", Thread.current)
        let apiKey = "3489b0bc081d4327ac6fc158613a9ff5"
        let apiLink = "https://newsapi.org/v2/everything?q=\(country)&language=\(language)&apiKey=\(apiKey)&pagesize=\(pageSize)&page=\(pageNumber)"
        debugPrint(apiLink)
        if let url_ = URL(string : apiLink){
            let url = URLSession.shared.dataTask(with: url_){(data, response, error) in
            do{
                if let data_ = data {
                    let articles = try JSONDecoder().decode(Articles.self, from: data_)
                    self.dataSource?.apiData(articles: articles)
                }
            }
            catch{
                debugPrint("Something went wrong while parsing the data.! \(error)")
            }
        }
        url.resume()
    
        }
    }
    
    func fetchDataFromAPIByKeyword(keyword: String){
        let page = 1
        let size = 40
        let apiKey = "3489b0bc081d4327ac6fc158613a9ff5"
        let apiLink = "https://newsapi.org/v2/everything?q=\(keyword)&apiKey=\(apiKey)&pagesize=\(size)&page=\(page)"
        debugPrint(apiLink)
        if let url_ = URL(string : apiLink){
            let url = URLSession.shared.dataTask(with: url_){(data, response, error) in
            do{
                if let data_ = data {
                    let articles = try JSONDecoder().decode(Articles.self, from: data_)
                    self.delegate?.searchAPIData(articles: articles)
                }
            }
            catch{
                debugPrint("Something went wrong while parsing the data.! \(error)")
            }
        }
        url.resume()
    
        }
    }
}
