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





class BOAppHeaderView: UIView {

    //MARK: Properties
    @IBOutlet weak var imgLeftIcon: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var btnHamburger: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: Properties
    let viewModel = BOHeaderViewModel()
    
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
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        toggleImage()
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
        setupButton()
    }
    
    private func setupButton(){

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

//MARK: UI Actions
extension BOAppHeaderView{
    
    func toggleImage(){
        
        //??
        UIView.animate(withDuration: viewModel.animationDuration) {
            
            self.btnHamburger.setBackgroundImage(BOHeaderViewModel.getImageForButtonState(button: self.btnHamburger), for: .normal)
        }
    }
}
