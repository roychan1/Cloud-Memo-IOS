//
//  Folder.swift
//  CloudMemo
//
//  Created by roy on 4/1/22.
//

import Foundation

struct Folder : Container {
    var name: String
    var type: String
    var created: Date
    var contains : [Container] = []
}
