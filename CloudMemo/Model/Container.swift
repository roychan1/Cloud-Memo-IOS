//
//  Container.swift
//  CloudMemo
//
//  Created by roy on 3/30/22.
//

import Foundation

protocol Container {
    var name: String { get set }
    var type : String { get set }
    var created: Date { get set }
}
