//
//  BOCatItemTextDescriptionCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class BOCatItemTextDescriptionCell: UITableViewCell {

    var cornerRoundType: roundCorner = .roundNone
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var constraintLblLeading: NSLayoutConstraint!
    @IBOutlet weak var viewBackground: UIView!
    
    
    
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
        
        lblDescription.minimumScaleFactor = 0.4
        lblDescription.adjustsFontSizeToFitWidth = true
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byClipping
        lblDescription.font = UIFont.cellItemText
        lblDescription.textColor = .colorGrayishBrown
        constraintLblLeading.constant = 20
        self.selectionStyle = .none
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setText(text: String){
        style()
        lblDescription.text = text
    }
    
    func changeLeadingConstraintToCatDetail(){
        constraintLblLeading.constant = 20
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setBackgroundForCategory(){
        self.contentView.backgroundColor = .colorRed
    }
}

extension BOCatItemTextDescriptionCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //roundCornerForType(roundCorner: self.cornerRoundType)
    }
    
    func roundCornerForType(roundCorner: roundCorner){
        
        switch roundCorner {
        case .roundNone:
            viewBackground.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 0)
            self.contentView.backgroundColor = .white
        case .roundAll:
            viewBackground.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: Constants.cornerRadiusGuideDetail)
            self.contentView.backgroundColor = .colorRed
        case .roundBot:
           viewBackground.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Constants.cornerRadiusGuideDetail)
            self.contentView.backgroundColor = .colorRed
        case .roundTop:
            viewBackground.roundCorners(corners: [.topLeft, .topRight], radius: Constants.cornerRadiusGuideDetail)
            self.contentView.backgroundColor = .colorRed
        }
    }
}
