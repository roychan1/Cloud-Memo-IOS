//
//  ContainerCell.swift
//  CloudMemo
//
//  Created by roy on 4/2/22.
//

import UIKit
import SWTableViewCell

class ContainerCell: SWTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bracketImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
