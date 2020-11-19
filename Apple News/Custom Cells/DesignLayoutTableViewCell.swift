//
//  DesignLayoutTableViewCell.swift
//  Apple News
//
//  Created by Akhil on 04/10/20.
//

import UIKit
import ImageLoader

class DesignLayoutTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setAuthorAndTitle(author:String?, title:String?){
        lblAuthor.text = author ?? ""
        lblTitle.text = title ?? ""
    }

    func setImage(ImageUrl imageLink: String){
        if imageLink != ""{
            imageViewer.load.request(with: imageLink)
        }
        else{
            imageViewer.image = UIImage(named: "bob")
        }
    }

    func setCategoryAndDate(category:String, date:String){
        lblCategory.text = category
        lblDate.text = date + " days ago"
    }
   
    
}
