//
//  BOGuideCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class BOGuideCell: UITableViewCell {
    
    @IBOutlet weak var someLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BOGuideCell{
    public static func reuseIdentifier() -> String{
        return "BOGuideCell"
    }
}

extension BOGuideCell: GuideCell{
    
    func setupWith(item: BOCatItem){
        
        print("")
    }
}
