//
//  FiltersViewController.swift
//  Apple News
//
//  Created by Akhil on 07/10/20.
//

import UIKit

protocol UpdateLanguageDelegate{
    func updateLanguage(language: String, row: Int)
}

protocol UpdateCountryDelegate {
    func updateCountry(country:String, row : Int)
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var languageCollectionView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let dataHandler =  DataHandler()
    let languages = ["Arabic","Dutch","English","Espanish","French","Hebrew","Italian","Norwegian", "Russian","Serbian", "ZH"]
    let countries = ["Global", "US","India","Canada","Australia", "China","France","Thailand","German","Russia"]
    
    var countryRow:Int?
    var languageRow:Int?
    
    var languageDelegate: UpdateLanguageDelegate?
    var countryDelegate: UpdateCountryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       intializeUIComponents()
    }
    
    func intializeUIComponents(){
        languageCollectionView.delegate = self
        languageCollectionView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        languageCollectionView.register(UINib(nibName: "LanguageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LanguageCollectionViewCell")
        if let countryRow_ = countryRow{
            pickerView.selectRow(countryRow_, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func btnDoneDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let view = languageCollectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCollectionViewCell", for: indexPath) as? LanguageCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        if let row_ = languageRow{
            if(indexPath.row == row_){
                view.backgroundColor = .systemPurple
            }
        }
        view.setLabelText(text: languages[indexPath.row])
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let row_ = languageRow{
            languageCollectionView.cellForItem(at: [0, row_])?.backgroundColor = .lightGray
            debugPrint("row_ ", [row_, languages.count])
        }
        languageCollectionView.cellForItem(at: indexPath)?.backgroundColor = .systemPurple
        debugPrint("check", indexPath)
        languageDelegate?.updateLanguage(language: languages[indexPath.row], row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        languageCollectionView.cellForItem(at: indexPath)?.backgroundColor = .lightGray
    }
}

extension FiltersViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryDelegate?.updateCountry(country: countries[row], row: row)
    }
}
