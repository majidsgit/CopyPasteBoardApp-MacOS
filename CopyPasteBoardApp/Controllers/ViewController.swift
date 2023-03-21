//
//  ViewController.swift
//  CopyPasteBoardApp
//
//  Created by Majid on 20/03/2023.
//

import AppKit

class ViewController: NSViewController {
    
    fileprivate var itemsFilter = 0 // 0:All, 1:Folders, 2:Files
    fileprivate var items = [Item]()
    fileprivate var itemsFiltered = [Item]()
    fileprivate var saveDirectoryURL: NSURL?
    
    @IBOutlet weak var itemsFilterComboButton: NSComboButton!
    @IBOutlet weak var pasteOperationButton: NSButton!
    @IBOutlet weak var deleteItemsButton: NSButton!
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var infoButton: NSButton!
    
    @IBOutlet weak var itemsCollectionView: NSCollectionView!
    
    
    @IBAction func pasteButtonDidTap(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.delegate = self
        panel.title = "PasteBoard - Paste"
        panel.prompt = "Paste"
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        guard let window = self.view.window else { return }
        panel.beginSheetModal(for: window) { [weak self] response in
            if response == .cancel {
                self?.saveDirectoryURL = nil
            } else if response == .OK {
                self?.pasteItemsToSelectedURL()
            }
        }
    }
    @IBAction func deleteItemsButtonDidTap(_ sender: Any) {
        if itemsFilter == 0 {
            items.removeAll()
            itemsFiltered.removeAll()
            itemsCollectionView.reloadData()
            deleteItemsButton.isEnabled = false
            pasteOperationButton.isEnabled = false
        } else {
            for filter in itemsFiltered {
                items.removeAll(where: { $0.url == filter.url })
            }
            itemsFiltered.removeAll()
            deleteItemsButton.isEnabled = false
            pasteOperationButton.isEnabled = false
        }
    }
    @IBAction func settingsButtonDidTap(_ sender: Any) {
        
    }
    @IBAction func infoButtonDidTap(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        let identifier = NSUserInterfaceItemIdentifier("ItemCell")
        itemsCollectionView.register(CollectionViewItem.self, forItemWithIdentifier: identifier)
        
        setupFilterMenuItems()
        setupPasteBoard()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func setupPasteBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(onPasteboardChanged), name: .NSPasteboardDidChange, object: nil)
        
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
    
    @objc func onPasteboardChanged(_ notification: Notification) {
        guard let pasteBoard = notification.object as? NSPasteboard else {
            return
        }
        
        if let items = pasteBoard.pasteboardItems {
            for item in items {
                if let urlString = item.string(forType: .fileURL) {
                    if let url = NSURL(string: urlString) {
                        if let urlInfo = url.getFileInfo() {
                            
                            guard let itemType = urlInfo[URLResourceKey.fileResourceTypeKey] else { return }
                            
                            let type = itemType as! URLFileResourceType == URLFileResourceType.directory ? ItemType.folder : ItemType.file
                            
                            let item = Item(title: urlInfo[URLResourceKey.nameKey] as? String, type: type, url: url, fileSize: urlInfo[URLResourceKey.totalFileSizeKey] as? Int64)
                            
                            if self.items.contains(where: { $0.url == item.url }) == false {
                                self.items.append(item)
                                self.filterItems()
                            }
                        }
                    }
                }
            }
        }
    }
    
    enum pasteError: Error {
        case fileNotFound, urlPathError
    }
    
    func pasteItemsToSelectedURL() {
        do {
            for item in items {
                guard let urlPath = item.url?.path else {
                    throw pasteError.urlPathError
                }
                print(urlPath)
                if FileManager.default.fileExists(atPath: urlPath) == false {
                    throw pasteError.fileNotFound
                }
            }
            for item in items {
                guard let srcURL = item.url as? URL else {
                    throw pasteError.urlPathError
                }
                guard let dstURL = self.saveDirectoryURL as? URL else {
                    throw pasteError.urlPathError
                }
                try FileManager.default.copyItem(at: srcURL, to: dstURL)
                items.removeAll()
                itemsFiltered.removeAll()
                itemsCollectionView.reloadData()
            }
        } catch let error {
            print(error)
            // show modal error
        }
    }
    
    func filterItems() {
        itemsFiltered = items.filter({ [weak self] item in
            switch self?.itemsFilter {
            case 0:
                return true
            case 1:
                return item.type == .folder
            case 2:
                return item.type == .file
            default:
                return false
            }
        })
        deleteItemsButton.isEnabled = itemsFiltered.count > 0
        pasteOperationButton.isEnabled = itemsFiltered.count > 0
        itemsCollectionView.reloadData()
    }
    
    @objc func itemsFilterSetToAll() {
        itemsFilterComboButton.title = "All"
        itemsFilterComboButton.image = NSImage(systemSymbolName: "list.bullet", accessibilityDescription: nil)
        itemsFilter = 0
        filterItems()
    }
    
    @objc func itemsFilterSetToFolders() {
        itemsFilterComboButton.title = "Folders"
        itemsFilterComboButton.image = NSImage(systemSymbolName: "folder", accessibilityDescription: nil)
        itemsFilter = 1
        filterItems()
    }
    
    @objc func itemsFilterSetToFiles() {
        itemsFilterComboButton.title = "Files"
        itemsFilterComboButton.image = NSImage(systemSymbolName: "doc", accessibilityDescription: nil)
        itemsFilter = 2
        filterItems()
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

extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsFiltered.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let itemIdentifier = NSUserInterfaceItemIdentifier("ItemCell")
        if let item = collectionView.makeItem(withIdentifier: itemIdentifier, for: indexPath) as? CollectionViewItem {
            let current = itemsFiltered[indexPath.item]
            item.titleLabel.stringValue = current.title ?? "Unknown"
            item.itemTypeImageView.image = NSImage(systemSymbolName: current.type.rawValue, accessibilityDescription: nil)

            let size = current.getFileSize()
            item.sizeLabel.stringValue = String(format: "%.2f", size.size) + " " + size.unit
            
            item.filePath = current.url
            
            return item
        }
        return NSCollectionViewItem()
    }
    
}


extension ViewController: NSOpenSavePanelDelegate {
    
    func panel(_ sender: Any, didChangeToDirectoryURL url: URL?) {
        self.saveDirectoryURL = url as? NSURL
    }
}
