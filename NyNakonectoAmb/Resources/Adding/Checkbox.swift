//
//  Checkbox.swift
//  NyNakonectoAmb
//
//  Created by G412 on 04.10.2022.
//

import UIKit

class Checkbox: UIView {
    
    var isChecked = false
    
    var checkmarkColor = UIColor(red: 0.942, green: 0.104, blue: 0.266, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.596, green: 0.596, blue: 0.596, alpha: 1).cgColor
        layer.cornerRadius = 8
        backgroundColor = .systemBackground
        
        let checkLabel = UILabel()
        checkLabel.text = "Сохранить фото"
        checkLabel.textColor = UIColor(red: 0.596, green: 0.596, blue: 0.596, alpha: 1)
        checkLabel.font = UIFont(name: "Roboto-Regular", size: 14)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    func toggle(){
        
        self.isChecked = !isChecked
        
        if self.isChecked{
            layer.borderColor = UIColor(red: 0.942, green: 0.104, blue: 0.266, alpha: 1).cgColor
            backgroundColor = UIColor(red: 0.942, green: 0.104, blue: 0.266, alpha: 1)
        }
        else {
            layer.borderColor = UIColor(red: 0.596, green: 0.596, blue: 0.596, alpha: 1).cgColor
            backgroundColor = .systemBackground
        }
    }

}
