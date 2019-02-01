//
//  PlayerCell.swift
//  KnockOut
//
//  Created by Tanner York on 12/3/18.
//  Copyright © 2018 Tanner York. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with player: String) {
        userNameLabel.text = player
    }

    
    
}
