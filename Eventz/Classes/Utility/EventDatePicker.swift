//
//  EventDatePicker.swift
//  Eventz
//
//  Created by Naheed Shamim on 30/08/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import UIKit

class EventDatePicker: UIDatePicker {

    var textField : UITextField!    
    
    init(dateTextField:UITextField) {
        
        super.init(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:150))

        textField = dateTextField
        
        if !(dateTextField.text?.isEmpty)!{
        self.date = (dateTextField.text?.toDate())!
        }
        
        self.datePickerMode = UIDatePickerMode.date
        self.addTarget(self, action: #selector(updateTextField), for: UIControlEvents.valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTextField()
    {
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = Constants.kDateFormat//"dd-MM-yyyy"
        
        textField.text = dateFormat.string(from: date)        
    }
}

extension String {
    func toDate()-> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.kDateFormat
        return formatter.date(from: self)!
    }
}
