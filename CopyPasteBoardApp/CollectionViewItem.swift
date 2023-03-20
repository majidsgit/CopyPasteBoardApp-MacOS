//
//  CollectionViewItem.swift
//  CopyPasteBoardApp
//
//  Created by Majid on 21/03/2023.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var sizeLabel: NSTextField!
    @IBOutlet weak var itemTypeImageView: NSImageView!
    
    var filePath: NSURL?
    
    @IBAction func gotoButtonDidTap(_ sender: Any) {
        // open folder containing file or folder.
        if let filePath {
            NSWorkspace.shared.showInFinder(url: filePath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
