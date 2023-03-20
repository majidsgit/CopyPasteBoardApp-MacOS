//
//  Item.swift
//  CopyPasteBoardApp
//
//  Created by Majid on 20/03/2023.
//

import AppKit

enum ItemType: String {
    case file = "doc"
    case folder = "folder"
}

struct Item {
    let id: String
    let title: String
    let type: ItemType
    let url: NSURL
}
