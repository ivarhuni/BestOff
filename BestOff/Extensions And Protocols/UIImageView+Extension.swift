//
//  UIImageView+Extension.swift
//  BestOff
//
//  Created by Ivar Johannesson on 14/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    static func setSDImageViewImageWithURL(imageView: UIImageView?, strURL: String, _ placeholder: UIImageView? = nil){
        guard let imgView = imageView else { return }
        guard let url = URL(string: strURL) else { return }
        imgView.sd_setImage(with: url, completed: nil)
    }
}

extension UIImageView{
    
    func setClipsAndScales(){
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}

