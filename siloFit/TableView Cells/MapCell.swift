//
//  RepositoryCell.swift
//  gitTest
//
//  Created by Ankur Sehdev on 05/02/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var addMap: UILabel!
    @IBOutlet weak var dayOpenLbl: UILabel!
    @IBOutlet weak var timeOpenLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
