//
//  BOMenuView.swift
//  BestOff
//
//  Created by Ivar Johannesson on 08/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit

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
    
    private var viewModel: BOMenuViewModel
    
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
    
    func commonInit(){
        initView()
        setupView()
    }
}

extension BOMenuView{
    
    private func initView(){
        
        Bundle.main.loadNibNamed("BOMenuView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    }
    
    func setupView(){
        
        setBindings()
        styleDefault()
        setupChildViews()
        
    }
    
    func styleFor(screenType: ScreenType){
        
        switch screenType {
        
        case .reykjavik:
            
        
        case .iceland:
            
        case .favourites:
            
        }
    }
    
    func styleViewFor(screenType: ScreenType){
        
        switch screenType {
            
        case .reykjavik:
            lblRvk.font = UIFont.favouriteOn
            lblFavourites.font = UIFont.favouriteOff
            lblIceland.font = UIFont.favouriteOff
            
        case .iceland:
            lblIceland.font = UIFont.favouriteOn
            lblRvk.font = UIFont.favouriteOff
            lblFavourites.font = UIFont.favouriteOff
            
        case .favourites:
            lblFavourites.font = UIFont.favouriteOn
            lblIceland.font = UIFont.favouriteOff
            lblRvk.font = UIFont.favouriteOff
        }
    }
    
    func setupChildViews(){
        imgViewRvk.image = Asset.hallgrimskirkja.img
        imgViewIceland.image = Asset.Iceland.img
        imgViewFavourites.image = Asset.heart.img
        
        lblRvk.text = "BEST OF REYKJAVÍK"
        lblIceland.text = "BEST OF ICELAND"
        lblFavourites.text = "Favourites"
    }
}

extension BOMenuView{
    
    private func setBindings(){
        
        print("setup bindings")
    }
}
