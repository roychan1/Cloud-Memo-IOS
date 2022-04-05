//
//  Folder.swift
//  CloudMemo
//
//  Created by roy on 4/1/22.
//

import Foundation

struct Folder : Container {
    var name: String
    
    var contains : [Container] = []
}
