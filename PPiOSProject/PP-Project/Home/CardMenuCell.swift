//
//  CardMenuCell.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/20/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit

class CardMenuCell: UITableViewCell {
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        return view
    }()
    
    lazy var cardImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 125, height: 100))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 150, y: 15, width: self.frame.width - 80, height: 30))
        return lbl
    }()
    
    lazy var name2Label: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 150, y: 40, width: self.frame.width - 80, height: 30))
        return lbl
    }()
    
    lazy var name3Label: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 150, y: 65, width: self.frame.width - 80, height: 30))
        return lbl
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        addSubview(backView)
        backView.addSubview(cardImage)
        backView.addSubview(nameLabel)
        backView.addSubview(name2Label)
        backView.addSubview(name3Label)
    }

}
