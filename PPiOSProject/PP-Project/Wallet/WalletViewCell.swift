//
//  WalletViewCell.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/13/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit

class WalletViewCell: UITableViewCell {
    
    @IBOutlet weak var cardImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardImage.layer.cornerRadius = 10.0
        //color
        cardImage.layer.shadowColor = UIColor.lightGray.cgColor
        //offset
        cardImage.layer.shadowOffset = CGSize(width: 1, height: 1)
        //radius
        cardImage.layer.shadowRadius = 5.0
        //opacity
        cardImage.layer.shadowOpacity = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
