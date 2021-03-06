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
    func subCatClicked()
    func eventsClicked()
}

class BOMenuView: UIView{
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var viewReykjavik: UIView!
    @IBOutlet weak var viewSelRvk: UIView!
    @IBOutlet weak var viewEvents: UIView!
    
    @IBOutlet weak var imgViewRvk: UIImageView!
    @IBOutlet weak var lblRvk: UILabel!
    @IBOutlet weak var imgViewEvents: UIImageView!
    @IBOutlet weak var lblEvents: UILabel!
    
    @IBOutlet weak var viewIceland: UIView!
    @IBOutlet weak var viewSelIceland: UIView!
    @IBOutlet weak var viewSelEvents: UIView!
    @IBOutlet weak var imgViewIceland: UIImageView!
    @IBOutlet weak var lblIceland: UILabel!
    
    @IBOutlet weak var viewFavourites: UIView!
    @IBOutlet weak var viewSelFavourites: UIView!
    @IBOutlet weak var imgViewFavourites: UIImageView!
    @IBOutlet weak var lblFavourites: UILabel!
    
    @IBOutlet weak var leadingSelectionRvk: NSLayoutConstraint!
    @IBOutlet weak var leadingSelectionIce: NSLayoutConstraint!
    @IBOutlet weak var leadingSelFav: NSLayoutConstraint!
    @IBOutlet weak var leadingSelEvents: NSLayoutConstraint!
    
    
    @IBOutlet weak var leadingImgRvk: NSLayoutConstraint!
    @IBOutlet weak var leadingImgIce: NSLayoutConstraint!
    @IBOutlet weak var leadingImgFav: NSLayoutConstraint!
    @IBOutlet weak var leadingImgEvents: NSLayoutConstraint!
    
    @IBOutlet weak var leadingLblEvents: NSLayoutConstraint!
    @IBOutlet weak var leadingLblRvk: NSLayoutConstraint!
    @IBOutlet weak var leadingLblIce: NSLayoutConstraint!
    @IBOutlet weak var leadingLblFav: NSLayoutConstraint!
    
    weak var menuViewClickDelegate: MenuViewClick?
    
    private var viewModel: BOMenuViewModel
    
    //MARK: Init, viewcycle
    override init(frame: CGRect) {
        
        viewModel = BOMenuViewModel(withSelectedScreen: .guides)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        viewModel = BOMenuViewModel(withSelectedScreen: .guides)
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
        let eventImage = Asset.event.img.withRenderingMode(.alwaysTemplate)
        imgViewEvents.image = eventImage
        imgViewEvents.tintColor = .white
        
        lblRvk.text = "BEST OF REYKJAVÍK"
        lblIceland.text = "BEST OF ICELAND"
        lblFavourites.text = "FAVOURITES"
        lblEvents.text = "EVENTS"
        
        lblRvk.font = UIFont.favouriteOn
        lblIceland.font = UIFont.favouriteOff
        lblFavourites.font = UIFont.favouriteOff
        lblEvents.font = UIFont.favouriteOff
    }
    
    func style(){
        
        self.view.backgroundColor = .colorRed
        viewReykjavik.backgroundColor = .colorRed
        viewIceland.backgroundColor = .colorRed
        viewFavourites.backgroundColor = .colorRed
        viewEvents.backgroundColor = .colorRed
        
        lblRvk.textColor = .white
        lblIceland.textColor = .white
        lblEvents.textColor = .white
        lblFavourites.textColor = .white
    }
}

//MARK: Gesture Recognizers
extension BOMenuView{
    
    func setupGestureRec(){
        
        let rvkTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapRvk(_:)))
        viewReykjavik.addGestureRecognizer(rvkTap)
        viewReykjavik.isUserInteractionEnabled = true
        
        let eventTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapEvents(_:)))
        viewEvents.addGestureRecognizer(eventTap)
        viewEvents.isUserInteractionEnabled = true
        
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
    
    @objc private func handleTapEvents(_ sender: UITapGestureRecognizer) {
        
        viewModel.select(screenType: .events)
    }
    
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
    
    func eventsClicked() {
        guard let delegate = menuViewClickDelegate else {
            
            print("delegate not set for menuviewclick delegate")
            return
        }
        delegate.eventsClicked()
    }
    
    
    func rvkClicked() {
        
        guard let delegate = menuViewClickDelegate else {
            
            print("delegate not set for menuviewclick delegate")
            return
        }
        delegate.rvkClicked()
    }
    
    func subCatClicked(){
        guard let delegate = menuViewClickDelegate else {
            
            print("delegate not set for menuviewclick delegate")
            return
        }
        delegate.subCatClicked()
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
    
    public func setupWithType(screenType: ContentType){
        viewModel.selectedScreenType.value = screenType
    }
}

//MARK: UI Bindings
extension BOMenuView{
    
    private func setBindings(){
        
        _ = viewModel.selectedScreenType.observeOn(.main).observeNext{ [weak self] selectedType in
            guard let this = self else { return }
            
            this.animateSelectionForScreenType(contentType: selectedType)
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
            
        case .events:
            styleLabelsEvents()
        }
    }
    
    private func animateSelectionForScreenType(contentType: ContentType){
        
        self.view.layoutIfNeeded()
        
        switch contentType {
        case .iceland:
            
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsIceland()
                this.styleViewFor(screenType: .iceland)
                this.view.layoutIfNeeded()
                
            }) { [weak self] finished in
                
                guard let this = self else { return }
                this.iceClicked()
            }
            
