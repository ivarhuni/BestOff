//
//  BOCatHeaderCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 06/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class BOCatHeaderCell: UITableViewCell {

    @IBOutlet weak var lblCategoryTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension BOCatHeaderCell{
    static func reuseIdentifier() -> String{
        return "BOCatHeaderCell"
    }
    
    static func nibName() -> String{
        return "BOCatHeaderCell"
    }
}

extension BOCatHeaderCell{
    
    func setup(){
        lblCategoryTitle.textColor = .colorBlack
        lblCategoryTitle.text = "GUIDES"
        lblCategoryTitle.font = UIFont.categoryType
    }
}
