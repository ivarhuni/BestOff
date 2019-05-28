//
//  BOFavouriteCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 28/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class BOFavouriteCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension BOFavouriteCell{
    
    static func reuseIdentifier() -> String{
        
        return "BOFavouriteCell"
    }
    
    static func nibName() -> String{
        return "BOFavouriteCell"
    }
}
