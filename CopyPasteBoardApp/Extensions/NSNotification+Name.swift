//
//  NSNotification+Name.swift
//  CopyPasteBoardApp
//
//  Created by Majid on 20/03/2023.
//

import AppKit

extension NSNotification.Name {
    public static let NSPasteboardDidChange: NSNotification.Name = .init(rawValue: "pasteboardDidChangeNotification")
}
