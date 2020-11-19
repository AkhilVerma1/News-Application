//
//  WebViewController.swift
//  Apple News
//
//  Created by Akhil on 05/10/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    var urlLinkModel: URLLinkModel?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        intializeWebView()
       
    }
    
    private func intializeWebView(){
        
        if let link_ = urlLinkModel?.url, let url_ = URL(string: link_) {
            
            webView.load(URLRequest(url: url_))

        }
    }

}
