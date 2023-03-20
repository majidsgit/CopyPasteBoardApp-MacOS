//
//  NSURL+String.swift
//  CopyPasteBoardApp
//
//  Created by Majid on 20/03/2023.
//

import AppKit

extension NSURL {
    
    func getFileInfo() -> [URLResourceKey: Any]? {
        if let resource = try? self.resourceValues(forKeys: [.fileSizeKey, .nameKey, .isAliasFileKey, .fileResourceTypeKey, .totalFileAllocatedSizeKey, .isHiddenKey, .pathKey, .totalFileSizeKey]) {
            return resource
        }
        return nil
    }
    
    var isDirectory: Bool {
        if let resourceKey = try? resourceValues(forKeys: [.isDirectoryKey]) {
            return resourceKey[.isDirectoryKey] as? Bool ?? false
        }
        return false
    }

}
