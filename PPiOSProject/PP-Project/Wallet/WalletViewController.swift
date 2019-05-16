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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
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
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
