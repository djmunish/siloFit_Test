//
//  PullRequestCell.swift
//  gitTest
//
//  Created by Ankur Sehdev on 06/02/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit

class SpacesCell: UITableViewCell {

    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var areaLbl: UILabel!
    @IBOutlet weak var capacityLbl: UILabel!
    @IBOutlet weak var addLbl: UILabel!
    @IBOutlet weak var distLbl: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//extension UIImageView {
//    func load(url: String) {
//        guard let link = URL(string: url) else { return  }
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: link) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
extension UIImageView {
public func imageFromURL(urlString: String) {
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.white.cgColor
    let imgurl = URL(string: urlString)
    self.sd_setImage(with: imgurl, placeholderImage: UIImage.init(named: "profilepic_placeholder"), options:  [.retryFailed, .continueInBackground], completed: { (image, error, cacheType, imageURL) in
    })
    
}
}
