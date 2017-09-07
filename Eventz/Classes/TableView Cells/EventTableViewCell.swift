//
//  EventTableViewCell.swift
//  Eventz
//
//  Created by Naheed Shamim on 31/08/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventImgView: UIImageView!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCellFor(event: Event)
    {
        self.eventNameLbl.text = event.name
        self.eventDateLbl.text = Utility.stringFromDate(eventDate: event.date)
        self.eventImgView.image = event.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