        case .favourites:
            
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsFav()
                this.styleViewFor(screenType: .favourites)
                this.view.layoutIfNeeded()
                
            }) { [weak self] finished in
                
                guard let this = self else { return }
                this.favClicked()
            }
        case .guides:
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsReykjavik()
                this.styleViewFor(screenType: .reykjavik)
                this.view.layoutIfNeeded()
                
            }) {[weak self] finished in
                guard let this = self else { return }
                this.rvkClicked()
            }
        case .reykjavik:
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsReykjavik()
                this.styleViewFor(screenType: .reykjavik)
                this.view.layoutIfNeeded()
                
            }) {[weak self] finished in
                guard let this = self else { return }
                this.rvkClicked()
            }
        case .subCategoriesRvk:
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsReykjavik()
                this.styleViewFor(screenType: .reykjavik)
                this.view.layoutIfNeeded()
                
            }) {[weak self] finished in
                guard let this = self else { return }
                this.subCatClicked()
            }
        case .subCategoriesIce:
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsIceland()
                this.styleViewFor(screenType: .iceland)
                this.view.layoutIfNeeded()
                
            }) {[weak self] finished in
                guard let this = self else { return }
                this.subCatClicked()
            }
        case .events:
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsEvents()
                this.styleViewFor(screenType: .events)
                this.view.layoutIfNeeded()
                
            }) { [weak self] finished in
                
                guard let this = self else { return }
                this.eventsClicked()
            }
            
            
        default:
            
            UIView.animate(withDuration: viewModel.animationDuration, animations: { [weak self] in
                
                guard let this = self else { return }
                
                this.configureConstantsReykjavik()
                this.styleViewFor(screenType: .reykjavik)
                this.view.layoutIfNeeded()
                
            }) {[weak self] finished in
                guard let this = self else { return }
                this.rvkClicked()
            }
            
        }
    }
    
    private func styleLabelsEvents(){
        
        lblFavourites.font = UIFont.favouriteOff
        lblIceland.font = UIFont.favouriteOff
        lblRvk.font = UIFont.favouriteOff
        lblEvents.font = UIFont.favouriteOn
        
        leadingSelectionRvk.constant = viewModel.leadingConstantOff
        leadingSelFav.constant = viewModel.leadingConstantOff
        leadingSelectionIce.constant = viewModel.leadingConstantOff
        leadingSelEvents.constant = viewModel.leadingConstantOn
        
        lblRvk.layer.shadowOpacity = 0
        lblIceland.layer.shadowOpacity = 0
        lblFavourites.layer.shadowOpacity = 0
        lblEvents.layer.shadowOpacity = Constants.lowShadowOpacity
    }

    private func styleLabelsFav(){
        
        lblFavourites.font = UIFont.favouriteOn
        lblIceland.font = UIFont.favouriteOff
        lblRvk.font = UIFont.favouriteOff
        
        lblEvents.font = UIFont.favouriteOff
        lblEvents.layer.shadowOpacity = 0
        leadingSelEvents.constant = viewModel.leadingConstantOff
       
        leadingSelectionRvk.constant = viewModel.leadingConstantOff
        leadingSelFav.constant = viewModel.leadingConstantOn
        leadingSelectionIce.constant = viewModel.leadingConstantOff
        
        lblRvk.layer.shadowOpacity = 0
        lblIceland.layer.shadowOpacity = 0
        lblEvents.layer.shadowOpacity = 0
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
        
        lblEvents.font = UIFont.favouriteOff
        lblEvents.layer.shadowOpacity = 0
        leadingSelEvents.constant = viewModel.leadingConstantOff
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
        
        lblEvents.font = UIFont.favouriteOff
        lblEvents.layer.shadowOpacity = 0
        leadingSelEvents.constant = viewModel.leadingConstantOff
    }
    
    private func configureConstantsEvents(){
        
        self.leadingSelectionRvk.constant = self.viewModel.leadingConstantOff
        self.leadingSelFav.constant = self.viewModel.leadingConstantOff
        self.leadingSelectionIce.constant = self.viewModel.leadingConstantOff
        
        self.leadingSelEvents.constant = self.viewModel.leadingConstantOn
        self.leadingImgEvents.constant = self.viewModel.leadingImgConstantOn
        self.leadingLblEvents.constant = self.viewModel.leadingLblConstantOn
        
        self.leadingImgRvk.constant = self.viewModel.leadingImgConstantOff
        self.leadingImgIce.constant = self.viewModel.leadingImgConstantOff
        self.leadingImgFav.constant = self.viewModel.leadingImgConstantOff
        
        self.leadingLblRvk.constant = self.viewModel.leadingLblConstantOff
        self.leadingLblIce.constant = self.viewModel.leadingLblConstantOff
        self.leadingLblFav.constant = self.viewModel.leadingLblConstantOff
    }
    
    private func configureConstantsFav(){
        
        self.leadingSelectionRvk.constant = self.viewModel.leadingConstantOff
        self.leadingSelFav.constant = self.viewModel.leadingConstantOn
        self.leadingSelectionIce.constant = self.viewModel.leadingConstantOff
        
        self.leadingSelEvents.constant = self.viewModel.leadingConstantOff
        self.leadingImgEvents.constant = self.viewModel.leadingImgConstantOff
        self.leadingLblEvents.constant = self.viewModel.leadingLblConstantOff
        
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
        
        self.leadingSelEvents.constant = self.viewModel.leadingConstantOff
        self.leadingImgEvents.constant = self.viewModel.leadingImgConstantOff
        self.leadingLblEvents.constant = self.viewModel.leadingLblConstantOff
        
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
        
        self.leadingSelEvents.constant = self.viewModel.leadingConstantOff
        self.leadingImgEvents.constant = self.viewModel.leadingImgConstantOff
        self.leadingLblEvents.constant = self.viewModel.leadingLblConstantOff
        
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
