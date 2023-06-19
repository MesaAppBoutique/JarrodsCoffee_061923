//
//  MenuCategoryTableViewCell.swift
//  JarrodsCoffee
//
//  Created by Jason Carter on 11/1/21.
//

import UIKit

class MenuCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
