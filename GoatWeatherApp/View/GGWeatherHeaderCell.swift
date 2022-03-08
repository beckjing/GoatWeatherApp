//
//  GGWeatherHeaderCell.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/7.
//

import UIKit

class GGWeatherHeaderCell: UITableViewCell {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var tempRangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
