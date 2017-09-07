//
//  Utility.swift
//  CloudKitSwift
//
//  Created by Naheed Shamim on 25/08/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import UIKit
import CloudKit

class Utility: NSObject {
    
    // Returns the DocDirectory path as an URL
    class func getImageURL(image: UIImage, imageName:String) -> URL
    {
        let imgURL = Utility.saveToDocDirectory(fileName: imageName, imageToSave: image)
        return imgURL as URL
    }
    
    // Saves the file into the Document Directory
    class func saveToDocDirectory(fileName:String, imageToSave:UIImage) -> NSURL
    {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
        print(paths)
        
        let imageData = UIImageJPEGRepresentation(imageToSave, 0.9)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        return NSURL.fileURL(withPath: paths) as NSURL
    }
    
    // Deletes the specified file from the Document Directory
    class func clearDocumentDirectory(filename:String)
    {
        let fileManager = FileManager.default
        
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(filename)
        
        if fileManager.fileExists(atPath: filePath){
            try! fileManager.removeItem(atPath: filePath)
        }else{
            print("Something wrong.")
        }
    }

    // MARK: - Date Utils
    class func showDatePicker(dateTextField:UITextField)
    {
        let datePicker = EventDatePicker(dateTextField: dateTextField)
        
        if(dateTextField.text!.characters.count == 0)    {
            dateTextField.text = Utility.getCurrentDate()
        }
        dateTextField.inputView = datePicker
    }
    
    class func getCurrentDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.kDateFormat
        
        return dateFormatter.string(from: Date())
    }
    
    class func stringFromDate(eventDate:NSDate) -> String {
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.kDateFormat
        
        return dateFormatter.string(from: eventDate as Date)
    }
    
    class func dateFromString(dateString:String) -> NSDate {
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.kDateFormat//"dd-MM-yyyy"
        
        return dateFormatter.date(from:dateString)! as NSDate
    }
    
    
    // MARK: - View Utils
    class func showWithZoomAnim(view:UIView)
    {
        view.transform = CGAffineTransform(scaleX: 0.1,y: 0.1)
        
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    class func hideWithZoomAnim(view:UIView, completion: (Void)?)
    {
        view.transform = CGAffineTransform(scaleX: 1,y: 1)
        
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        },completion:{ _ in
            if(completion != nil){
                completion!
            }
        })
    }
    
    class func showAlert(overVC vc:UIViewController, title: String = "Message", message: String?, completion: (()-> Void )?)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if(completion != nil) {
                completion!()
            }
        }
        
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
}
