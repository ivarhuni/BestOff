//
//  GuideItemCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class GuideItemCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewSep: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension GuideItemCell{
    
    static func nibName() -> String{
        return "GuideItemCell"
    }
    
    static func reuseIdentifier() -> String{
        return "GuideItemCell"
    }
}

extension GuideItemCell{
    
    func setupDefault(){
        
        style()
        setupImgView()
    }
    
    private func setupImgView(){
        imgView.setClipsAndScales()
    }
    
    private func style(){
        setFonts()
        setColors()
    }
    
    private func setFonts(){
        lblItemName.font = UIFont.cellItemName
        lblAddress.font = UIFont.catDtlItemAddressTitle
    }
    
    private func setColors(){
        lblItemName.textColor = .black
        lblAddress.textColor = .colorGrayishBrown
        viewSep.backgroundColor = .colorGreySep
    }
}

extension GuideItemCell{
    
    func setupWithGuide(guide: BOCategoryDetailItem){
        
        setupDefault()
        lblAddress.text = guide.itemAddress
        lblItemName.text = guide.itemName
        guard let imgURL = guide.imageURL else { return }
        setImageWithImgURL(strURL: imgURL)
    }
    
    private func setImageWithImgURL(strURL: String){
        guard let imgView = imgView else { return }
        guard let urlFromString = URL.init(string: strURL) else { return }
        imgView.sd_setImage(with: urlFromString, placeholderImage: nil, options: [], completed: nil)
    }
}
