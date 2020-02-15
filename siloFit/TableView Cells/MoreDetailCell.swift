//
//  MoreDetailCell.swift
//  siloFit
//
//  Created by Ankur Sehdev on 15/02/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit

class MoreDetailCell: UITableViewCell {
    @IBOutlet weak var dataList : DataCollectionView!
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dataList.register(UINib(nibName: "OptionsCell", bundle: nil), forCellWithReuseIdentifier: "OptionsCell")
    }

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        dataList.delegate = dataSourceDelegate
        dataList.dataSource = dataSourceDelegate
        dataList.tag = row
        dataList.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
