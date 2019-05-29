//
//  DoubleItemImgCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 21/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class DoubleItemImgCell: UITableViewCell {

    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var imgViewLeft: UIImageView!
    @IBOutlet weak var viewColorLeft: UIView!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var imgViewRight: UIImageView!
    @IBOutlet weak var viewColorRight: UIView!
    @IBOutlet weak var lblRight: UILabel!
    @IBOutlet weak var viewDeleteBackground: UIView!
    
    @IBOutlet weak var imgRemoveLeft: UIImageView!
    @IBOutlet weak var lblRemoveLeft: UILabel!
    @IBOutlet weak var lblRemoveRight: UILabel!
    @IBOutlet weak var imgRemoveRight: UIImageView!
    @IBOutlet weak var viewRemoveRight: UIView!
    @IBOutlet weak var viewRemoveLeft: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


extension DoubleItemImgCell{
    
    public static func reuseIdentifier() -> String{
        return "DoubleItemImgCell"
    }
    
    public static func nibName() -> String{
        return "DoubleItemImgCell"
    }
}

extension DoubleItemImgCell{
    
    
    func setupWithArrCatDetailItems(arrCatDetailItems: [BOCategoryDetailItem], screenType: Endpoint, isEditActive: Bool = false){
        
        setupDefault()
        setVerticalColorFor(type: screenType)
        guard let firstCategory = arrCatDetailItems[safe: 0] else { return }
        setupWithLeftItem(categoryDetailItem: firstCategory)
        
        guard let secondCategory = arrCatDetailItems[safe: 1] else { return }
        setupWithRightItem(categoryDetailItem: secondCategory)
        
        if isEditActive{
            
        }
    }
    
    private func setVerticalColorFor(type: Endpoint){
        viewColorLeft.backgroundColor = UIColor.colorForType(type: type)
        viewColorRight.backgroundColor = UIColor.colorForType(type: type)
    }
    
    private func clearRight(){
        
        imgViewRight.image = nil
        lblRight.text = ""
    }
    
    private func setupWithLeftItem(categoryDetailItem: BOCategoryDetailItem){
        
        clearRight()
        lblLeft.text = categoryDetailItem.itemName
        guard let url = categoryDetailItem.imageURL else { return }
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewLeft, strURL: url)
    }
    
    private func setupWithRightItem(categoryDetailItem: BOCategoryDetailItem){
        
        lblRight.text = categoryDetailItem.itemName
        guard let url = categoryDetailItem.imageURL else { return }
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewRight, strURL: url)
    }
    
    private func setupDefault(){
        style()
        setupImgViews()
        disableSelection()
    }
    
    private func disableSelection(){
        selectionStyle = .none
    }
    
    private func setupImgViews(){
        imgViewLeft.setClipsAndScales()
        imgViewRight.setClipsAndScales()
        
        imgRemoveLeft.setClipsAndScales()
        imgRemoveRight.setClipsAndScales()
    }
    
    private func style(){
        setColors()
        setFonts()
    }
    
    private func setColors(){
        lblRight.textColor = .black
        lblLeft.textColor = .black
        
        lblRemoveRight.textColor = .colorGreyBrowse
        lblRemoveLeft.textColor = .colorGreyBrowse
        
        lblRight.addDropShadow(color: .black, opacity: Constants.veryLowShadowOpacity, offset: .zero, radius: 1)
        lblLeft.addDropShadow(color: .black, opacity: Constants.veryLowShadowOpacity, offset: .zero, radius: 1)
        
        viewDeleteBackground.alpha = 0
    }
    
    private func setFonts(){
        lblLeft.font = UIFont.catItemType
        lblRight.font = UIFont.catItemType
        
        
        lblRemoveLeft.font = UIFont.favBtnRemove
        lblRemoveRight.font = UIFont.favBtnRemove
    }
}

extension DoubleItemImgCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewLeft.addDropShadow(color: .black, opacity: Constants.highShadowOpacity, offset: .zero, radius: 2)
        rightView.addDropShadow(color: .black, opacity: Constants.highShadowOpacity, offset: .zero, radius: 2)
    }
}
