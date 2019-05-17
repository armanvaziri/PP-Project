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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // custom UI
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.5
        let turqoise = UIColor.FlatColor.Blue.TurquoiseBlue

        self.layer.borderColor = turqoise.cgColor
        
        
    
    }
}
