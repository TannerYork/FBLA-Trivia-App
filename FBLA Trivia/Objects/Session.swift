//
//  Session.swift
//  KnockOut
//
//  Created by Tanner York on 12/11/18.
//  Copyright © 2018 Tanner York. All rights reserved.
//

import Foundation
import Firebase

class Session {
    var players: [String] = []
    var activePlayers: [String] = []
    var inActivePlayers: [String] = []
    var images: [String] = []
    
    init(_ data: [String: Any]) {
        players.append(contentsOf: data["Players"] as! Array<String>)
        activePlayers.append(contentsOf: data["ActivePlayers"] as! Array<String>)
        inActivePlayers.append(contentsOf: data["InActivePlayers"] as! Array<String>)
        images.append(contentsOf: data["Images"] as! Array<String>)
    }
    
}

