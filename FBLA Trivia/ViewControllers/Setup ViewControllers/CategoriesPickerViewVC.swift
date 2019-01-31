//
//  CategoriesPickerViewVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/30/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit

class CategoriesPickerViewVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPicker()
    }
    
    //Properties
    @IBOutlet weak var pickerView: UIPickerView!
    
    let pickerDataSize = 100_000
    var finnishSelection = false
    var pickerDataSource = GameSession.shared.modesNotComplete
    
    
    //Actions
    func setupPicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(pickerDataSize/2, inComponent: 0, animated: false)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerDataSource[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSize
    }
    
    private func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        //Resets the picker to the middle of the long list
        let position = pickerDataSize/2 + row
        pickerView.selectRow(position, inComponent: 0, animated: false)
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickerView.isUserInteractionEnabled = false
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = "1"
        pickerLabel.backgroundColor = .white
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 40) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        
        return pickerLabel
    }
    
}
