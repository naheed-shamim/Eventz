//
//  EventHomeVC.swift
//  Eventz
//
//  Created by Naheed Shamim on 31/08/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import UIKit
import CloudKit

class EventHomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!

    //Instance variables
    var eventArray : Array<Event> = []
    var isSortAscendng : Bool = false
    
    // MARK: - Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    // MARK: - Private Methods
    func refreshData()
    {
        eventArray.removeAll()
        loadEvents()
    }
    
    func loadEvents()
    {
        var errorMsg : String?
        EventzActivityIndicator.sharedInstance.showIndicatorOn(vc: self)
        
        CloudKitManager.fetchAllRecord(recordType: Constants.kTypeEvent) { (results, error) in
            
            if error != nil {
                print("Error" + (error?.localizedDescription)!)
                errorMsg = error?.localizedDescription
            }
            else {
                for event in results! {
                    let aEvent = Event(record: event)
                    self.eventArray.append(aEvent)
                }
            }
            
            DispatchQueue.main.async {
                EventzActivityIndicator.sharedInstance.hideIndicator()                
                if errorMsg != nil {
                    Utility.showAlert(overVC: self, message: errorMsg, completion: nil)
                }
                else{
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func sortEventsBy(key:String, sortStatus:Bool)
    {
        var errorMsg : String?
        
        EventzActivityIndicator.sharedInstance.showIndicatorOn(vc: self)
        
        CloudKitManager.fetchAllRecord(recordType: Constants.kTypeEvent, sortBy: key, sort: sortStatus)
        { (results, error) in
            
            if error != nil
            {
                errorMsg = (error?.localizedDescription)!
            }
            else
            {
                for event in results!
                {
                    let eEvent = Event(record: event)
                    self.eventArray.append(eEvent)
                }
            }
                DispatchQueue.main.async
                {
                    EventzActivityIndicator.sharedInstance.hideIndicator()
                    if errorMsg != nil {
                        Utility.showAlert(overVC: self, message: errorMsg, completion: nil)
                    }
                    else
                    {
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        cell.setupCellFor(event: eventArray[indexPath.row])
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedEvent = self.eventArray[indexPath.row]
                let destVC = segue.destination as! EventDetailVC
                destVC.aEvent = selectedEvent
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func refreshTable(_ sender: Any) {
        refreshData()
    }
    
    @IBAction func sortByDateAction(_ sender: Any) {
        
        isSortAscendng = !isSortAscendng
        eventArray.removeAll()
        sortEventsBy(key: Constants.kEventDate, sortStatus: isSortAscendng)
    }
    
    @IBAction func sortByNameAction(_ sender: Any) {
        
        isSortAscendng = !isSortAscendng
        eventArray.removeAll()
        sortEventsBy(key: Constants.kEventName, sortStatus: isSortAscendng)
    }
}
