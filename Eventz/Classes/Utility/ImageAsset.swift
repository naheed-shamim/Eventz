//
//  ImageAsset.swift
//  Eventz
//
//  Created by Naheed Shamim on 07/09/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import Foundation

import CloudKit
import UIKit

class ImageAsset {
    
    var url:NSURL?
    
    let image:UIImage
    
    var asset:CKAsset? {
        get {
            let data = UIImagePNGRepresentation(self.image)
            self.url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") as NSURL?
            if let url = self.url {
                do {
                    try data!.write(to:url as URL, options: [])
                } catch let e as NSError {
                    print("Error! \(e)")
                }
                return CKAsset(fileURL: url as URL)
            }
            return nil
        }
    }
    
    init(image:UIImage){
        self.image = image
//        let data = UIImagePNGRepresentation(self.image)
//        self.url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") as NSURL?
    }
    
    deinit {
        if let url = self.url {
            do {
                try FileManager.default.removeItem(at: url as URL) }
            catch let e {
                print("Error deleting temp file: \(e)")
            }
        }
    }
}
