//
//  BookmarksViewController.swift
//  Apple News
//
//  Created by Akhil on 06/10/20.
//

import UIKit
import RealmSwift

class BookmarksViewController: UIViewController {

    @IBOutlet weak var bookmarkTableView: UITableView!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var lblBookmarkEmptyMessage: UILabel!
    @IBOutlet weak var btnUserInterfaceStyleConfiguration: UIBarButtonItem!
    
    var urlLinkModel: URLLinkModel?
    let dataHandler  = DataHandler()
    var realmObject : Results<NewsDBModel>?
    let dateFormatter = DateFormatterUtility()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(Thread.current)
        initializeUIComponents()
        checkUserInterfaceStyleAndSetButtonImage()
    }

    @IBAction func btnDeleteBookmark(_ sender: Any) {
        if (realmObject?.count == 0){
            debugPrint("Realm Object Count : ", realmObject?.count ?? "Count not found.!")
            btnCancel.isEnabled = false
            bookmarkTableView.isEditing = false
        }
        else{
            bookmarkTableView.isEditing = true
            btnCancel.isEnabled = true
        }
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


    @IBAction func btnCancelAction(_ sender: Any) {
        bookmarkTableView.isEditing = false
        btnCancel.isEnabled = false
    }
    
    private func initializeUIComponents(){
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        self.tabBarController?.delegate = self
        btnCancel.isEnabled = false
        bookmarkTableView.register(UINib(nibName: "DesignLayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "DesignLayoutTableViewCell")
        realmObject =  dataHandler.fetchDataFromRealm()
        reloadTableView()
    }
}

extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmObject?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let view = bookmarkTableView.dequeueReusableCell(withIdentifier: "DesignLayoutTableViewCell") as? DesignLayoutTableViewCell else {
            return UITableViewCell()
        }
        
        if let realmObject_ = realmObject{
            view.setAuthorAndTitle(author: realmObject_[indexPath.row].author, title: realmObject_[indexPath.row].title )
            view.setImage(ImageUrl: realmObject_[indexPath.row].urlOfImage ?? "")
            view.setCategoryAndDate(category: realmObject_[indexPath.row].category ?? "", date: dateFormatter.dateFormatter(date: realmObject_[indexPath.row].publishedAt ?? "" ) )
        }

        return view

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let webViewController =  self.storyboard?.instantiateViewController(identifier: "WebViewController") as? WebViewController{

            if let realmObject_ = realmObject{
                
                urlLinkModel = URLLinkModel()
                urlLinkModel?.url = realmObject_[indexPath.row].urlForWebView
              
                webViewController.urlLinkModel =  urlLinkModel
                
            }
            
             navigationController?.pushViewController(webViewController, animated: true)
        }

    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (trailingAction, view, completionHandler) in

            completionHandler(true)
            
            if let realmObject_ = self.realmObject{
                self.dataHandler.deleteFromRealm(newsDBModel: realmObject_[indexPath.row])
            }
            
            self.reloadTableView()
            })
 
        deleteAction.backgroundColor = UIColor.systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }

    func reloadTableView(){
        
        realmObject =  dataHandler.fetchDataFromRealm()
        
        if(realmObject?.count == 0){
            bookmarkTableView.isHidden = true
            lblBookmarkEmptyMessage.isHidden = false
            btnCancel.isEnabled = false
        }
        else{
            bookmarkTableView.isHidden = false
            lblBookmarkEmptyMessage.isHidden = true
        }
        bookmarkTableView.reloadData()
    }
        
    }

extension BookmarksViewController: UITabBarControllerDelegate{
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
       
        if(self.tabBarController?.selectedIndex == 1){
            bookmarkTableView.isEditing = false
            reloadTableView()

        }
            
    }
}


