//
//  ForecastCell.swift
//  Native Weather
//
//  Created by IMTIAZ on 8/15/17.
//  Copyright © 2017 IMTIAZ. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    @IBOutlet weak var weatherIcon: UIView!
    @IBOutlet weak var weatherDate: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherHumidity: UILabel!
    @IBOutlet weak var weatherPressure: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
