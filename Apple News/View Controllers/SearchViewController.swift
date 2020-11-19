//
//  SearchViewController.swift
//  Apple News
//
//  Created by Akhil on 06/10/20.
//

import UIKit

protocol NavigationControllerDataSource{
    func navigate(urlLinkModel : URLLinkModel)
}

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblErroMessage: UILabel!
    
    var articles: Articles?
    var dataSource:NavigationControllerDataSource?
    var dateFormatter = DateFormatterUtility()
    let dataHandler =  DataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeUI()
        initializeObjects()
    }
    
    @IBAction func btnCancelDismissController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func intializeUI(){
        searchBar.layer.borderWidth = 10
        searchBar.layer.borderColor = UIColor.systemBackground.cgColor
        lblErroMessage.isHidden = true
    }
    
    func initializeObjects(){
        dataHandler.searchViewDataSource = self
        searchBar.delegate =  self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "DesignLayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "DesignLayoutTableViewCell")
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.contains(" ")){
            var searchText_ = ""
            for text in searchText.split(separator: " "){
                searchText_ = searchText_ + text
            }
            debugPrint("SEARCH TEXT : \(searchText_)")
            dataHandler.fetchDataFromAPIByKeyword(keyword: searchText_)
        }
        else{
            dataHandler.fetchDataFromAPIByKeyword(keyword: searchText)
        }
      //  dataHandler.fetchDataFromAPIByKeyword(keyword: searchText)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles_ = self.articles?.articles else {
            return 0
        }
        return (articles_.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let view = searchTableView.dequeueReusableCell(withIdentifier: "DesignLayoutTableViewCell") as? DesignLayoutTableViewCell else{
                return UITableViewCell()
            }

        if (indexPath.row  < articles?.articles?.count ?? 0 ){
            if let article_ = self.articles?.articles, let author_ =  article_[indexPath.row].author, let title_ = article_[indexPath.row].title,
               let imageURL = article_[indexPath.row].urlToImage, let category_ = article_[indexPath.row].source?.name, let date_ = article_[indexPath.row].publishedAt{
                view.setAuthorAndTitle(author: author_, title: title_ )
                view.setImage(ImageUrl: imageURL)
                view.setCategoryAndDate(category: category_, date: dateFormatter.dateFormatter(date: date_)) //handle
            }
        }
            return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if let articles_ = articles?.articles{
            var urlLinkModel = URLLinkModel()
            urlLinkModel.url = articles_[indexPath.row].url
            dataSource?.navigate(urlLinkModel: urlLinkModel)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func reloadTableView(){
        DispatchQueue.main.async {
            if(self.articles?.articles?.count == 0){
                self.lblErroMessage.isHidden = false
                self.searchTableView.isHidden = true
            }
            else{
                self.lblErroMessage.isHidden = true
                self.searchTableView.isHidden = false
            }
            self.searchTableView.reloadData()
        }
    }
}

extension SearchViewController: updateUIComponentsOfSearchTableView{
    func didGetNewsData(articles: Articles) {
        self.articles = articles
        reloadTableView()
    }
  
}
