//
//  DoubleItemCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 13/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit
import SDWebImage

class DoubleItemCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    
    @IBOutlet weak var imgViewLeft: UIImageView!
    @IBOutlet weak var imgViewRight: UIImageView!
    
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var lblRight: UILabel!
    
    @IBOutlet weak var imgViewAuthorRight: UIImageView!
    @IBOutlet weak var imgViewAuthorLeft: UIImageView!
    
    @IBOutlet weak var lblRightAuthor: UILabel!
    @IBOutlet weak var lblLeftAuthor: UILabel!
    
    @IBOutlet weak var viewBgLeft: UIView!
    @IBOutlet weak var viewBgRight: UIView!
    
    
    
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

//MARK: layoutSubviews
//overwritten to achieve cornerradius on reuse
extension DoubleItemCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadiusForAuthorImgView()
    }
    
    func setCornerRadiusForAuthorImgView(){
        imgViewAuthorLeft.clipsToBounds = true
        imgViewAuthorRight.clipsToBounds = true
        imgViewAuthorRight.layer.cornerRadius = imgViewAuthorRight.frame.height/2.0
        imgViewAuthorLeft.layer.cornerRadius = imgViewAuthorLeft.frame.height/2.0
    }
}

//MARK: Setup
extension DoubleItemCell{
    
    func setupWithItems(arrItems: [BOCatItem]){
        
        disableSelection()
        styleBackgroundViews()
        setupLabels()
        setupImgViews()
        guard let leftItem = arrItems[safe: 0] else { return }
        setupWithLeftItem(item: leftItem)
        
        guard let rightItem = arrItems[safe: 1] else { return }
        setupWithRightItem(item: rightItem)
     }
    
    func disableSelection(){
        self.selectionStyle = .none
    }
    
    func setupImgViews(){
        
        imgViewAuthorRight.contentMode = .scaleAspectFill
        imgViewAuthorLeft.contentMode = .scaleAspectFill
        
        imgViewRight.contentMode = .scaleAspectFill
        imgViewLeft.contentMode = .scaleAspectFill
        
        imgViewRight.clipsToBounds = true
        imgViewLeft.clipsToBounds = true
    }
    
    func styleBackgroundViews(){
        
        let bgAlpha:CGFloat = 0.05
        viewBgLeft.backgroundColor = .black
        viewBgRight.backgroundColor = .black
        
        viewBgRight.alpha = bgAlpha
        viewBgLeft.alpha = bgAlpha
    }
    
    func setupLabels(){
        
        setupFonts()
        setupLabelScalingForLabel(label: lblLeft)
        setupLabelScalingForLabel(label: lblRight)
    }
    
    func setupLabelScalingForLabel(label: UILabel){
        
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
    }
    
    func setupFonts(){
        
        lblLeft.textColor = .colorBlackText
        lblRight.textColor = .colorBlackText
        lblLeftAuthor.textColor = .white
        lblRightAuthor.textColor = .white
        
        lblLeft.font = UIFont.guideItem
        lblRight.font = UIFont.guideItem
        lblRightAuthor.font = UIFont.authorName
        lblLeftAuthor.font = UIFont.authorName
    }
    
    func setupWithLeftItem(item: BOCatItem){
        
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewAuthorLeft, strURL: item.author.avatar)
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewLeft, strURL: item.image)
        
        lblLeftAuthor.text = item.author.name
        lblLeft.text = item.title
        clearRight()
    }
    
    func clearRight(){
        lblRight.text = ""
        imgViewRight.image = nil
        lblRightAuthor.text = ""
        imgViewAuthorRight.image = nil
    }
    
    
    func setupWithRightItem(item: BOCatItem){
        
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewAuthorRight, strURL: item.author.avatar)
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewRight, strURL: item.image)
        
        lblRightAuthor.text = item.author.name
        lblRight.text = item.title
    }
}
