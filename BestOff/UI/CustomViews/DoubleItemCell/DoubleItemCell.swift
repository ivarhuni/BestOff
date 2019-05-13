//
//  DoubleItemCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 13/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class DoubleItemCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension DoubleItemCell{
    
    public static func reuseIdentifier() -> String{
        return "DoubleItemCell"
    }
    
    public static func nibName() -> String{
        return "DoubleItemCell"
    }
}

extension DoubleItemCell{
    
    func setupWithGuides(arrGuides: [BOCatItem]){
        
    }
}
