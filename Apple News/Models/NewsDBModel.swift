//
//  NewsDBModel.swift
//  Apple News
//
//  Created by Akhil on 06/10/20.
//

import Foundation
import RealmSwift

class NewsDBModel: Object{
    @objc dynamic var author : String?
    @objc dynamic var title : String?
    @objc dynamic var urlOfImage : String?
    @objc dynamic var urlForWebView : String?
    @objc dynamic var category : String?
    @objc dynamic var publishedAt : String?
    override class func primaryKey() -> String? {
          return "urlForWebView"
      }
}
