//
//  File.swift
//  CloudMemo
//
//  Created by roy on 4/1/22.
//

import Foundation

struct File : Container {
    var name: String
    var type: String
    var created: Date
    var content : String = ""
}
