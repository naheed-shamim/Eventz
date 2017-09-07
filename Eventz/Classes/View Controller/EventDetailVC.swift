//
//  EventDetailVC.swift
//  Eventz
//
//  Created by Naheed Shamim on 30/08/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import UIKit
import CloudKit

class EventDetailVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variable and Outlets
    //IBOutlets
    @IBOutlet weak var eventNameTF: UITextField!
    @IBOutlet weak var eventDateTF: UITextField!
    @IBOutlet weak var videoLinkTF: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pickImageButton: UIButton!
    
    //Instance Variables
    var aEvent : Event?
    var editMode : Bool = false
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    func setupUI()
    {
        // Set the RightN Navigation Item and set its action
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(enableTxtFields))
        
        // Init values to the the iVar "aEvent"
        if(aEvent != nil)
        {
            self.title = aEvent?.name
            editMode = true
            self.eventNameTF.text = aEvent?.name
            self.eventDateTF.text = Utility.stringFromDate(eventDate: (aEvent?.date)!)
            self.descriptionTxtView.text = aEvent?.details
            self.videoLinkTF.text = aEvent?.videoLink
            self.imgView.image = aEvent?.image
        }        
        
        // If Edit mode, initiate with textfields disabled
        if editMode {
            disableTxtFields()
        }
        
        //Set TextView Border
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        self.descriptionTxtView.layer.borderWidth = 0.6
        self.descriptionTxtView.layer.borderColor = borderColor.cgColor
        self.descriptionTxtView.layer.cornerRadius = 5.0
    }
    
    
    func addEvent(event:Event)
    {
        var errorMsg = "Success"
        let eventRecord = event.getCKRecord()
        
        EventzActivityIndicator.sharedInstance.showIndicatorOn(vc: self)
     
        CloudKitManager.saveRecord(record: eventRecord, completionHandler: { (record, error) in
            
            if let error = error {
                errorMsg = error.localizedDescription
            }
            
            DispatchQueue.main.async{
                EventzActivityIndicator.sharedInstance.hideIndicator()
                
                Utility.showAlert(overVC: self, message: errorMsg, completion: nil)
                
                Utility.clearDocumentDirectory(filename: event.name)
                                self.resetFields()
            }
        })
    }
    
    func updateRecord(event:Event)
    {
        let myRecordName = aEvent?.getRecordName()
        let recordID = CKRecordID(recordName: myRecordName!)
        
        EventzActivityIndicator.sharedInstance.showIndicatorOn(vc: self)
        
        var errorMsg = "Success"
        CloudKitManager.fetchRecord(withRecordID: recordID) { (record, error) in
            if let error = error {
                errorMsg = error.localizedDescription
            }
            else {
                // Fetch Record Success, Now Update with the new Values
                
                record?.setObject(event.name as CKRecordValue, forKey: Constants.kEventName)                
                record?.setObject(event.date as NSDate, forKey: Constants.kEventDate)
                record?.setObject(event.details! as CKRecordValue, forKey: Constants.kEventDetails)
                record?.setObject(event.videoLink as CKRecordValue?, forKey: Constants.kVideoLink)
                
                let imgURL = Utility.getImageURL(image: event.image, imageName: event.name)
                record?[Constants.kEventImg] = CKAsset(fileURL: imgURL)
                
                // Now save the edited Record
                CloudKitManager.saveRecord(record: record!, completionHandler: { (record, error) in
                    if let error = error {
                        errorMsg = error.localizedDescription
                    }
                    
                    DispatchQueue.main.async{
                        EventzActivityIndicator.sharedInstance.hideIndicator()
                        Utility.showAlert(overVC: self, message: errorMsg, completion: nil)
                    }
                })
            }
        }
    } 
    
    func getValuesFromVC() -> Event
    {
        let dateOfEvent = Utility.dateFromString(dateString: eventDateTF.text!)
        
        let theEvent = Event(record_ID: aEvent?.eventID ,name: eventNameTF.text!, date: dateOfEvent, link: videoLinkTF.text!, details: descriptionTxtView.text, img: imgView.image!)
        
        return theEvent
    }
    
    func resetFields()
    {
        self.eventNameTF.text = ""
        self.eventDateTF.text = ""
        self.videoLinkTF.text = ""
        self.descriptionTxtView.text = ""
        self.imgView.image = UIImage(named: "NotAvailable.png")
    }
    
    func disableTxtFields()
    {
        editFields(isEnabled: false)
    }
    
    func enableTxtFields()
    {
        navigationItem.rightBarButtonItem?.isEnabled = false
        editFields(isEnabled: true)
    }
    
    func editFields(isEnabled:Bool) {
        self.eventNameTF.isEnabled = isEnabled
        self.eventDateTF.isEnabled = isEnabled
        self.videoLinkTF.isEnabled = isEnabled
        self.descriptionTxtView.isUserInteractionEnabled = isEnabled
        self.pickImageButton.isEnabled = isEnabled
    }
    
    func areTextFieldsEmpty() -> Bool
    {
        var isEmpty : Bool = false
        if (self.eventNameTF.text?.isEmpty)! || (self.eventDateTF.text?.isEmpty)!
        {
                isEmpty = true
        }
        
        return isEmpty
    }
    
    // MARK: - IBActions
    @IBAction func showImagePreview()
    {
        ImagePreview.sharedInstance.showImage(image: self.imgView.image!, vc: self)
    }
    
    @IBAction func hideKeyboard()
    {
        self.view.endEditing(true)
        ImagePreview.sharedInstance.hideImagePreview()        
    }
    
    @IBAction func uploadEventAction(_ sender: Any) {
        
        var anEvent : Event!        
                
        if(!areTextFieldsEmpty())
        {
            anEvent = getValuesFromVC()
            if(editMode)
            {
                updateRecord(event: anEvent)
            }
            else
            {
                addEvent(event: anEvent)
            }
        }
        else
        {
            Utility.showAlert(overVC: self, message: "Fields Can't be Empty", completion: nil)
        }
    }
    
    @IBAction func uploadImageAction(_ sender: Any)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    // MARK: - ImagePicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.imgView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == eventDateTF) {
            Utility.showDatePicker(dateTextField: textField)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.eventDateTF{
            return false
        }
        else{
        return true
        }
    }
}

