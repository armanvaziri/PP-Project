//
//  POICollectionViewCell.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/16/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit

class POICollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locationDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // custom UI
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
        let borderColor = UIColor.lightGray
        self.layer.borderColor = borderColor.cgColor
        nextButton.addTarget(self, action: #selector(pulseButton(_:)), for: .touchDown)
    }
    
    @objc func pulseButton(_ sender:UIButton) {
        sender.pulse()
    }
    
}
