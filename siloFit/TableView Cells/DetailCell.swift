//
//  BranchCell.swift
//  gitTest
//
//  Created by Ankur Sehdev on 05/02/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit


class DetailCell: UITableViewCell {
    @IBOutlet weak var images: PhotosCollectionView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var areaLbl: UILabel!
    @IBOutlet weak var capacityLbl: UILabel!
    @IBOutlet weak var addLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.images.register(UINib(nibName: "PhotosCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        images.delegate = dataSourceDelegate
        images.dataSource = dataSourceDelegate
        images.tag = row
        images.reloadData()
    }
    
}

extension UIImageView {
    func load(url: String) {
        guard let link = URL(string: url) else { return  }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: link) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
