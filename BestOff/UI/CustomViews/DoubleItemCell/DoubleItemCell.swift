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
    
    private var leftItem: BOCatItem?
    private var rightItem: BOCatItem?
    
    weak var onPressDelegate: DoubleCellPressed?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


protocol DoubleCellPressed: AnyObject {
    
    func doubleCellPressed(item: BOCatItem)
}

extension DoubleItemCell: DoubleCellPressed{
    
    func doubleCellPressed(item: BOCatItem){
        
        guard let delegate = onPressDelegate else {
            print("Delegate not set for doubleitemcell")
            return
        }
        
        delegate.doubleCellPressed(item: item)
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
        setDropShadow()
    }
    
    func setDropShadow(){
        viewBgLeft.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: .zero, radius: 3)
        viewBgRight.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: .zero, radius: 3)
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
    
    func setupWithItems(arrItems: [BOCatItem], onPressDelegate: DoubleCellPressed){
        
        disableSelection()
        styleBackgroundViews()
        setupLabels()
        setupImgViews()
        
        self.onPressDelegate = onPressDelegate
        
        guard let leftItem = arrItems[safe: 0] else { return }
        setupWithLeftItem(item: leftItem)
        
        guard let rightItem = arrItems[safe: 1] else { return }
        setupWithRightItem(item: rightItem)
    
     }
    
    private func disableSelection(){
        self.selectionStyle = .none
    }
    
    private func setupImgViews(){
        
        imgViewAuthorRight.setClipsAndScales()
        imgViewAuthorLeft.setClipsAndScales()
        
        imgViewRight.setClipsAndScales()
        imgViewLeft.setClipsAndScales()
    }
    
    private func styleBackgroundViews(){
        
        let bgAlpha:CGFloat = 0.2
        viewBgLeft.backgroundColor = .black
        viewBgRight.backgroundColor = .black
        
        viewBgRight.alpha = bgAlpha
        viewBgLeft.alpha = bgAlpha
    }
    
    private func setupLabels(){
        
        setupFonts()
        setupLabelScalingForLabel(label: lblLeft)
        setupLabelScalingForLabel(label: lblRight)
    }
    
    private func setupLabelScalingForLabel(label: UILabel){
        
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
    }
    
    private func setupFonts(){
        
        lblLeft.textColor = .colorBlackText
        lblRight.textColor = .colorBlackText
        lblLeftAuthor.textColor = .white
        lblRightAuthor.textColor = .white
        
        lblLeft.font = UIFont.guideItem
        lblRight.font = UIFont.guideItem
        lblRightAuthor.font = UIFont.authorName
        lblLeftAuthor.font = UIFont.authorName
    }
}

//MARK: Left item
extension DoubleItemCell{
    
    private func setupWithLeftItem(item: BOCatItem){
        
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewAuthorLeft, strURL: item.author.avatar)
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewLeft, strURL: item.image)
        
        lblLeftAuthor.text = item.author.name
        lblLeft.text = item.title
        
        leftItem = item
        setupTapGestureForLeftView()
        clearRight()
    }
    
    private func clearRight(){
        lblRight.text = ""
        imgViewRight.image = nil
        lblRightAuthor.text = ""
        imgViewAuthorRight.image = nil
    }

}

extension DoubleItemCell{
    
    private func setupWithRightItem(item: BOCatItem){
        
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewAuthorRight, strURL: item.author.avatar)
        UIImageView.setSDImageViewImageWithURL(imageView: imgViewRight, strURL: item.image)
        
        lblRightAuthor.text = item.author.name
        lblRight.text = item.title
        
        rightItem = item
        setupTapGestureForRightView()
    }
}

extension DoubleItemCell{
    
    func setupTapGestureForLeftView(){
        
        guard let leftView = leftView else { return }
        
        BOGuideViewController.clearGestureRecForView(view: leftView)
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnLeftView(_:)))
        leftView.addGestureRecognizer(leftTap)
        leftView.isUserInteractionEnabled = true
    }
    
    func setupTapGestureForRightView(){
        
        guard let rightView = rightView else { return }
        
        BOGuideViewController.clearGestureRecForView(view: rightView)
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnRightView(_:)))
        rightView.addGestureRecognizer(rightTap)
        rightView.isUserInteractionEnabled = true
    }
    
    @objc func handleTapOnLeftView(_ sender: UITapGestureRecognizer) {
        
        guard let itemLeft = self.leftItem else { return }
        doubleCellPressed(item: itemLeft)
    }
    
    @objc func handleTapOnRightView(_ sender: UITapGestureRecognizer) {
        
        guard let itemRight = self.rightItem else { return }
        doubleCellPressed(item: itemRight)
    }
}
