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
import NVActivityIndicatorView

protocol BOAppHeaderViewDelegate: AnyObject {
    
    func didPressRightButton(shouldShowMenu: Bool)
    func didPressBackFromAppHeader()
}


class BOAppHeaderView: UIView {
    
    private let defaultImgWidth:CGFloat = 8
    private let hiddenImgWidth:CGFloat = 0
    
    //MARK: Properties
    @IBOutlet weak var imgLeftIcon: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var btnHamburger: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewBackBtn: UIView!
    @IBOutlet private weak var lblBackTitle: UILabel!
    @IBOutlet weak var imgViewBackBtn: UIImageView!
    
    @IBOutlet weak var viewLoader: NVActivityIndicatorView!
    
    @IBOutlet weak var cImgViewWidth: NSLayoutConstraint!
    
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
        
        setupLoader()
        setIcons()
        setText()
        setGestureRec()
    }
    
    private func setupLoader(){
        
        viewLoader.backgroundColor = .clear
        viewLoader.startAnimating()
        viewLoader.alpha = 0
        viewLoader.type = .lineScalePulseOutRapid
    }
    
    private func hideNonLoaderViews(){
        
        lblTitle.alpha = 0
        lblBackTitle.alpha = 0
        imgLeftIcon.alpha = 0
        btnHamburger.alpha = 0
    }
    
    private func showNonLoaderViews(){
    
        lblTitle.alpha = 1
        lblBackTitle.alpha = 1
        imgLeftIcon.alpha = 1
        btnHamburger.alpha = 1
    }
    
    private func showLoader(){
        
//        let lblHideDuration = 0.2
//        //let loaderDuration = 3
//
//        viewLoader.startAnimating()
//
//        UIView.animate(withDuration: lblHideDuration, animations: { [weak self] in
//            guard let this = self else { return }
//            this.hideNonLoaderViews()
//        }) { [weak self] (finished) in
//
//            guard let this = self else { return }
//
//            this.viewLoader.stopAnimating()
//        }
//
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
//
//            UIView.animate(withDuration: lblHideDuration, animations: { [weak self] in
//                guard let this = self else { return }
//                this.showNonLoaderViews()
//            }) { [weak self] (finished) in
//
//                guard let this = self else { return }
//
//                this.viewLoader.stopAnimating()
//            }
//        }
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
        imgViewBackBtn.setClipsAndScales()
        imgViewBackBtn.image = rotatedImg
    }
    
    private func styleView(){
        
        setupColors()
        setupFonts()
        showDefault()
        addShadow()
    }
    
    private func hideImgIcon(){
        imgLeftIcon.alpha = 0
    }
    
    func addShadow(){
        
        imgLeftIcon.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: CGSize(width: 1, height: 1), radius: 2)
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
        lblBackTitle.font = UIFont.backLblTitle
        
        lblBackTitle.adjustsFontSizeToFitWidth = true
        lblBackTitle.minimumScaleFactor = 0.5
        lblBackTitle.numberOfLines = 1
        lblBackTitle.lineBreakMode = .byClipping
    }
}

extension BOAppHeaderView{
    
    @objc func handleBackTap(_ sender: UITapGestureRecognizer) {
        
        print("back pressed")
        guard let delegate = delegate else {
            print("delegate for headerview not set while pressing back")
            return
        }
        delegate.didPressBackFromAppHeader()
        
    }
}

extension BOAppHeaderView{
    
    func setBindings(){
        
        _ = viewModel.isHamburgerActive.observeOn(.main).observeNext{ [weak self] value in
            
            guard let this = self else { return }
            
            if value{
                this.showDefault()
                return
            }
            this.animateToXIcon()
            this.animateToFavouriteTxt()
        }
        
        _ = viewModel.isDetailActive.observeOn(.main).observeNext{ [weak self] isDetailActiveValue in
            
            guard let this = self else { return }
            if isDetailActiveValue{
                this.showDetail(withDetailText: "")
                return
            }
            this.showDefault()
        }
    }
}

extension BOAppHeaderView{
    
    private func animateToHamburger(){
        
        self.layoutIfNeeded()
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
                            this.layoutIfNeeded()
            }, completion: {  finished in })
    }
    
    private func animateToXIcon(){
        
        self.layoutIfNeeded()
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
                            this.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func animateToFavouriteTxt(){
        
        self.showLoader()
        self.setNeedsLayout()
        UIView.transition(with: self.lblTitle,
                          duration: self.viewModel.btnAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            this.lblTitle.font = UIFont.guideHeadlineFav
                            this.lblTitle.text = "REYKJAVÍK GRAPEVINE"
                            this.view.layoutIfNeeded()
                            this.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func animateToNormalText(){
        
        self.showLoader()
        self.layoutIfNeeded()
        self.setNeedsLayout()
        UIView.transition(with: self.lblTitle,
                          duration: self.viewModel.btnAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            this.lblTitle.font = UIFont.guideHeadline
                            this.lblTitle.text = "BEST OF REYKJAVÍK"
                            this.view.layoutIfNeeded()
                            this.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func layoutViews(){
        
        self.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    private func setViewNeedsLayout(){
        
        self.setNeedsLayout()
        self.view.setNeedsLayout()
    }
    
    private func animateDetail(){
        
        showLoader()
        layoutViews()
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
                            this.cImgViewWidth.constant = this.defaultImgWidth
                            
                            this.roundCorners(corners: [.topLeft, .topRight], radius: 10)
                            
                            this.view.layoutIfNeeded()
                            this.layoutIfNeeded()
            }, completion: nil)
        
        setViewNeedsLayout()
        layoutViews()
    }
    
    private func animateDefault(){
        
        showLoader()
        setViewNeedsLayout()
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
                            
                            this.cImgViewWidth.constant = this.defaultImgWidth
                            
                            this.view.layoutIfNeeded()
                            this.layoutIfNeeded()
            }, completion: nil)
        
    }
}

extension BOAppHeaderView{
    
    func showSeperator(){
        
    }
    
    func showDetail(withDetailText: String){
        
        showSeperator()
        setDetailText(strText: withDetailText)
        setCornerRadiusForDetail()
        animateDetail()
    }
    
    private func setDetailText(strText: String){
        if strText.count == 0 { return }
        lblBackTitle.text = strText
    }
    
    private func setCornerRadiusForDetail(){
        self.view.clipsToBounds = true
        clipsToBounds = true
        
        self.view.layer.cornerRadius = Constants.appHeaderCornerRadius
        self.view.layer.cornerRadius = Constants.appHeaderCornerRadius
    }
    
    private func setupImgViewDefault(){
        
        cImgViewWidth.constant = defaultImgWidth
    }
    
    private func setupImgViewHidden(){
        cImgViewWidth.constant = hiddenImgWidth
    }
    
    private func showDefault(){
        
        animateDefault()
        animateToHamburger()
        animateToNormalText()
    }
    
    func setTitleText(text: String){
        lblTitle.text = text
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

extension BOAppHeaderView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.view.layoutIfNeeded()
        
        addShadow()
    }
}
