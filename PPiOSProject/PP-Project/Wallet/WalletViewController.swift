//
//  WalletViewController.swift
//  PP-Project
//
//  Created by Arman Vaziri on 5/13/19.
//  Copyright © 2019 Arman Vaziri. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var walletView: UITableView!
    @IBOutlet weak var AddCardButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    @IBAction func AddCardPressed(_ sender: Any) {
        performSegue(withIdentifier: "addCardSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WalletViewCell {
            if let cardImage = cell.cardImage {
                cardImage.image = UIImage(named: images[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    
    var images = ["card1", "card2", "card3", "card4", "card5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        walletView.delegate = self
        walletView.dataSource = self
        walletView.rowHeight = 225.0
        walletView.separatorColor = UIColor.clear
    }
}
