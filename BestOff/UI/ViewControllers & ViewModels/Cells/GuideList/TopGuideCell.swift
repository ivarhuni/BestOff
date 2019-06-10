//
//  TopGuideCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 03/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit
import SDWebImage


protocol FavouritePressed {
    
    func pressedFavouriteWithItem(catDetail: BOCategoryModel)
}


class TopGuideCell: UITableViewCell{
    
    //MARK: Properties
    @IBOutlet weak var imgViewBig: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGrapevine: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var viewBgIcon: UIView!
    @IBOutlet weak var sep: UIView!
    @IBOutlet weak var viewBlackBackground: UIView!
    
    @IBOutlet weak var viewCatAddress: UIView!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var btnFavourite: UIButton!
    
    @IBOutlet weak var imgViewDropShadow: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var imgViewBestOff: UIImageView!
    
    @IBOutlet weak var imgViewAddressPin: UIImageView!
    
    //MARK: Inititialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnFavPressed(_ sender: Any) {
        
        print("fav pressed")
    }
    
    @IBAction func btnDirections(_ sender: Any) {
        
        print("pressed directions")
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
        viewBlackBackground.addDropShadow(color: .black, opacity: Constants.highShadowOpacity, offset: CGSize(width: 2, height: 2), radius: 3)
    }
}

//MARK: Setup & Style default setup
extension TopGuideCell{
    
    private func setupDefault(){
        
        setColors()
        setFonts()
        setDefaults()
        imgViewBig.setClipsAndScales()
        imgViewIcon.setClipsAndScales()
        
        showForGuide()
        selectionStyle = .none
    }
    
    private func showForGuide(){
    
        viewBgIcon.alpha = 1
        lblTitle.alpha = 1
        imgViewIcon.alpha = 1
        
        viewCatAddress.alpha = 0
        viewCategory.alpha = 0
    }
    
    private func showForCategory(){
        
        lblTitle.alpha = 0
        viewCategory.alpha = 1
        viewCatAddress.alpha = 1
    }
    
    private func setDefaults(){
        
        lblGrapevine.text = "Reykjavík Grapevine"
        lblDate.text = ""
        imgViewIcon.image = Asset.grapevineIcon.img
        adjustFontsFor(label: lblTitle)
        adjustFontsFor(label: lblAddress)
        
        lblName.font = UIFont.catDtlItemTitle
        lblAddress.font = UIFont.catDtlItemAddressTitle
        btnFavourite.titleLabel?.font = UIFont.redDirectionText
    }
    
    private func adjustFontsFor(label: UILabel){
    
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
    }
    
    private func setColors(){
        
        viewBgIcon.backgroundColor = .colorRed
        lblTitle.textColor = .colorBlackText
        lblGrapevine.textColor = .white
        lblDate.textColor = .white
        sep.backgroundColor = .colorGreySep
        lblName.textColor = .black
        lblAddress.textColor = .colorGrayishBrown
        btnFavourite.setTitleColor(.colorRed, for: .normal)
    }
    
    private func setFonts(){
        
        lblTitle.font = UIFont.categoryHeadline
        lblDate.font = UIFont.gvImageText
        lblGrapevine.font = UIFont.gvImageHeadline
    }
}

//MARK: Guide List Setup
extension TopGuideCell{
    
    func setupWith(item: BOCatItem) {
        
        setupDefault()
        
        setTextsFrom(item: item)
        setImageWithImgURL(url: item.image)
    }
    
    public func styleForDetail(){
        lblTitle.font = UIFont.boldImgTitle
    }
    
    private func setTextsFrom(item: BOCatItem){
        lblTitle.text = item.title
        guard let strDate = item.strTimeStamp else { return }
        lblDate.text = strDate
        
        lblName.text = ""
        lblAddress.text = ""
    }
    
    private func setImageWithImgURL(url: String?){
        guard let strURL = url else { return }
        guard let imgView = imgViewBig else { return }
        guard let urlFromString = URL.init(string: strURL) else { return }
        imgView.setClipsAndScales()
        imgView.sd_setImage(with: urlFromString, placeholderImage: nil, options: [], completed: nil)
    }
}

extension TopGuideCell{
    
    func setupForCategory(item: BOCatItem, isFavourited: Bool){
        
        setupDefault()
        showForGuide()
        setImageWithImgURL(url: item.image)
        
        setTextsFrom(item: item)
        
        imgViewBestOff.image = imgViewBestOff.image?.withRenderingMode(.alwaysTemplate)
        imgViewBestOff.tintColor = .black
        
        if isFavourited{
            btnFavourite.setBackgroundImage(Asset.heartFilled.img, for: .normal)
            return
        }
        btnFavourite.setBackgroundImage(Asset.heart.img, for: .normal)
    }
    
    private func setTextsFrom(detailItem: BOCategoryDetailItem){
        lblName.text = detailItem.itemName
        lblAddress.text = detailItem.itemAddress
        
        
        lblTitle.text = ""
        lblDate.text = ""
    }
    
    private func setTextsFrom(catDetail: BOCategoryDetail){
        
//        lblName.text = catDetail.categoryTitle
//        lblAddress.text = catD
//
        
        lblTitle.text = ""
        lblDate.text = ""
    }
    
    func setupForCategoryImgAndDesc(catDetail: BOCategoryDetail, isFavourited: Bool){
        
        setupDefault()
        showForCategory()
        
        //setImageWithImgURL(url: catDetail.)
        
        //setTextsFrom(detailItem: catDetail)
        
        imgViewBestOff.image = imgViewBestOff.image?.withRenderingMode(.alwaysTemplate)
        imgViewBestOff.tintColor = .black
        
        if isFavourited{
            btnFavourite.setBackgroundImage(Asset.heartFilled.img, for: .normal)
            return
        }
        btnFavourite.setBackgroundImage(Asset.heart.img, for: .normal)
    }
    
    func setupForCategoryDetailItem(detailItem: BOCategoryDetailItem, isFavourited: Bool){
        
        setupDefault()
        showForCategory()
        
        setImageWithImgURL(url: detailItem.imageURL)
        
        setTextsFrom(detailItem: detailItem)
        
        imgViewBestOff.image = imgViewBestOff.image?.withRenderingMode(.alwaysTemplate)
        imgViewBestOff.tintColor = .black
        
        if isFavourited{
            btnFavourite.setBackgroundImage(Asset.heartFilled.img, for: .normal)
            return
        }
        btnFavourite.setBackgroundImage(Asset.heart.img, for: .normal)
    }
    
    
}
