//
//  RecievedData.swift
//  bnet-test
//
//  Created by Tigran Danielian on 08.06.2020.
//  Copyright © 2020 Tigran Danielian. All rights reserved.
//

import Foundation

struct RecievedData: Codable {
    let data: RData
    
}

struct RData: Codable {
    let session: String
    
}
