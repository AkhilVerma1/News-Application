//
//  LanguageCollectionViewCell.swift
//  Apple News
//
//  Created by Akhil on 07/10/20.
//

import UIKit

class LanguageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblLanguage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .lightGray
    }

    func setLabelText(text: String){
        lblLanguage.text = text
    }
}
