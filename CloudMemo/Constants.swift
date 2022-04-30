//
//  Constants.swift
//  CloudMemo
//
//  Created by roy on 3/30/22.
//

import Foundation

struct K {
    static let nibName = "ContainerCellNib"
    static let cellIdentifier = "ContainerCell"
    static let directoryViewIdentifier = "DirectoryViewIdentifier"
    
    struct Firestore {
//        static let body = "body"
//        static let title = "title"
        
        static let users = "users"
        static let homeFoldersPointer = "homeFoldersPointer"
        static let homeFolders = "homeFolders"
        static let empty = "_empty"
        static let type = "type"
        static let emptyType = "empty"
        static let fileType = "file"
        static let folderType = "folder"
    }
    
    struct Segue {
        static let login = "SignInToDirectory"
        static let register = "RegisterToDirectory"
        static let openDocument = "DirectoryToFile"
    }
    
    struct Directory {
        static let cell = "DirectoryCell"
    }
    
    struct Container {
        static let type = "type"
        static let created = "created"
        
        struct File {
            static let name = "name"
            static let content = "content"
        }
        
        struct Folder {
            static let name = "name"
            static let contains = "contains"
        }
    }
}
