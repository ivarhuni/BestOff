//
//  CategoryWinnerCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 21/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

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
    
    func setupWithCategory(category: BOCategoryModel? = nil, txtTitle: String? = nil , _ styleType: Endpoint = .rvkDining, randomItem: BOCatItem?){
        
        setupDefault()
        setupForType(type: styleType)
        guard let item = randomItem else { return }
        setupWithRandomItemFromCategory(randomItem: item)
    }
    
    private func setupWithRandomItemFromCategory(randomItem: BOCatItem){
        
        guard let detailItem = randomItem.detailItem else { return }
        lblCategoryTitle.text = detailItem.categoryTitle
        
        //Sometimes the BOCategoryDetailItem doesn't have a categoryTitle
        if detailItem.categoryTitle.count == 0{
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
    
    private func setupForType(type: Endpoint){
        
        switch type{
            
        case .rvkDining:
            
            setLeftLineAndLblLayerTo(color: .colorRed)
            
            lblCatName.text = "DINING"
            lblBrowseMore.text = "Browse More Restaurants"
            
            showSwipeAndPageCtrl()
            hideImgViewSponsor()
            
            lblTakeMeThere.textColor = .colorRed
            lblTakeMeThere.layer.borderColor = UIColor.colorRed.cgColor
            
        case .rvkDrink:
            setLeftLineAndLblLayerTo(color: .peachBtnBorder)
            
            lblCatName.text = "DRINKING"
            lblBrowseMore.text = "Browse More Bars"
            
            showSwipeAndPageCtrl()
            showImgViewSponsor()
            
        case .rvkShopping:
            setLeftLineAndLblLayerTo(color: .yellowBtnBorder)
            
            lblCatName.text = "SHOPPING"
            lblBrowseMore.text = "Browse More Shops"
            
            showSwipeAndPageCtrl()
            hideImgViewSponsor()
            
        case .rvkActivities:
            
            setLeftLineAndLblLayerTo(color: .colorBlueBtnBorder)
            
            lblCatName.text = "ACTIVITIES"
            lblBrowseMore.text = "Browse More Activities"
            
            hideSwipeLblAndPageCtrl()
            hideImgViewSponsor()

        default:
            hideSwipeLblAndPageCtrl()
            hideImgViewSponsor()
            setLeftLineAndLblLayerTo(color: .colorRed)
            lblCatName.text = ""
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
    }
}

extension CategoryWinnerCell{
    
    func getShortTitleFromLongTitle(longTitle: String) -> String{
        
        let arrLongTitle = longTitle.split(separator: ":")
        guard let shortTitle = arrLongTitle[safe: 1] else { return "" }
        
        return String(shortTitle)
    }
}
