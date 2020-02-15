//
//  PhotosCell.swift
//  siloFit
//
//  Created by Ankur Sehdev on 15/02/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    @IBOutlet weak var pageContorl: UIPageControl!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
//        self.widthConstraint.constant = width
    }

}
