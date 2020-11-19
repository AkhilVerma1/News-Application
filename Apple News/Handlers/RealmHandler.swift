//
//  RealmHandler.swift
//  Apple News
//
//  Created by Akhil on 06/10/20.
//

import Foundation
import RealmSwift

class RealmHandler{
  
    var realm : Realm?
    
    init(){
        do{
            try realm = Realm()
        }
        catch{
            debugPrint("Something went wrong while creating an Object\(error)")
        }
        

        debugPrint(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    public func saveToRealm(newsDBModel: NewsDBModel){
        do{
            try realm?.write{
                realm?.add(newsDBModel,update: .all)
            }
        }
        catch{
            
        }
        
        
    }
    
    func retrieveObjectsFromRealm() -> Results<NewsDBModel>?{
        
        let realmObject = realm?.objects(NewsDBModel.self)
        return realmObject
    }
    
    func deleteFromRealm(newsDBModel: NewsDBModel){
        
        do{
            try realm?.write{
                realm?.delete(newsDBModel)
            }
            
        }
        catch{
            
        }
    }
    
}
