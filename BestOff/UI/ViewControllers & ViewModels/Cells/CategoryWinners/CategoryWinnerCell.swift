//
//  CategoryWinnerCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 21/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit



protocol TakeMeThereProtocol: AnyObject {
    func didPressTakeMeThere(type: Endpoint)
}

protocol ShowCategoryDetail: AnyObject{
    
    func didPressCategoryDetail(catDetail: BOCategoryDetail, type: Endpoint?)
}

class CategoryWinnerCell: UITableViewCell {
    
    
    @IBOutlet weak var lblCatName: UILabel!
    @IBOutlet weak var lblBrowseMore: UILabel!
    @IBOutlet weak var lblTakeMeThere: UILabel!
    @IBOutlet weak var lblSwipe: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewSep: UIView!
    @IBOutlet weak var viewLeftLineOnImgView: UIView!
    @IBOutlet weak var imgViewSponsor: UIImageView!
    @IBOutlet weak var imgViewFingers: UIImageView!
    @IBOutlet weak var lblCatWinnerItem: UILabel!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var viewBgFingersAndLabel: UIView!
    
    var catType: Endpoint?
    var randomItem: BOCategoryDetail?
    
    weak var delegateTakeMeThere: TakeMeThereProtocol?
    weak var delegateShowCategoryDetail: ShowCategoryDetail?
    
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
extension CategoryWinnerCell{
    
    static func reuseIdentifier() -> String{
        
        return "CategoryWinnerCell"
    }
    
    static func nibName() -> String{
        return "CategoryWinnerCell"
    }
}

extension CategoryWinnerCell: ShowCategoryDetail{
    
    func didPressCategoryDetail(catDetail: BOCategoryDetail, type: Endpoint?) {
        print("did press category detail")
        guard let delegate = self.delegateShowCategoryDetail else {
            print("noshowcategorydetail delegate not set")
            return
        }
        delegate.didPressCategoryDetail(catDetail: catDetail, type: catType)
    }
}

extension CategoryWinnerCell: TakeMeThereProtocol{
    
    func didPressTakeMeThere(type: Endpoint) {
        
        guard let delegate = delegateTakeMeThere else {
            print("delegate not set for Take Me There")
            return
        }
        guard let cellType = self.catType else {
            print("celltype not set")
            return
        }
        delegate.didPressTakeMeThere(type: cellType)
    }
    
    private func setupTakeMeThereGestureRec(){
        
        BOGuideViewController.clearGestureRecForView(view: lblTakeMeThere)
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnTakeMeThere(_:)))
        lblTakeMeThere.addGestureRecognizer(tapGestureRec)
        lblTakeMeThere.isUserInteractionEnabled = true
    }
    
    private func setupOpenRandomItem(){
        
        BOGuideViewController.clearGestureRecForView(view: viewBgFingersAndLabel)
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnRandomItem(_:)))
        viewBgFingersAndLabel.addGestureRecognizer(tapGestureRec)
        viewBgFingersAndLabel.isUserInteractionEnabled = true
    }
    
    @objc func handleTapOnRandomItem(_ sender: UITapGestureRecognizer) {
        
        print("tapped take me there")
        guard let detailItem = self.randomItem else {
            print("no detail item in handleTapOnRandomItem")
            return
        }
        didPressCategoryDetail(catDetail: detailItem, type: catType)
    }
    
    @objc func handleTapOnTakeMeThere(_ sender: UITapGestureRecognizer) {
        
        print("tapped take me there")
        guard let type = self.catType else { return }
        didPressTakeMeThere(type: type)
    }
}

extension CategoryWinnerCell{
    
    private func setupDefault(){
        style()
    }
    
    private func style(){
        setupColors()
        setFonts()
        setupImgViews()
        selectionStyle = .none
    }
    
    private func setupTakeMeThere(){
        
        let borderWidth:CGFloat = 1.0
        lblTakeMeThere.layer.borderWidth = borderWidth
        lblTakeMeThere.text = "Take Me There"
        lblTakeMeThere.clipsToBounds = true
        lblTakeMeThere.layer.cornerRadius = lblTakeMeThere.frame.size.height/2.0
    }
    
    private func setupColors(){
        
        lblCatName.textColor = .black
        lblSwipe.textColor = .colorGreyDot
        lblBrowseMore.textColor = .colorGreyBrowse
        lblTakeMeThere.textColor = .colorRed
        lblCategoryTitle.textColor = .white
        lblCatWinnerItem.textColor = .white
        
        viewSep.backgroundColor = .colorGreySep
        
        viewBgFingersAndLabel.backgroundColor = .black
        viewBgFingersAndLabel.alpha = 0.3
    }
    
    private func setFonts(){
        
        lblCategoryTitle.font = UIFont.categoryImageTitle
        lblCatName.font = UIFont.categoryType
        lblSwipe.font = UIFont.swipeRightTxt
        lblBrowseMore.font = UIFont.browseMoreCatItems
        lblTakeMeThere.font = UIFont.rRedBtnText
        lblCatWinnerItem.font = UIFont.catItemImgNameBigger
    }
    
    private func setupImgViews(){
        
        imgView.clipsToBounds = true
        imgView.image = Asset.grapevineIcon.img
        imgView.contentMode = .scaleAspectFill
        
        imgViewFingers.setClipsAndScales()
        imgViewFingers.image = Asset.bestOfIcon.img
    }
}


extension CategoryWinnerCell{
    
