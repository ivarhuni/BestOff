//
//  TopGuideCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 03/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

protocol FavAndShareDelegate: AnyObject {
    
    func pressedFavouriteWithItem(catItem: BOCatItem)
    func pressedShareWithItem(catItem: BOCatItem)
}

enum roundCorner{
    
    case roundAll
    case roundBot
    case roundTop
    case roundNone
}

class TopGuideCell: UITableViewCell{
    
    var cornerRoundType: roundCorner = .roundNone
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
    @IBOutlet weak var viewSepDirections: UIView!
    
    @IBOutlet weak var imgViewAddressPin: UIImageView!
    
    @IBOutlet weak var btnDirections: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    var favouriteItem: BOCatItem?
    weak var favouritePressedDelegate: FavAndShareDelegate?
    
    var address: String = ""
    
    //MARK: Inititialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnSharePressed(_ sender: Any) {
        guard let shareItem = favouriteItem else{
            print("no share item at button press")
            return
        }
        pressedShareWithItem(catItem: shareItem)
    }
    
    
    @IBAction func btnFavPressed(_ sender: Any) {
        guard let favItem = favouriteItem else {
            print("no fav item at button press")
            return
        }
        pressedFavouriteWithItem(catItem: favItem)
    }
    
    @IBAction func btnDirections(_ sender: Any) {
        
        if address != ""{
            openMap()
        }
    }
    
    func openMap() {
        
        let baseUrl = "http://maps.apple.com/?address="
        
        let encodedName = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let finalUrl = baseUrl + encodedName
        if let url = URL(string: finalUrl)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension TopGuideCell: FavAndShareDelegate{
    
    func pressedFavouriteWithItem(catItem: BOCatItem){
        guard let delegate = favouritePressedDelegate else{
            print("delegate not set for fav button in TopCell")
            return
        }
        delegate.pressedFavouriteWithItem(catItem: catItem)
    }
    
    func pressedShareWithItem(catItem: BOCatItem) {
        guard let delegate = favouritePressedDelegate else{
            print("delegate not set for fav button in TopCell")
            return
        }
        delegate.pressedShareWithItem(catItem: catItem)
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
        lblGrapevine.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: .zero, radius: 2)
        lblDate.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: .zero, radius: 2)
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
        viewSepDirections.backgroundColor = .greySep
        btnFavourite.alpha = 0
        showForGuide()
        
        selectionStyle = .none
    }
    
    private func showForGuide(){
        
        viewBgIcon.alpha = 1
        lblTitle.alpha = 1
        imgViewIcon.alpha = 1
        
        viewCatAddress.alpha = 0
        viewCategory.alpha = 1
        
        imgViewIcon.alpha = 1
        viewBgIcon.alpha = 1
        lblGrapevine.alpha = 1
    }
    
    private func showForCategory(){
        
        lblTitle.alpha = 0
        
        viewCategory.alpha = 1
        viewCatAddress.alpha = 1
        imgViewIcon.alpha = 0
        viewBgIcon.alpha = 0
        lblGrapevine.alpha = 0
    }
    
    private func setDefaults(){
        
        lblGrapevine.text = "Reykjavík Grapevine"
        lblDate.text = ""
        imgViewIcon.image = Asset.grapevineIcon.img
        
        lblName.font = UIFont.catDtlItemTitle
        lblAddress.font = UIFont.catDtlItemAddressTitle
        btnDirections.titleLabel?.font = UIFont.redDirectionText
        
        btnShare.alpha = 0
        
        adjustFontsFor(label: lblTitle)
        adjustFontsFor(label: lblAddress)
        adjustFontsFor(label: lblName)
        selectionStyle = .none
    }
    
    private func adjustFontsFor(label: UILabel){
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
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
        btnDirections.setTitleColor(.colorRed, for: .normal)
    }
    
    private func setFonts(){
        
        lblTitle.font = UIFont.categoryHeadline
        lblDate.font = UIFont.gvImageText
        lblGrapevine.font = UIFont.gvImageHeadline
        btnDirections.titleLabel?.font = UIFont.redDirectionText
    }
}

