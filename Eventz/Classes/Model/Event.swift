//
//  Event.swift
//  Eventz
//
//  Created by Naheed Shamim on 29/08/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import UIKit
import CloudKit

class Event: NSObject {
    
    var eventID : String
    var name : String
    var date : NSDate
    var videoLink : String?
    var details : String?
    var image : UIImage
    
    init(record_ID: String?,name:String, date:NSDate,link:String,details:String,img:UIImage)
    {
        if let recID = record_ID
        {
            self.eventID = recID
        }
        else
        {
            self.eventID = ""
        }
        
        self.name = name
        self.date = date
        self.videoLink = link
        self.details = details
        self.image = img
    }   
    
     init(record : CKRecord)
     {
        let eventID : CKRecordID = record.object(forKey: Constants.kRecordID) as! CKRecordID
        self.eventID = eventID.recordName
        
        self.name = record.object(forKey: Constants.kEventName) as! String
        self.details = record.object(forKey: Constants.kEventDetails) as? String
        
        self.date = record.object(forKey: Constants.kEventDate) as! Date as NSDate
        self.videoLink = record.object(forKey: Constants.kVideoLink) as? String
        
        if let imgAsset : CKAsset = record.object(forKey: Constants.kEventImg) as? CKAsset{
            self.image = imgAsset.toUIImage()!
        }
        else{
            self.image = UIImage(named: "NotAvailable.png")!
        }
     }
    
    // Returns the UniqueID for each record
    func getRecordName() -> String
    {
        return self.eventID
    }
    
    // Converts Model class to CKRecord for uploading to iCloud
    func getCKRecord() -> CKRecord
    {
        let record = CKRecord(recordType: Constants.kTypeEvent)
        
        if let videoLink = self.videoLink  {
            record[Constants.kVideoLink] = videoLink as CKRecordValue
        }
        else { record[Constants.kVideoLink] = "" as CKRecordValue    }
        
        record[Constants.kEventName] = self.name as CKRecordValue
        record[Constants.kEventDate] = self.date as NSDate
        record[Constants.kEventDetails] = self.details! as CKRecordValue
        
        let imgURL = Utility.getImageURL(image: self.image, imageName: self.name)
        
        let imgAsset = CKAsset(fileURL: imgURL)
        record[Constants.kEventImg] = imgAsset
        
        return record
    }
}

// Converts CKAsset to UIImage
extension CKAsset {
    func toUIImage() -> UIImage? {
        if let data = NSData(contentsOf: self.fileURL) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
