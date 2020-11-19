//
//  HomeViewController.swift
//  Apple News
//
//  Created by Akhil on 03/10/20.
//

import UIKit
import ImageLoader // @

//scroll to position

class HomeViewController: UIViewController {
    @IBOutlet weak var newsDisplayTableView: UITableView!
    @IBOutlet weak var lblNoDataFoundMessage: UILabel!
    @IBOutlet weak var btnUserInterfaceStyleConfiguration: UIBarButtonItem!
    var indicator = UIActivityIndicatorView()
    
    var dateFormatter = DateFormatterUtility()
    var urlLinkModel: URLLinkModel?
    let dataHandler = DataHandler()
    
    var pageSize = 20
    var pageNumber = 1
    var language = "en"
    var country = "general"
    var isRefreshClicked = 0
    private var countryRow = 0
    private var languageRow = 2
    let totalPages = 5
    var articlesCountCheck = 0
    
    var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(Thread.current)
        intializeUIComponents()
        fetchDataFromAPI()
        checkUserInterfaceStyleAndSetButtonImage()
    }
    
    @IBAction func btnRefreshTableView(_ sender: Any) {
        language = "en"
        country = "general"
        articles = []
        countryRow = 0
        languageRow = 2
        isRefreshClicked = 1
        fetchDataFromAPI()
    }
    
    
    @IBAction func userInterfaceStyleConfiguration(_ sender: Any) {
        
        let configuration = overrideUserInterfaceStyle
        switch configuration {
        case .dark:
            btnUserInterfaceStyleConfiguration.image = UIImage(systemName: "sun.min.fill")
            overrideUserInterfaceStyle = .light
            break
        case .light:
            btnUserInterfaceStyleConfiguration.image = UIImage(systemName: "moon.fill")
            overrideUserInterfaceStyle = .dark
            break
        case .unspecified:
            btnUserInterfaceStyleConfiguration.image = UIImage(systemName: "sun.min.fill")
            overrideUserInterfaceStyle = .light
            break
        @unknown default:
            break
        }
        checkUserInterfaceStyleAndSetButtonImage()
    }
    
    func checkUserInterfaceStyleAndSetButtonImage(){
        let configuration = overrideUserInterfaceStyle
        switch configuration {
        case .dark:
            btnUserInterfaceStyleConfiguration.image = UIImage(systemName: "sun.min.fill")
            break
        case .light:
            btnUserInterfaceStyleConfiguration.image = UIImage(systemName: "moon.fill")
            break
        case .unspecified:
            btnUserInterfaceStyleConfiguration.image = UIImage(systemName: "sun.min.fill")
            break
            
        default:
            break
        }
    }
    
    @IBAction func btnSearch(_ sender: Any) {
    
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        
        if let searchViewController_ = searchViewController{
            searchViewController_.dataSource = self
            navigationController?.present(searchViewController_, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnFilterAPIData(_ sender: Any) {
        if let filtersViewController =  self.storyboard?.instantiateViewController(identifier: "FiltersViewController") as? FiltersViewController{
            filtersViewController.languageDelegate = self
            filtersViewController.countryDelegate = self
            filtersViewController.countryRow = countryRow
            filtersViewController.languageRow = languageRow
            navigationController?.present(filtersViewController, animated: true, completion: nil)
        }
    }
 
    private func fetchDataFromAPI(){
        dataHandler.fetchDataFromAPI(language: language, country: country, pageSize: pageSize, pageNumber: pageNumber)
    }
    
    private func intializeUIComponents(){
    
        newsDisplayTableView.delegate = self
        newsDisplayTableView.dataSource = self
        dataHandler.delegate = self
        newsDisplayTableView.register(UINib(nibName: "DesignLayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "DesignLayoutTableViewCell")
        newsDisplayTableView.register(UINib(nibName: "BigDesignLayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "BigDesignLayoutTableViewCell")
      //  updateUI()
        lblNoDataFoundMessage.isHidden = true
        activityIndicator()
       // activityIndicator.startAnimating()
    }
    
    func updateUI(){
        DispatchQueue.main.async {[weak self] in
            if(self?.articles.count == 0){
                self?.lblNoDataFoundMessage.isHidden = false
                self?.newsDisplayTableView.isHidden = true
            }
            else{
                self?.lblNoDataFoundMessage.isHidden = true
                self?.newsDisplayTableView.isHidden = false
            }
            
            self?.indicator.stopAnimating()
            self?.indicator.removeFromSuperview()
            self?.newsDisplayTableView.reloadData()
            
            if(self?.articles.count != 0 && self?.isRefreshClicked == 1){
                debugPrint(self?.isRefreshClicked as Any)
                self?.newsDisplayTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                self?.isRefreshClicked = 0
            }
  
        }
    }
    
    private  func activityIndicator() {
           indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
           indicator.style = UIActivityIndicatorView.Style.large
           indicator.color = .cyan
           indicator.center = self.view.center
           self.view.addSubview(indicator)
           indicator.startAnimating()
       }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0 || indexPath.row % 5 == 0){
                guard let view = newsDisplayTableView.dequeueReusableCell(withIdentifier: "BigDesignLayoutTableViewCell") as? BigDesignLayoutTableViewCell else{
                    return UITableViewCell()
                }
            
                if(indexPath.row <= articles.count){
                    if let author_ = articles[indexPath.row].author, let title_ = articles[indexPath.row].title,
                       let imageURL = articles[indexPath.row].urlToImage, let category_ = articles[indexPath.row].source?.name, let date_ = articles[indexPath.row].publishedAt{
                        
                        view.setAuthorAndTitle(author: author_, title: title_ )
                        view.setImage(ImageUrl: imageURL)
                        view.setCategoryAndDate(category: category_, date:  dateFormatter.dateFormatter(date: date_))
                    }
                }
                return view
            }
            else{
                guard let view = newsDisplayTableView.dequeueReusableCell(withIdentifier: "DesignLayoutTableViewCell") as? DesignLayoutTableViewCell else{
                    return UITableViewCell()
                }
                if(indexPath.row < articles.count){
                    if let author_ = articles[indexPath.row].author, let title_ = articles[indexPath.row].title,
                       let imageURL = articles[indexPath.row].urlToImage, let category_ = articles[indexPath.row].source?.name, let date_ = articles[indexPath.row].publishedAt{
                        
                        view.setAuthorAndTitle(author: author_, title: title_ )
                        view.setImage(ImageUrl: imageURL)
                        view.setCategoryAndDate(category: category_, date:  dateFormatter.dateFormatter(date: date_)) //handle
                    }
                }
                return view
            }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let webViewController =  self.storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController{

            urlLinkModel = URLLinkModel()
            urlLinkModel?.url = articles[indexPath.row].url
            webViewController.urlLinkModel =  urlLinkModel
            
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trailingAction = UIContextualAction(style: .normal, title: "Bookmark", handler: { [self] (trailingAction, view, completionHandler) in
            completionHandler(true)
            
            let newsDBModel = NewsDBModel()
            newsDBModel.author = articles[indexPath.row].author
            newsDBModel.title = articles[indexPath.row].title
            newsDBModel.category = articles[indexPath.row].source?.name
            newsDBModel.publishedAt = articles[indexPath.row].publishedAt
            newsDBModel.urlOfImage = articles[indexPath.row].urlToImage
            newsDBModel.urlForWebView = articles[indexPath.row].url
            saveToBookmark(newsDBModel: newsDBModel)
            })
        trailingAction.backgroundColor = UIColor.darkGray
            let configuration = UISwipeActionsConfiguration(actions: [trailingAction])
            return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareOption = UIContextualAction(style: .normal, title: "Share", handler: {(trailingAction, view, completionHandler) in
            completionHandler(true)
            })
            shareOption.backgroundColor = UIColor.systemIndigo
            let configuration = UISwipeActionsConfiguration(actions: [shareOption])
            return configuration
    }

    
    private func saveToBookmark(newsDBModel: NewsDBModel){
        dataHandler.saveToRealm(newsDBModel: newsDBModel)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(indexPath.row == articles.count - 2 && pageNumber <= totalPages && articles.count <= 100){
            articlesCountCheck = articles.count
            pageNumber += 1
            dataHandler.fetchDataFromAPI(language: language, country: country, pageSize: pageSize, pageNumber: pageNumber)
        }
    }
}

extension HomeViewController: updateUIComponentsDelegate{
    func didGetNewsData(articles: Articles) {
        if let article = articles.articles{
            self.articles.append(contentsOf: article)
        }
        updateUI()
    }
}

extension HomeViewController: NavigationControllerDataSource{
    func navigate(urlLinkModel: URLLinkModel) {
        if let webViewController =  self.storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController{
            webViewController.urlLinkModel =  urlLinkModel
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}

extension HomeViewController: UpdateLanguageDelegate, UpdateCountryDelegate{
    func updateCountry(country: String, row: Int) {
        updateUI()
        articles = []
        pageNumber = 1
        countryRow = row
        if(country == "Global"){
            self.country = "general"
        }
        else{
            self.country = country.prefix(2).lowercased()
        }
        dataHandler.fetchDataFromAPI(language: self.language, country: self.country, pageSize: pageSize, pageNumber: pageNumber)
    }
    
    func updateLanguage(language: String, row: Int) {
        updateUI()
        articles = []
        pageNumber = 1
        languageRow = row
        self.language = language.prefix(2).lowercased()
        dataHandler.fetchDataFromAPI(language: self.language, country: self.country, pageSize: pageSize, pageNumber: pageNumber)
    }
 
}
