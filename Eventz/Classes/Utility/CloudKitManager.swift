//
//  CloudKitManager.swift
//  CloudKitSwift
//
//  Created by Naheed Shamim on 29/08/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    static let publicDatabase = CKContainer.default().publicCloudDatabase
    
    class func saveRecord(record : CKRecord, completionHandler: @escaping (CKRecord?, Error?) -> Void)
    {
        publicDatabase.save(record) {(result, error) in
            completionHandler(result, error)
        }
    }
    
    
    class func fetchRecord(withRecordID: CKRecordID, completionHandler: @escaping (CKRecord?, Error?) -> Void)
    {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        publicDatabase.fetch(withRecordID: withRecordID) { (result, error) in
            completionHandler(result,error)
        }
    }


    class func fetchAllRecord(recordType:String, completionHandler: @escaping ([CKRecord]?, Error?) -> Void)
    {
        let queryPredicate = NSPredicate(value: true)
        let contactQuery = CKQuery(recordType: recordType, predicate: queryPredicate)
        contactQuery.sortDescriptors = [NSSortDescriptor(key: Constants.kCreationDate, ascending:false)]
        
        publicDatabase.perform(contactQuery, inZoneWith: nil) { (results, error) in
            completionHandler(results, error)
        }
    }
    
    class func fetchAllRecord(recordType:String, sortBy:String, sort:Bool, completionHandler: @escaping ([CKRecord]?, Error?) -> Void)
    {
        let queryPredicate = NSPredicate(value: true)
        let contactQuery = CKQuery(recordType: recordType, predicate: queryPredicate)
        contactQuery.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending:sort)]
        
        publicDatabase.perform(contactQuery, inZoneWith: nil) { (results, error) in
            completionHandler(results, error)
        }
    }
    
}
