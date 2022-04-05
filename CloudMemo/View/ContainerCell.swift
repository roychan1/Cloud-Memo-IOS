//
//  ContainerCell.swift
//  CloudMemo
//
//  Created by roy on 4/2/22.
//

import UIKit

class ContainerCell: UITableViewCell {

    @IBOutlet weak var arrowLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
