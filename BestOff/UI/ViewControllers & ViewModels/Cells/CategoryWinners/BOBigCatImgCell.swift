//
//  BOBigCatImgCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 21/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class BOBigCatImgCell: UITableViewCell {

    
    @IBOutlet weak var bigImgView: UIImageView!
    @IBOutlet weak var viewBgForImgView: UIView!
    @IBOutlet weak var imgViewFingers: UIImageView!
    @IBOutlet weak var lblCatWinner: UILabel!
    @IBOutlet weak var lblCatTitle: UILabel!
    @IBOutlet weak var viewVerticalColor: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BOBigCatImgCell{
    
    static func nibName() -> String{
        return "BOBigCatImgCell"
    }
    
    static func reuseIdentifier() -> String{
        return "BOBigCatImgCell"
    }
}

extension BOBigCatImgCell{
    
    func setupWithItem(item: BOCategoryDetailItem, type: Endpoint? = .rvkDining){
        
        setupDefault()
        lblCatWinner.text = item.itemName
        lblCatTitle.text = item.categoryWinnerOrRunnerTitle
        
        if let url = item.imageURL{
            UIImageView.setSDImageViewImageWithURL(imageView: bigImgView, strURL: url, nil, contentMode: .scaleAspectFill)
        }
        
        guard let viewType = type else { return }
        setupVerticalViewWith(type: viewType)
    }
    
    private func setupDefault(){
        
        setupBgView()
        setupImgViews()
        setupLabels()
    }
    
    private func setupVerticalViewWith(type: Endpoint){
        viewVerticalColor.backgroundColor = UIColor.colorForType(type: type)
    }
    
    private func setupLabels(){
        lblCatTitle.font = UIFont.categoryImageTitle
        lblCatTitle.textColor = .white
        lblCatWinner.font = UIFont.catItemImgNameBigger
        lblCatWinner.textColor = .white
    }
    
    private func setupBgView(){
        
        viewBgForImgView.backgroundColor = .black
        viewBgForImgView.alpha = 0.2
    }
    
    private func setupImgViews(){
        
        imgViewFingers.setClipsAndScales()
        imgViewFingers.image = Asset.bestOfIcon.img
        bigImgView.setClipsAndScales()
    }
}
