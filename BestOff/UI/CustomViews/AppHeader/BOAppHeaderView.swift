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
}

class BOAppHeaderView: UIView {
    
    //MARK: Properties
    @IBOutlet weak var imgLeftIcon: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var btnHamburger: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    

    
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
        setupView()
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
    
    private func setupView(){
        
        setIcons()
        setText()
    }
    
    private func setText(){
        lblTitle.text = "BEST OF REYKJAVÍK"
        btnHamburger.setTitle("", for: .normal)
    }
    
    private func setIcons(){
        
        imgLeftIcon.image = Asset.grapevineIcon.img
        btnHamburger.setBackgroundImage(Asset.hamburger.img, for: .normal)
    }
    
    private func styleView(){
        
        setupColors()
        setupFonts()
    }
    
    func setupColors(){
        
        self.view.backgroundColor = .colorRed
        
        btnHamburger.alpha = viewModel.btnAlphaValue
        btnHamburger.setTitleColor(.colorWhite, for: .normal)
        
        lblTitle.textColor = .white
    }
    
    private func setupFonts(){
        
        lblTitle.font = UIFont.guideHeadline
    }
}

extension BOAppHeaderView{
    
    func setBindings(){
        
        _ = viewModel.isHamburgerActive.observeOn(.main).observeNext{ value in
            
            if value{
                self.animateToHamburger()
                self.animateToNormalText()
            }
            else{
                self.animateToXIcon()
                self.animateToFavouriteTxt()
            }
        }
    }
    
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
