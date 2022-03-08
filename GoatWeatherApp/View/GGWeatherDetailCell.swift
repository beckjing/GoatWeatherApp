//
//  GGWeatherDetailCell.swift
//  GoatWeatherApp
//
//  Created by 景悦诚 on 2022/3/8.
//

import UIKit

class GGWeatherDetailCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
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
