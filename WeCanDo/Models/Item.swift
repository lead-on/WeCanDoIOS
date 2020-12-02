//
//  Item.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import Foundation


struct Item: Codable {
    var title: String?
    var hexCode: String?
    var count: Int?
    var isEditMode: Bool = false // collectionView.reloadData()를 활용하기 위해 부득이하게 여기 들어감...
}
