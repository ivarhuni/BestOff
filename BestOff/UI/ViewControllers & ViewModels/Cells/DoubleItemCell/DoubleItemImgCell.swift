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
    @IBOutlet weak var viewRemoveContainer: UIView!
    
    @IBOutlet weak var viewRemoveWhiteCover: UIView!
    @IBOutlet weak var imgRemoveLeft: UIImageView!
    @IBOutlet weak var lblRemoveLeft: UILabel!
    @IBOutlet weak var lblRemoveRight: UILabel!
    @IBOutlet weak var imgRemoveRight: UIImageView!
    @IBOutlet weak var viewRemoveRight: UIView!
    @IBOutlet weak var viewRemoveLeft: UIView!
    
    var leftItem: BOCategoryDetailItem?
    var rightItem: BOCategoryDetailItem?
    
    var leftGestureRec: UIGestureRecognizer?
    var rightGestureRec: UIGestureRecognizer?
    
    weak var deleteDelegate: DeleteFavouriteItem?
    
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
        leftItem = nil
        rightItem = nil
        
        isEditActive ? showWhiteEditBackground() : hideWhiteEditBackground()
        
        selectionStyle = .none
        
        guard let firstCategory = arrCatDetailItems[safe: 0] else { return }
        setupWithLeftItem(categoryDetailItem: firstCategory, isEditActive: isEditActive)
        
        guard let secondCategory = arrCatDetailItems[safe: 1] else { return }
        setupWithRightItem(categoryDetailItem: secondCategory, isEditActive: isEditActive)
    }
    
    private func setVerticalColorFor(type: Endpoint){
        viewColorLeft.backgroundColor = UIColor.colorForType(type: type)
        viewColorRight.backgroundColor = UIColor.colorForType(type: type)
    }
    
    private func clearRight(){
        
        imgViewRight.image = nil
        lblRight.text = ""
        
        rightView.isHidden = true
        viewColorRight.isHidden = true
        viewRemoveRight.isHidden = true
    }
    
    private func showRight(){
        
        rightView.isHidden = false
        viewColorRight.isHidden = false
        viewRemoveRight.isHidden = false
    }
    
    private func setupWithLeftItem(categoryDetailItem: BOCategoryDetailItem, isEditActive: Bool){
        
        lblLeft.text = categoryDetailItem.itemName
        leftItem = categoryDetailItem
        selectionStyle = .none
        if isEditActive{
            showLeftRemove()
        }else{
            hideLeftRemove()
        }
        
        guard let url = categoryDetailItem.imageURL else { return }
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewLeft, strURL: url)
        clearRight()
    }
    
    private func setupWithRightItem(categoryDetailItem: BOCategoryDetailItem, isEditActive: Bool){
        
        lblRight.text = categoryDetailItem.itemName
        rightItem = categoryDetailItem
        showRight()
        selectionStyle = .none
        if isEditActive{
            showRightRemove()
        }else{
            hideRightRemove()
        }
        
        guard let url = categoryDetailItem.imageURL else { return }
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewRight, strURL: url)
    }
    
    private func setupDefault(){
        style()
        setupLabels()
        setupImgViews()
        setupRemoveViews()
        disableSelection()
    }
    
    private func setupLabels(){
        
        lblLeft.minimumScaleFactor = 0.85
        lblLeft.lineBreakMode = .byClipping
        
        lblRight.minimumScaleFactor = 0.85
        lblRight.lineBreakMode = .byClipping
        
        lblRight.adjustsFontSizeToFitWidth = true
        lblLeft.adjustsFontSizeToFitWidth = true
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
        
        lblRight.addDropShadow(color: .black, opacity: Constants.veryLowShadowOpacity, offset: .zero, radius: 1)
        lblLeft.addDropShadow(color: .black, opacity: Constants.veryLowShadowOpacity, offset: .zero, radius: 1)
    }
    
    private func setFonts(){
        
        lblLeft.font = UIFont.catItemType
        lblRight.font = UIFont.catItemType
    }
}

extension DoubleItemImgCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewLeft.addDropShadow(color: .black, opacity: Constants.highShadowOpacity, offset: .zero, radius: 2)
        rightView.addDropShadow(color: .black, opacity: Constants.highShadowOpacity, offset: .zero, radius: 2)
    }
}

