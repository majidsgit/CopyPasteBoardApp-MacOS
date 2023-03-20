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
    let title: String?
    let type: ItemType
    let url: NSURL?
    let fileSize: Int64? //Bytes
    
    func getFileSize() -> (size: Double, unit: String) {
        guard let fileSize else { return (0.0, "NaN") }
        
        let kiloByte: Double = Double(fileSize / 1024)
        let megaByte: Double = kiloByte / 1024
        let gigaByte: Double = megaByte / 1024
        let teraByte: Double = gigaByte / 1024
        
        if teraByte >= Double(1.0) {
            return (teraByte, "TiB")
        }
        if gigaByte >= Double(1.0) {
            return (gigaByte, "GiB")
        }
        if megaByte >= Double(1.0) {
            return (megaByte, "MiB")
        }
        if kiloByte >= Double(1.0) {
            return (kiloByte, "KiB")
        }
        
        return (0.0, "NaN")
    }
    
}