//MARK: Guide List Setup
extension TopGuideCell{
    
    func setupWith(item: BOCatItem, forFavourites: Bool = false, favDelegate: FavAndShareDelegate? = nil) {
        
        setupDefault()
        
        setTextsFrom(item: item)
        setImageWithImgURL(url: item.image)
        favouriteItem = nil
    
        if forFavourites{
            guard let delegate = favDelegate else {
                print("fav delegate not set for tablecell")
                return
            }
            btnShare.alpha = 1
            let image = Asset.share.img.withRenderingMode(.alwaysTemplate)
            btnShare.setBackgroundImage(image, for: .normal)
            btnShare.tintColor = .white
            favouritePressedDelegate = delegate
            favouriteItem = item
            setupFavourites()
            return
        }
    }
    
    func hideFavs(){
        btnFavourite.alpha = 0
    }
    
    func setupForEventDetailWith(item: BOCatItem){
        btnFavourite.alpha = 0
        btnShare.alpha = 0
        lblGrapevine.text = "Venue: \n" + item.author.name
    }
    
    func setupForEventWith(venueName: String){
        lblDate.text = ""
        lblGrapevine.text = venueName
    }
    
    private func setupFavourites(){
        guard let itemFav = favouriteItem else { return }
        
        btnFavourite.alpha = 1
        
        if checkIsItemFavourited(item: itemFav){
            btnFavourite.setBackgroundImage(Asset.heartFilled.img, for: .normal)
            return
        }
        btnFavourite.setBackgroundImage(Asset.heart.img, for: .normal)
    }
    
    private func checkIsItemFavourited(item: BOCatItem) -> Bool{
        
        return FavouriteManager.isItemFavourited(item: item)
    }
    
    public func styleForDetail(){
        lblTitle.font = UIFont.boldImgTitle
    }
    
    private func setTextsFrom(item: BOCatItem){
        lblTitle.text = item.title
        lblDate.text = item.id
        
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
    
    func setupForCategoryDetailItem(detailItem: BOCategoryDetailItem){
        
        setupDefault()
        showForCategory()
        
        setImageWithImgURL(url: detailItem.imageURL)
        
        setTextsFrom(detailItem: detailItem)
        
        imgViewBestOff.image = imgViewBestOff.image?.withRenderingMode(.alwaysTemplate)
        imgViewBestOff.tintColor = .black
        
        address = detailItem.itemAddress
        
        if address != ""{
            btnDirections.alpha = 1
        }
        else{
            btnDirections.alpha = 0
        }
    }
}

extension TopGuideCell{
    func roundCornerForType(roundCorner: roundCorner){
        
        switch roundCorner {
        case .roundNone:
            imgViewBig.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 0)
            viewBlackBackground.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 0)
            imgViewDropShadow.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 0)
        case .roundAll:
            imgViewBig.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: Constants.cornerRadiusGuideDetail)
            viewBlackBackground.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: Constants.cornerRadiusGuideDetail)
            imgViewDropShadow.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: Constants.cornerRadiusGuideDetail)
            self.contentView.backgroundColor = .colorRed
        case .roundBot:
            imgViewBig.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Constants.cornerRadiusGuideDetail)
            viewBlackBackground.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Constants.cornerRadiusGuideDetail)
            imgViewDropShadow.roundCorners(corners: [.bottomLeft, .bottomRight], radius: Constants.cornerRadiusGuideDetail)
            self.contentView.backgroundColor = .colorRed
        case .roundTop:
            imgViewBig.roundCorners(corners: [.topLeft, .topRight], radius: Constants.cornerRadiusGuideDetail)
            viewBlackBackground.roundCorners(corners: [.topLeft, .topRight], radius: Constants.cornerRadiusGuideDetail)
            imgViewDropShadow.roundCorners(corners: [.topLeft, .topRight], radius: Constants.cornerRadiusGuideDetail)
            self.contentView.backgroundColor = .colorRed
        }
    }
}