//MARK: Remove Views
extension DoubleItemImgCell{
    
    private func showRemoveViews(){
        viewRemoveContainer.alpha = 1
    }
    
    private func hideRemoveViews(){
        viewRemoveContainer.alpha = 0
    }
    
    private func hideWhiteEditBackground(){
        viewRemoveWhiteCover.alpha = 0
        hideRemoveViews()
    }
    
    private func showWhiteEditBackground(){
        viewRemoveWhiteCover.alpha = 0.5
        showRemoveViews()
    }
    
    private func showLeftRemove(){
        viewRemoveLeft.alpha = 1
        setRemoveGestureLeft()
    }
    
    private func hideLeftRemove(){
        viewRemoveLeft.alpha = 0
    }
    
    private func showRightRemove(){
        viewRemoveRight.alpha = 1
        setRemoveGestureRight()
    }
    
    private func hideRightRemove(){
        viewRemoveRight.alpha = 0
    }
    
    func setupRemoveViews(){
        
        if let leftGestRec = self.leftGestureRec{
            viewRemoveLeft.removeGestureRecognizer(leftGestRec)
        }
        if let rightGestRec = self.rightGestureRec{
            viewRemoveRight.removeGestureRecognizer(rightGestRec)
        }

        leftGestureRec = nil
        rightGestureRec = nil
        //Small view containing label and imgView
        viewRemoveLeft.clipsToBounds = true
        viewRemoveLeft.layer.cornerRadius = viewRemoveLeft.frame.size.height / 2.0
        
        viewRemoveRight.clipsToBounds = true
        viewRemoveRight.layer.cornerRadius = viewRemoveRight.frame.size.height / 2.0
        
        viewRemoveLeft.backgroundColor = .white
        viewRemoveRight.backgroundColor = .white
        
        
        //White background
        viewRemoveWhiteCover.alpha = 0
        viewRemoveWhiteCover.backgroundColor = .white
        
        viewRemoveContainer.alpha = 0
        viewRemoveContainer.backgroundColor = .clear
        
        
        lblRemoveRight.textColor = .colorGreyBrowse
        lblRemoveLeft.textColor = .colorGreyBrowse
        
        lblRemoveLeft.font = UIFont.favBtnRemove
        lblRemoveRight.font = UIFont.favBtnRemove
        
        viewRemoveLeft.addDropShadow(color: .black, opacity: Constants.veryLowShadowOpacity, offset: .zero, radius: 1)
        viewRemoveRight.addDropShadow(color: .black, opacity: Constants.veryLowShadowOpacity, offset: .zero, radius: 1)
        
    }
    
    private func setRemoveGestureLeft(){
        
        self.leftGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapLeft(_:)))
        guard let gestRec = self.leftGestureRec else { return }
        viewRemoveLeft.addGestureRecognizer(gestRec)
        viewRemoveLeft.isUserInteractionEnabled = true
    }
    
    private func setRemoveGestureRight(){
        
        self.rightGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapRight(_:)))
        guard let gestRec = self.rightGestureRec else { return }
        viewRemoveRight.addGestureRecognizer(gestRec)
        viewRemoveRight.isUserInteractionEnabled = true
    }
}

extension DoubleItemImgCell{
    
    @objc private func tapLeft(_ sender: UITapGestureRecognizer) {
        tappedLeft()
    }
    
    private func tappedLeft(){
        guard let leftName = leftItem?.itemName else {
            print("leftItem doesn't have name in DoubleItemImgCell")
            return
        }
        deleteClicked(deleteItemName: leftName)
    }

    @objc private func tapRight(_ sender: UITapGestureRecognizer) {
        tappedRight()
    }
    
    private func tappedRight(){
        guard let rightName = rightItem?.itemName else {
            print("rightItem doesn't have name in DoubleItemImgCell")
            return
        }
        deleteClicked(deleteItemName: rightName)
    }
}

extension DoubleItemImgCell: DeleteFavouriteItem{
    
    func deleteClicked(deleteItemName: String) {
        
        guard let delegate = deleteDelegate else {
            print("delete delegate not set in DoubleItemImgCell")
            return
        }
        delegate.deleteClicked(deleteItemName: deleteItemName)
    }
}
