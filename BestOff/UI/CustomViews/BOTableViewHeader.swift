//
//  BOTableViewHeader.swift
//  BestOff
//
//  Created by Ivar Johannesson on 30/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class BOTableViewHeader: UIView {

    //MARK: Properties
    @IBOutlet weak var imgLeftIcon: UIImageView!
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

extension BOTableViewHeader{
    
    private func commonInit(){
        
        initView()
        styleView()
    }
    
    private func initView(){
        
        Bundle.main.loadNibNamed("BOTableViewHeader", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func styleView(){
        
        self.view.backgroundColor = .colorRed
    }
}
