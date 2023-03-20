//
//  ViewController.swift
//  CopyPasteBoardApp
//
//  Created by Majid on 20/03/2023.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var itemsFilterComboButton: NSComboButton!
    
    @IBOutlet weak var itemsScrollView: NSScrollView!
    @IBOutlet weak var scrollViewItems: NSStackView!
    fileprivate var dropItems = [Item]()
    
    fileprivate var itemsFilter = 0 // 0:All, 1:Folders, 2:Files
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupFilterMenuItems()
        setupItemsScrollView()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func setupFilterMenuItems() {
        itemsFilterComboButton.menu.delegate = self
        
        let first = NSMenuItem(title: "All", action: #selector(itemsFilterSetToAll), keyEquivalent: "1")
        let second = NSMenuItem(title: "Folders", action: #selector(itemsFilterSetToFolders), keyEquivalent: "2")
        let third = NSMenuItem(title: "Files", action: #selector(itemsFilterSetToFiles), keyEquivalent: "3")
        
        itemsFilterComboButton.menu.items = [first, second, third]
        itemsFilterComboButton.title = "All"
        itemsFilterComboButton.image = NSImage(systemSymbolName: "list.bullet", accessibilityDescription: nil)
    }
    
    @objc func itemsFilterSetToAll() {
        itemsFilterComboButton.title = "All"
        itemsFilterComboButton.image = NSImage(systemSymbolName: "list.bullet", accessibilityDescription: nil)
        itemsFilter = 0
    }
    
    @objc func itemsFilterSetToFolders() {
        itemsFilterComboButton.title = "Folders"
        itemsFilterComboButton.image = NSImage(systemSymbolName: "folder", accessibilityDescription: nil)
        itemsFilter = 1
    }
    
    @objc func itemsFilterSetToFiles() {
        itemsFilterComboButton.title = "Files"
        itemsFilterComboButton.image = NSImage(systemSymbolName: "doc", accessibilityDescription: nil)
        itemsFilter = 2
    }
}

extension ViewController: NSMenuDelegate {
    
    func numberOfItems(in menu: NSMenu) -> Int {
        return 2
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        print("menu opened")
    }
    
    func menuDidClose(_ menu: NSMenu) {
        print("menu closed")
    }
}

extension ViewController {
    
    func setupItemsScrollView() {
        
        
        let first = Item(id: UUID().uuidString, title: "file", type: .file, url: NSURL(fileURLWithPath: "1"))
        let second = Item(id: UUID().uuidString, title: "folder", type: .folder, url: NSURL(fileURLWithPath: "2"))
        let third = Item(id: UUID().uuidString, title: "folder", type: .folder, url: NSURL(fileURLWithPath: "3"))
        let fourth = Item(id: UUID().uuidString, title: "file", type: .file, url: NSURL(fileURLWithPath: "4"))
        addToScrollView(item: first)
        addToScrollView(item: second)
        addToScrollView(item: third)
        addToScrollView(item: fourth)
    }
    
    func generateScrollViewItem(using item: Item) -> NSView {
        let view = NSStackView()
        
        view.distribution = .fill
        view.orientation = .horizontal
        view.spacing = 8.0
        view.alignment = .centerY
        
        if let image = NSImage(systemSymbolName: item.type.rawValue, accessibilityDescription: nil) {
            let imageView = NSImageView(image: image)
            view.addArrangedSubview(imageView)
        }
        
        let text = NSTextField(wrappingLabelWithString: item.title)
        view.addArrangedSubview(text)
        
        return view
    }
    
    func addToScrollView(item: Item) {
        if dropItems.contains(where: { $0.url == item.url }) == false {
            let view = generateScrollViewItem(using: item)
            scrollViewItems.addArrangedSubview(view)
            dropItems.append(item)
        }
    }
    
    func removeFromScrollView(item: NSView) {
        if scrollViewItems.subviews.contains(where: { $0.identifier == item.identifier }) {
            scrollViewItems.removeView(item)
        }
    }
    
    func clearScrollViewItems() {
        scrollViewItems.subviews.removeAll()
    }
}
