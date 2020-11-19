//
//  DataHandler.swift
//  Apple News
//
//  Created by Akhil on 04/10/20.
//

import Foundation
import RealmSwift

protocol  updateUIComponentsDelegate {
    func didGetNewsData(articles: Articles)
}

protocol updateUIComponentsOfSearchTableView{
    func didGetNewsData(articles: Articles)
}

class DataHandler{

    let jsonHandler = JsonHandler()
    let realmHandler = RealmHandler()
    
    var delegate:updateUIComponentsDelegate?
    var searchViewDataSource: updateUIComponentsOfSearchTableView?
   
    init() {
        jsonHandler.dataSource = self
        jsonHandler.delegate = self
    }
    
    
    func fetchDataFromAPI(language: String, country: String, pageSize:Int, pageNumber: Int){
    
        jsonHandler.fetchDataFromAPIByParameters(language: language, country: country, pageSize: pageSize, pageNumber: pageNumber)
        
    }
    
    func fetchDataFromAPIByKeyword(keyword: String){
        
        jsonHandler.fetchDataFromAPIByKeyword(keyword: keyword)

    }
    
    func fetchDataFromRealm() -> Results<NewsDBModel>?{
        
        return realmHandler.retrieveObjectsFromRealm()
        
    }
    
    func saveToRealm(newsDBModel: NewsDBModel){
        
        realmHandler.saveToRealm(newsDBModel: newsDBModel)
        
    }
    
    func deleteFromRealm(newsDBModel: NewsDBModel){
        realmHandler.deleteFromRealm(newsDBModel: newsDBModel)
    }
    
    

}
extension DataHandler: APIDataSource, SearchAPIDataSource{
    
    func searchAPIData(articles: Articles) {
        
        searchViewDataSource?.didGetNewsData(articles: articles)
    }
    

    func apiData(articles: Articles) {

        delegate?.didGetNewsData(articles: articles)
    }
    
   
    
    
}
