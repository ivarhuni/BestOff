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
    
    static func setSDImageViewImageWithURL(imageView: UIImageView?, strURL: String, _ placeholder: UIImageView? = nil, contentMode: UIView.ContentMode? = nil){
        guard let imgView = imageView else { return }
        guard let url = URL(string: strURL) else { return }
        imgView.alpha = 0
        imgView.sd_setImage(with: url) { (image, error, _, _) in
            
            UIView.animate(withDuration: 0.1, animations: {
                imgView.alpha = 1
            })
        }
        if let cMode = contentMode{
            imgView.contentMode = cMode
        }
    }
}

extension UIImageView{
    
    func setClipsAndScales(){
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
