//
//  EntriesData.swift
//  bnet-test
//
//  Created by Tigran Danielian on 08.06.2020.
//  Copyright © 2020 Tigran Danielian. All rights reserved.
//

import Foundation

struct EntriesData: Codable {
    let data: [[EData]]
    
    enum CodingKeys: String, CodingKey {
       case data = "data"
    }
}

struct EData: Codable {
    let id: String
    let body: String
    let da: String
    let dm: String
    
    enum CodingKeys: String, CodingKey {
    case id = "id"
    case body = "body"
    case da = "da"
    case dm = "dm"
    }
}
