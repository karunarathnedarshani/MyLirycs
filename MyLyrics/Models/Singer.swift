//
//  Singer.swift
//  MyLyrics
//
//  Created by Mudith Chathuranga on 3/25/19.
//  Copyright © 2019 chathuranga. All rights reserved.
//

import Foundation
import UIKit

class Singer {
    var singerID: String!
    var singerName: String!
    var singerNameSin: String!
    var singerImageURL: String!
    var singerImage: UIImage?
    var userImageLoading: Bool = false
    
    init(singerID: String, singerName: String, singerNameSin: String, singerImageURL: String) {
        self.singerID = singerID
        self.singerName = singerName
        self.singerNameSin = singerNameSin
        self.singerImageURL = singerImageURL
        self.singerImage = nil
        self.userImageLoading = false
    }
}