    func setupWithCategory(category: BOCategoryModel? = nil,
                           _ styleType: Endpoint = .rvkDining,
                           randomItem: BOCatItem?,
                           delegate: TakeMeThereProtocol? = nil,
                           catDetailDelegate: ShowCategoryDetail? = nil){
        
        setupDefault()
        self.catType = styleType
        setupForType(type: styleType)
        guard let item = randomItem else {
            
                guard let tryNewRandomItem = category?.items.randomItem() else { return }
                setupWithRandomItemFromCategory(randomItem: tryNewRandomItem, category: category)
            if let cellDelegate = delegate{
                delegateTakeMeThere = cellDelegate
            }
            return
        }
        
        setupWithRandomItemFromCategory(randomItem: item, category: category)
        if let cellDelegate = delegate{
            delegateTakeMeThere = cellDelegate
        }
        if let catDetailDelegate = catDetailDelegate{
            delegateShowCategoryDetail = catDetailDelegate
        }
        
    }
    
    private func setupWithRandomItemFromCategory(randomItem: BOCatItem, category: BOCategoryModel?){
        
        guard let detailItem = randomItem.detailItem else {
            print("no random item from cat")
            return
        }
        self.randomItem = detailItem
        lblCategoryTitle.text = detailItem.arrItems.first?.categoryWinnerOrRunnerTitle
        
        setupTakeMeThereGestureRec()
        setupOpenRandomItem()
        
        //Sometimes the BOCategoryDetailItem doesn't have a categoryTitle
        if detailItem.categoryTitle.count == 0 || detailItem.categoryTitle == "The Reykjavik Grapevine"{
            print("Getting short title from LONG")
            lblCategoryTitle.text = getShortTitleFromLongTitle(longTitle: randomItem.title)
        }
        
        if let detailItemWinner = randomItem.detailItem?.arrItems.first {
            lblCatWinnerItem.text = detailItemWinner.itemName
        }
        
        guard let imgView = self.imgView else { return }
        guard let url = URL(string: randomItem.image) else { return }
        
        imgView.sd_setImage(with: url) { (image, error, _, _) in }
    }
    
    private func addShadows(){
        
        viewBgFingersAndLabel.addDropShadow(color: .black, opacity: Constants.highShadowOpacity, offset: CGSize(width: 2, height: 2), radius: 2)
        
        lblTakeMeThere.addDropShadow(color: .black, opacity: Constants.veryLowShadowOpacity, offset: .zero, radius: 2)
        lblCatName.addDropShadow(color: .black, opacity: 0.01, offset: .zero, radius: 2)
    }
    
    private func setupForType(type: Endpoint){
        
        setLeftLineAndLblLayerTo(color: UIColor.colorForType(type: type))
        
        hideSwipeLblAndPageCtrl()
        hideImgViewSponsor()
        
        switch type{
            
        case .rvkDining:
            lblCatName.text = "Dining"
            lblBrowseMore.text = "Browse More Restaurants"
            
            showSwipeAndPageCtrl()
            
            lblTakeMeThere.textColor = .colorRed
            lblTakeMeThere.layer.borderColor = UIColor.colorRed.cgColor
            
        case .rvkDrink:
            lblCatName.text = "Drinking"
            lblBrowseMore.text = "Browse More Bars"
            
            showImgViewSponsor()
            
        case .rvkShopping:
            lblCatName.text = "Shopping"
            lblBrowseMore.text = "Browse More Shops"
            
        case .rvkActivities:
            lblCatName.text = "Activities"
            lblBrowseMore.text = "Browse More Activities"

        case .guides:
            print("not applicable")
            
        case .east:
            lblCatName.text = "East"
            lblBrowseMore.text = "Browse more items"
        case .north:
            lblCatName.text = "North"
            lblBrowseMore.text = "Browse more items"

        case .westfjords:
            lblCatName.text = "Westfjords"
            lblBrowseMore.text = "Browse more items"
            
        case .south:
            lblCatName.text = "South"
            lblBrowseMore.text = "Browse more items"
            
        case .west:
            lblCatName.text = "West"
            lblBrowseMore.text = "Browse more items"
        case .reykjanes:
            lblCatName.text = "Reykjanes"
            lblBrowseMore.text = "Browse more items"
        }
        
        lblSwipe.text = "Swipe Left"
    }
    
    private func hideSwipeLblAndPageCtrl(){
        lblSwipe.text = "Swipe Left"
        lblSwipe.isHidden = true
        pageControl.isHidden = true
    }
    
    private func showSwipeAndPageCtrl(){
        lblSwipe.isHidden = false
        pageControl.isHidden = false
    }
    
    private func hideImgViewSponsor(){
        imgViewSponsor.isHidden = true
    }
    
    private func showImgViewSponsor(){
        imgViewSponsor.isHidden = false
    }
    
    private func setLeftLineAndLblLayerTo(color: UIColor){
        
        viewLeftLineOnImgView.backgroundColor = color
        lblTakeMeThere.layer.borderColor = color.cgColor
        lblTakeMeThere.textColor = color
    }
}

extension CategoryWinnerCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupTakeMeThere()
        addShadows()
    }
}

extension CategoryWinnerCell{
    
    func getShortTitleFromLongTitle(longTitle: String) -> String{
        
        let arrLongTitle = longTitle.split(separator: ":")
        guard let shortTitle = arrLongTitle[safe: 1] else { return "" }
        
        return String(shortTitle)
    }
}
