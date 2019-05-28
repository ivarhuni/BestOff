//
//  BOMenuView.swift
//  BestOff
//
//  Created by Ivar Johannesson on 08/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit

protocol MenuViewClick: class{
    
    func rvkClicked()
    func iceClicked()
    func favClicked()
}

class BOMenuView: UIView{
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var viewReykjavik: UIView!
    @IBOutlet weak var viewSelRvk: UIView!
    @IBOutlet weak var imgViewRvk: UIImageView!
    @IBOutlet weak var lblRvk: UILabel!
    
    @IBOutlet weak var viewIceland: UIView!
    @IBOutlet weak var viewSelIceland: UIView!
    @IBOutlet weak var imgViewIceland: UIImageView!
    @IBOutlet weak var lblIceland: UILabel!
    
    @IBOutlet weak var viewFavourites: UIView!
    @IBOutlet weak var viewSelFavourites: UIView!
    @IBOutlet weak var imgViewFavourites: UIImageView!
    @IBOutlet weak var lblFavourites: UILabel!
    
    @IBOutlet weak var leadingSelectionRvk: NSLayoutConstraint!
    @IBOutlet weak var leadingSelectionIce: NSLayoutConstraint!
    @IBOutlet weak var leadingSelFav: NSLayoutConstraint!
    @IBOutlet weak var leadingImgRvk: NSLayoutConstraint!
    @IBOutlet weak var leadingImgIce: NSLayoutConstraint!
    @IBOutlet weak var leadingImgFav: NSLayoutConstraint!
    @IBOutlet weak var leadingLblRvk: NSLayoutConstraint!
    @IBOutlet weak var leadingLblIce: NSLayoutConstraint!
    @IBOutlet weak var leadingLblFav: NSLayoutConstraint!
    
    
    
    weak var menuViewClickDelegate: MenuViewClick?
    
    
    private var viewModel: BOMenuViewModel
    
    //MARK: Init, viewcycle
    override init(frame: CGRect) {
        
        viewModel = BOMenuViewModel(withSelectedScreen: .reykjavik)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        viewModel = BOMenuViewModel(withSelectedScreen: .reykjavik)
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        initView()
        setupView()
    }
}

//MARK: XIB Setup
extension BOMenuView{
    
    private func initView(){
        
        Bundle.main.loadNibNamed("BOMenuView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupView(){
        
        style()
        setBindings()
        setupChildViews()
        setupGestureRec()
    }
    
    func setupChildViews(){
        imgViewRvk.image = Asset.hallgrimskirkja.img
        imgViewIceland.image = Asset.Iceland.img
        imgViewFavourites.image = Asset.heart.img
        
        lblRvk.text = "BEST OF REYKJAVÍK"
        lblIceland.text = "BEST OF ICELAND"
        lblFavourites.text = "FAVOURITES"
        
        lblRvk.font = UIFont.favouriteOn
        lblIceland.font = UIFont.favouriteOff
        lblFavourites.font = UIFont.favouriteOff
    }
    
    func style(){
        
        self.view.backgroundColor = .colorRed
        viewReykjavik.backgroundColor = .colorRed
        viewIceland.backgroundColor = .colorRed
        viewFavourites.backgroundColor = .colorRed
        
        lblRvk.textColor = .white
        lblIceland.textColor = .white
        lblFavourites.textColor = .white
    }
}

//MARK: Gesture Recognizers
extension BOMenuView{
    
    func setupGestureRec(){
        
        let rvkTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapRvk(_:)))
        viewReykjavik.addGestureRecognizer(rvkTap)
        viewReykjavik.isUserInteractionEnabled = true
        
        let iceTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapIce(_:)))
        viewIceland.addGestureRecognizer(iceTap)
        viewIceland.isUserInteractionEnabled = true
        
        let favTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFav(_:)))
        viewFavourites.addGestureRecognizer(favTap)
        viewFavourites.isUserInteractionEnabled = true
    }
}

//MARK: tap handlers
extension BOMenuView{
    
    @objc private func handleTapRvk(_ sender: UITapGestureRecognizer) {
        
        viewModel.select(screenType: .reykjavik)
    }
    
    @objc private func handleTapIce(_ sender: UITapGestureRecognizer) {
        
        viewModel.select(screenType: .iceland)
    }
    
    @objc private func handleTapFav(_ sender: UITapGestureRecognizer) {
        
        viewModel.select(screenType: .favourites)
    }
}

//MARK: MenuViewDelegate
extension BOMenuView: MenuViewClick{
    
    func rvkClicked() {
        
        guard let delegate = menuViewClickDelegate else {
            
            print("delegate not set for menuviewclick delegate")
            return
        }
        delegate.rvkClicked()
    }
    
    func iceClicked() {
        
        guard let delegate = menuViewClickDelegate else {
            
            print("delegate not set for menuviewclick delegate")
            return
        }
        delegate.iceClicked()
    }
    
    func favClicked() {
        guard let delegate = menuViewClickDelegate else {
            
            print("delegate not set for menuviewclick delegate")
            return
        }
        delegate.favClicked()
    }
}

//MARK: Public methods
extension BOMenuView{
    
    public func setupWithType(screenType: ScreenType){
        viewModel.selectedScreenType.value = screenType
    }
}

//MARK: UI Bindings
extension BOMenuView{
    
    private func setBindings(){
        
        _ = viewModel.selectedScreenType.observeOn(.main).observeNext{ [weak self] selectedType in
            guard let this = self else { return }
            
            this.animateSelectionForScreenType(screenType: selectedType)
        }
    }
}
//MARK: Action methods
extension BOMenuView{
    
