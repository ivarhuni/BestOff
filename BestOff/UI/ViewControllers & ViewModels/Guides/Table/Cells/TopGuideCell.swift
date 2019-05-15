//
//  TopGuideCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 03/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit
import SDWebImage

class TopGuideCell: UITableViewCell{
    
    //MARK: Properties
    @IBOutlet weak var imgViewBig: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGrapevine: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var viewBgIcon: UIView!
    @IBOutlet weak var sep: UIView!
    

    //MARK: Inititialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: Reuse identifier
extension TopGuideCell{
    
    static func reuseIdentifier() -> String{
        
        return "TopGuideCell"
    }
    
    static func nibName() -> String{
        return "TopGuideCell"
    }
}

//MARK:
extension TopGuideCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewBgIcon.layer.cornerRadius = viewBgIcon.frame.size.height/2.0
        viewBgIcon.clipsToBounds = true
    }
}

//MARK: Setup & Style default setup
extension TopGuideCell{
    
    private func setupDefault(){
        
        setColors()
        setFonts()
        setDefaults()
        self.clipsToBounds = true
        self.imgViewBig.clipsToBounds = true
        self.imgViewBig.contentMode = .scaleAspectFill
        self.imgViewIcon.contentMode = .scaleAspectFill
    }
    
    private func setDefaults(){
        
        lblGrapevine.text = "Reykjavík Grapevine"
        lblDate.text = ""
        imgViewIcon.image = Asset.grapevineIcon.img
        lblTitle.minimumScaleFactor = 0.25
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byClipping
    }
    
    private func setColors(){
        
        viewBgIcon.backgroundColor = .colorRed
        lblTitle.textColor = .colorBlackText
        lblGrapevine.textColor = .white
        lblDate.textColor = .white
        sep.backgroundColor = .colorGreySep
    }
    
    private func setFonts(){
        
        lblTitle.font = UIFont.categoryHeadline
        lblDate.font = UIFont.gvImageText
        lblGrapevine.font = UIFont.gvImageHeadline
    }
}

//MARK:
extension TopGuideCell: GuideCell{
    public func setupWith(item: BOCatItem) {
        
        setupDefault()
        
        setTextsFrom(item: item)
        setImageWithImgURL(strURL: item.image)
        
    }
    
    private func setTextsFrom(item: BOCatItem){
        lblTitle.text = item.title
        
        guard let strDate = BOCatItem.getStrDateFromStrURL(strURL: item.url) else { return }
        lblDate.text = strDate
    }
    
    private func setImageWithImgURL(strURL: String){
        guard let imgView = imgViewBig else { return }
        guard let urlFromString = URL.init(string: strURL) else { return }
        imgView.contentMode = .scaleAspectFill
        imgView.sd_setImage(with: urlFromString, placeholderImage: nil, options: [], completed: nil)
        print(imgView.frame.size.height)
    }
}


