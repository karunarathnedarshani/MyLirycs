//
//  AppData.swift
//  MyLyrics
//
//  Created by Digital-07 on 3/28/19.
//  Copyright © 2019 chathuranga. All rights reserved.
//

import Foundation
class AppData{

static let defaultS = UserDefaults.standard

static func storeData (data: String?, key: String){
    defaultS.setValue(data, forKey: key)
    defaultS.synchronize()
}

static func getData (key: String) -> String{
    if let useData = defaultS.string(forKey: key){
        return useData
    }else {
        return ""
    }
    
}
}

enum UserData: String{
    case username = "USERNAME"
    case userID = "USERID"
    
}
    

