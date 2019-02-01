//
//  PlayerScoreCell.swift
//  FBLA Trivia
//
//  Created by Tanner York on 2/1/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit

class PlayerScoreCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: Properties
    @IBOutlet weak var playerScoreAndName: UILabel!
    
    
    //MARK: Actions
    func setupCell(for player: PlayerScore) {
        playerScoreAndName.text = "\(player.name!): \(player.score!)"
    }
    
}
