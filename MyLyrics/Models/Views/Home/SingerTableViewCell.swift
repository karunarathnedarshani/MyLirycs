//
//  SingerTableViewCell.swift
//  MyLyrics
//
//  Created by Mudith Chathuranga on 3/25/19.
//  Copyright © 2019 chathuranga. All rights reserved.
//

import UIKit

class SingerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var singerEnglishName: UILabel!
    @IBOutlet weak var singerSinhalaName: UILabel!
    @IBOutlet weak var singerImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.singerEnglishName.text = ""
        self.singerSinhalaName.text = ""
        self.singerImage.image = UIImage(named: "")
    }
    
}
