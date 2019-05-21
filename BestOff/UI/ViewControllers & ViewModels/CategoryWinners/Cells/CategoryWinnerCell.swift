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
    @IBOutlet weak var lblRandomItemTitle: UILabel!
    
    
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
        setupImgView()
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
        lblRandomItemTitle.textColor = .white
        viewSep.backgroundColor = .colorGreySep
    }
    
    private func setFonts(){
        
        lblRandomItemTitle.font = UIFont.categoryImageTitle
        lblCatName.font = UIFont.categoryType
        lblSwipe.font = UIFont.swipeRightTxt
        lblBrowseMore.font = UIFont.browseMoreCatItems
        lblTakeMeThere.font = UIFont.rRedBtnText
    }

    private func setupImgView(){
        
        imgView.clipsToBounds = true
        imgView.backgroundColor = .colorRed
        imgView.image = Asset.grapevineIcon.img
        imgView.contentMode = .center
    }
    
}

extension CategoryWinnerCell{
    
    func setupWithCategory(category: BOCategoryModel? = nil, txtTitle: String = "DINING" , _ styleType: Endpoint = .rvkDining){
        
        setupDefault()
        setupForType(type: styleType)
        
    }
    
    private func setupWithRandomItemFromCategory(category: BOCategoryModel){
        
        guard let randomItem = category.items.randomItem() else { return }
        UIImageView.setSDImageViewImageWithURL(imageView: imgView, strURL: randomItem.image)
        lblRandomItemTitle.text = randomItem.title
    }
    
    private func setupForType(type: Endpoint){
        
        switch type{
            
        case .rvkActivities:
            setLeftLineAndLblLayerTo(color: .colorBlueBtnBorder)
            lblCatName.text = "ACTIVITIES"
            lblBrowseMore.text = "Browse More Activities"
            
        case .rvkDining:
            setLeftLineAndLblLayerTo(color: .colorRed)
            lblCatName.text = "DINING"
            lblBrowseMore.text = "Browse More Restaurants"
            
        case .rvkDrink:
            setLeftLineAndLblLayerTo(color: .colorPeachBtnBorder)
            lblCatName.text = "DRINKING"
            lblBrowseMore.text = "Browse More Bars"
            
        case .rvkShopping:
            setLeftLineAndLblLayerTo(color: .colorYellowBtnBorder)
            lblCatName.text = "SHOPPING"
            lblBrowseMore.text = "Browse More Shops"
            
        default:
            setLeftLineAndLblLayerTo(color: .colorRed)
            lblCatName.text = ""
        }
        
        lblSwipe.text = "Swipe Left"
    }
    
    private func setLeftLineAndLblLayerTo(color: UIColor){
        
        viewLeftLineOnImgView.backgroundColor = color
        lblTakeMeThere.layer.borderColor = color.cgColor
    }
}

extension CategoryWinnerCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupTakeMeThere()
    }
}
