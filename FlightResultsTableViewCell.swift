//
//  FlightResultsTableViewCell.swift
//  FlightAttendantApp
//
//  Created by Annemarie Ketola on 1/19/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import UIKit

class FlightResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var FltIdLabel: UILabel!
    @IBOutlet weak var OriginLabel: UILabel!
    @IBOutlet weak var SchedArrTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
