//
//  Item.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import Foundation


struct Item: Codable {
    var title: String?
    var count: Int?
    var editMode: Bool = false
}