    private func styleViewFor(screenType: ScreenType){
        
        switch screenType {
            
        case .reykjavik:
            styleLabelsForReykjavik()
            
        case .iceland:
            styleLabelsForIceland()
            
        case .favourites:
            styleLabelsFav()
        }
    }
    
    private func animateSelectionForScreenType(screenType: ScreenType){
        
        self.view.layoutIfNeeded()
        
        switch screenType {
        case .reykjavik:
            
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsReykjavik()
                this.styleViewFor(screenType: screenType)
                this.view.layoutIfNeeded()
                
            }) {[weak self] finished in
                guard let this = self else { return }
                this.rvkClicked()
            }
            
        case .iceland:
            
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsIceland()
                this.styleViewFor(screenType: screenType)
                this.view.layoutIfNeeded()
                
            }) { [weak self] finished in
                
                guard let this = self else { return }
                this.iceClicked()
            }
            
        case .favourites:
            
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsFav()
                this.styleViewFor(screenType: screenType)
                this.view.layoutIfNeeded()
                
            }) { [weak self] finished in
                
                guard let this = self else { return }
                this.favClicked()
            }
        }
    }

    private func styleLabelsFav(){
        
        lblFavourites.font = UIFont.favouriteOn
        lblIceland.font = UIFont.favouriteOff
        lblRvk.font = UIFont.favouriteOff
        leadingSelectionRvk.constant = viewModel.leadingConstantOff
        leadingSelFav.constant = viewModel.leadingConstantOn
        leadingSelectionIce.constant = viewModel.leadingConstantOff
        
        lblRvk.layer.shadowOpacity = 0
        lblIceland.layer.shadowOpacity = 0
        lblFavourites.layer.shadowOpacity = Constants.lowShadowOpacity
    }
    
    private func styleLabelsForIceland(){
        
        lblIceland.font = UIFont.favouriteOn
        lblRvk.font = UIFont.favouriteOff
        lblFavourites.font = UIFont.favouriteOff
        leadingSelectionRvk.constant = viewModel.leadingConstantOff
        leadingSelFav.constant = viewModel.leadingConstantOff
        leadingSelectionIce.constant = viewModel.leadingConstantOn
        
        lblRvk.layer.shadowOpacity = 0
        lblIceland.layer.shadowOpacity = Constants.lowShadowOpacity
        lblFavourites.layer.shadowOpacity = 0
    }
    
    private func styleLabelsForReykjavik(){
        
        lblRvk.font = UIFont.favouriteOn
        lblFavourites.font = UIFont.favouriteOff
        lblIceland.font = UIFont.favouriteOff
        leadingSelectionRvk.constant = viewModel.leadingConstantOn
        leadingSelFav.constant = viewModel.leadingConstantOff
        leadingSelectionIce.constant = viewModel.leadingConstantOff
        
        lblRvk.layer.shadowOpacity = Constants.lowShadowOpacity
        lblIceland.layer.shadowOpacity = 0
        lblFavourites.layer.shadowOpacity = 0
    }
    
    
    
    private func configureConstantsFav(){
        
        self.leadingSelectionRvk.constant = self.viewModel.leadingConstantOff
        self.leadingSelFav.constant = self.viewModel.leadingConstantOn
        self.leadingSelectionIce.constant = self.viewModel.leadingConstantOff
        
        self.leadingImgRvk.constant = self.viewModel.leadingImgConstantOff
        self.leadingImgIce.constant = self.viewModel.leadingImgConstantOff
        self.leadingImgFav.constant = self.viewModel.leadingImgConstantOn
        
        self.leadingLblRvk.constant = self.viewModel.leadingLblConstantOff
        self.leadingLblIce.constant = self.viewModel.leadingLblConstantOff
        self.leadingLblFav.constant = self.viewModel.leadingLblConstantOn
    }
    
    private func configureConstantsIceland(){
        
        self.leadingSelectionRvk.constant = self.viewModel.leadingConstantOff
        self.leadingSelFav.constant = self.viewModel.leadingConstantOff
        self.leadingSelectionIce.constant = self.viewModel.leadingConstantOn
        
        self.leadingImgRvk.constant = self.viewModel.leadingImgConstantOff
        self.leadingImgIce.constant = self.viewModel.leadingImgConstantOn
        self.leadingImgFav.constant = self.viewModel.leadingImgConstantOff
        
        self.leadingLblRvk.constant = self.viewModel.leadingLblConstantOff
        self.leadingLblIce.constant = self.viewModel.leadingLblConstantOn
        self.leadingLblFav.constant = self.viewModel.leadingLblConstantOff
    }
    
    private func configureConstantsReykjavik(){
        
        self.leadingSelectionRvk.constant = self.viewModel.leadingConstantOn
        self.leadingSelFav.constant = self.viewModel.leadingConstantOff
        self.leadingSelectionIce.constant = self.viewModel.leadingConstantOff
        
        self.leadingImgRvk.constant = self.viewModel.leadingImgConstantOn
        self.leadingImgIce.constant = self.viewModel.leadingImgConstantOff
        self.leadingImgFav.constant = self.viewModel.leadingImgConstantOff
        
        self.leadingLblRvk.constant = self.viewModel.leadingLblConstantOn
        self.leadingLblIce.constant = self.viewModel.leadingLblConstantOff
        self.leadingLblFav.constant = self.viewModel.leadingLblConstantOff
    }
}



extension BOMenuView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadows()
    }
    
    func addShadows(){
  
        lblRvk.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: CGSize(width: 1, height: 1), radius: 2)
        lblIceland.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: CGSize(width: 1, height: 1), radius: 2)
        lblFavourites.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: CGSize(width: 1, height: 1), radius: 2)
    }
}
