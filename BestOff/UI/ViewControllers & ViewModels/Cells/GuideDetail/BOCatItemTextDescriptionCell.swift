//
//  BOCatItemTextDescriptionCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class BOCatItemTextDescriptionCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension BOCatItemTextDescriptionCell{
    
    static func reuseIdentifier() -> String{
        return "BOCatItemTextDescriptionCell"
    }
    
    static func nibName() -> String{
        return "BOCatItemTextDescriptionCell"
    }
}

extension BOCatItemTextDescriptionCell{
    
    private func style(){
        
        lblDescription.minimumScaleFactor = 0.25
        lblDescription.adjustsFontSizeToFitWidth = true
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byClipping
        lblDescription.font = UIFont.cellItemText
        lblDescription.textColor = .colorGrayishBrown
        
        self.selectionStyle = .none
    }
    
    func setText(text: String){
        style()
        lblDescription.text = text
    }
}
