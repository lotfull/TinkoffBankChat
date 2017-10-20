//
//  Profile.swift
//  TinkoffConversation
//
//  Created by Kam Lotfull on 20.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

struct Profile {
    let name: String
    let info: String
    let image: UIImage
    
    
}

extension Profile: Equatable {
    static func ==(l: Profile, r: Profile) -> Bool {
        return l.name == r.name && l.info == r.info && l.image == r.image
    }
}
