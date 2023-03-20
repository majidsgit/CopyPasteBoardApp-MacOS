//
//  NSWorkspaceExtension.swift
//  CopyPasteBoardApp
//
//  Created by Majid on 21/03/2023.
//

import AppKit

extension NSWorkspace {
    
    func showInFinder(url: NSURL?) {
        
        guard let url = url else { return }
        
        if url.isDirectory {
            if let urlString = url.path {
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: urlString)
            }
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([url as URL])
        }
    }

}
