//
//  BOTableViewHeader.swift
//  BestOff
//
//  Created by Ivar Johannesson on 30/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

protocol BOAppHeaderViewDelegate: AnyObject {
    
    func didPressRightButton(shouldShowMenu: Bool)
    func didPressBack()
}


class BOAppHeaderView: UIView {
    
    //MARK: Properties
    @IBOutlet weak var imgLeftIcon: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var btnHamburger: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewBackBtn: UIView!
    @IBOutlet weak var lblBackTitle: UILabel!
    @IBOutlet weak var imgViewBackBtn: UIImageView!
    
    
    //MARK: Properties
    let viewModel = BOHeaderViewModel()
    
    //MARK: Button Delegate
    weak var delegate:BOAppHeaderViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        initView()
        setupViewDefault()
        styleView()
        setBindings()
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        guard let btnDelegate = self.delegate else {
            
            print("Button Header Delegate Not Set")
            return
        }
        
        self.viewModel.didPressRightButton()
        btnDelegate.didPressRightButton(shouldShowMenu: !self.viewModel.isHamburgerActive.value)
    }
    
}

//MARK: View Setup
extension BOAppHeaderView{
    
    private func initView(){
        
        Bundle.main.loadNibNamed("BOTableViewHeader", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupViewDefault(){
        
        setIcons()
        setText()
        setGestureRec()
    }
    
    private func setGestureRec(){
    
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackTap(_:)))
        viewBackBtn.addGestureRecognizer(backTap)
        viewBackBtn.isUserInteractionEnabled = true
    }
    
    private func setText(){
        lblTitle.text = "BEST OF REYKJAVÍK"
        btnHamburger.setTitle("", for: .normal)
        lblBackTitle.text = ""
    }
    
    private func setIcons(){
        
        imgLeftIcon.image = Asset.grapevineIcon.img
        btnHamburger.setBackgroundImage(Asset.hamburger.img, for: .normal)
        
        //ViewBack
        let arrow = Asset.arrowGray.img
        guard let cgArrowImg = arrow.cgImage else { return }
        let rotatedImg = UIImage(cgImage: cgArrowImg, scale: 1.0, orientation: .left)
        imgViewBackBtn.contentMode = .scaleAspectFill
        imgViewBackBtn.image = rotatedImg
    }
    
    private func styleView(){
        
        setupColors()
        setupFonts()
        showDefault()
    }
    
    func setupColors(){
        
        self.view.backgroundColor = .colorRed
        
        btnHamburger.alpha = viewModel.btnAlphaValue
        btnHamburger.setTitleColor(.colorWhite, for: .normal)
        
        lblTitle.textColor = .white
        lblBackTitle.textColor = .black
    }
    
    private func setupFonts(){
        
        lblTitle.font = UIFont.guideHeadline
        lblBackTitle.font = UIFont.itemTitle
    }
}

extension BOAppHeaderView{
    
    @objc func handleBackTap(_ sender: UITapGestureRecognizer) {
        
        guard let delegate = delegate else {
            print("delegate for headerview not set while pressing back")
            return
        }
        delegate.didPressBack()
    }
}

extension BOAppHeaderView{
    
    func setBindings(){
        
        _ = viewModel.isHamburgerActive.observeOn(.main).observeNext{ value in
            
            
            if value{
                self.animateToHamburger()
                self.animateToNormalText()
                return
            }
            
            self.animateToXIcon()
            self.animateToFavouriteTxt()
        }
        
        _ = viewModel.isDetailActive.observeOn(.main).observeNext{ [weak self] isDetailActiveValue in
            
            guard let this = self else { return }
            if isDetailActiveValue{
                
                this.showDetail()
                return
            }
            this.showDefault()
        }
    }
    
}

extension BOAppHeaderView{
    
    func animateToHamburger(){
        
        self.setNeedsLayout()
        UIView.transition(with: self.btnHamburger,
                          duration: self.viewModel.btnAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            this.btnHamburger.setBackgroundImage(Asset.hamburger.img, for: .normal)
                            this.btnWidth.constant = this.viewModel.originalBtnWidthHeight
                            this.btnHeight.constant = this.viewModel.originalBtnWidthHeight
                            this.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func animateToXIcon(){
        
        self.setNeedsLayout()
        UIView.transition(with: self.btnHamburger,
                          duration: self.viewModel.btnAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            this.btnHamburger.setBackgroundImage(Asset.xIcon.img, for: .normal)
                            this.btnWidth.constant = this.viewModel.xIconWidthHeight
                            this.btnHeight.constant = this.viewModel.xIconWidthHeight
                            this.view.layoutIfNeeded()
                            
            }, completion: nil)
    }
    
    func animateToFavouriteTxt(){
        
        UIView.transition(with: self.lblTitle,
                          duration: self.viewModel.btnAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            this.lblTitle.font = UIFont.guideHeadlineFav
                            this.lblTitle.text = "REYKJAVÍK GRAPEVINE"
            }, completion: nil)
    }
    
    func animateToNormalText(){
        
        
        UIView.transition(with: self.lblTitle,
                          duration: self.viewModel.btnAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            this.lblTitle.font = UIFont.guideHeadline
                            this.lblTitle.text = "BEST OF REYKJAVÍK"
            }, completion: nil)
    }
}

extension BOAppHeaderView{
    
    func showDetail(){
        
        setupTextForDetail()
        setCornerRadiusForDetail()
        layoutIfNeeded()
        UIView.transition(with: self,
                          duration: self.viewModel.btnAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                           
                            this.imgLeftIcon.isHidden = true
                            this.lblTitle.isHidden = true
                            
                            this.viewBackBtn.isHidden = false
                            
                            this.btnHamburger.isHidden = false
                            
                            this.view.backgroundColor = .white
                            this.backgroundColor = .white
                            
                            this.roundCorners(corners: [.topLeft, .topRight], radius: 10)
                            
                            this.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func setCornerRadiusForDetail(){
        self.view.clipsToBounds = true
        clipsToBounds = true
        
        self.view.layer.cornerRadius = 10
        self.view.layer.cornerRadius = 10
    }
    
    func setupTextForDetail(){
        lblBackTitle.text = "GUIDES"
    }
    
    func showDefault(){
        
        layoutIfNeeded()
        UIView.transition(with: self,
                          duration: self.viewModel.btnAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            
                            this.imgLeftIcon.isHidden = false
                            this.lblTitle.isHidden = false
                            this.btnHamburger.isHidden = false
                            
                            this.viewBackBtn.isHidden = true
                            this.view.backgroundColor = .colorRed
                            this.backgroundColor = .colorRed
                            
                            this.view.layoutIfNeeded()
            }, completion: nil)
        

    }
}


extension UIView{
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
