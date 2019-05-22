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
    
    
    func setupWithArrCatDetailItems(arrCatDetailItems: [BOCategoryDetailItem], screenType: Endpoint){
        
        setupDefault()
        setVerticalColorFor(type: screenType)
        guard let firstCategory = arrCatDetailItems[safe: 0] else { return }
        setupWithLeftItem(categoryDetailItem: firstCategory)
        
        guard let secondCategory = arrCatDetailItems[safe: 1] else { return }
        setupWithRightItem(categoryDetailItem: secondCategory)
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
    }
    
    private func style(){
        setColors()
        setFonts()
    }
    
    private func setColors(){
        lblRight.textColor = .black
        lblLeft.textColor = .black
    }
    
    private func setFonts(){
        lblLeft.font = UIFont.catItemType
        lblRight.font = UIFont.catItemType
    }
}

extension DoubleItemImgCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewLeft.addDropShadow(color: .black, opacity: 0.1, offset: .zero, radius: 2)
        rightView.addDropShadow(color: .black, opacity: 0.1, offset: .zero, radius: 2)
    }
}
