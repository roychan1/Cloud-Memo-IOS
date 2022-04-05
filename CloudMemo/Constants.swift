//
//  Constants.swift
//  CloudMemo
//
//  Created by roy on 3/30/22.
//

import Foundation

struct K {
    static let nibName = "ContainerCell"
    static let cellIdentifier = "ContainerCell"
    
    struct Firestore {
//        static let body = "body"
//        static let title = "title"
        
        static let homeDirectory = "_HomeDirectory"
        static let folder = "_Folder"
        static let file = "_File"
    }
    
    struct Segue {
        static let login = "SignInToDirectory"
        static let register = "RegisterToDirectory"
        static let openDocument = ""
    }
    
    struct Directory {
        static let cell = "DirectoryCell"
    }
    
    struct Container {
        static let name = "name"
    }
    
    struct File {
        static let name = "name"
        static let content = "content"
    }
    
    struct Folder {
        static let name = "name"
        static let contains = "contains"
    }
}
