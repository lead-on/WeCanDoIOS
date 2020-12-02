//
//  SubItem.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/18.
//

import Foundation


struct SubItem: Codable {
    var id: Int?
    var description: String?
    var isFinished: Bool = false
    var isEditMode: Bool = false
    var isSortMode: Bool = false
}
