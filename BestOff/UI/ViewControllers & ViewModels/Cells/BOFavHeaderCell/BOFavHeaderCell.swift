//
//  BOFavHeaderCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 28/05/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

protocol EditCellClicked: class {
    
    func editClicked()
}

class BOFavHeaderCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblEdit: UILabel!
    @IBOutlet weak var imgViewEdit: UIImageView!
    weak var delegate: EditCellClicked?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension BOFavHeaderCell{
    
    public static func reuseIdentifier() -> String{
        return "BOFavHeaderCell"
    }
    
    public static func nibName() -> String{
        return "BOFavHeaderCell"
    }
}

extension BOFavHeaderCell{
    
    func setupWith(editEnabled: Bool, delegate: EditCellClicked){
        
        lblEdit.font = UIFont.favEditTxt
        viewContainer.isUserInteractionEnabled = true
        self.delegate = delegate
        setupGesture()
        
        if editEnabled{
            lblEdit.textColor = .colorRed
            imgViewEdit.image = Asset.deleteActive.img
            return
        }
        lblEdit.textColor = .colorGreyText
        imgViewEdit.image = Asset.delete.img
    }
    
    func setupGesture(){
        
        let editTapped = UITapGestureRecognizer(target: self, action: #selector(self.editTapped(_:)))
        viewContainer.addGestureRecognizer(editTapped)
        viewContainer.isUserInteractionEnabled = true
    }
    
    @objc private func editTapped(_ sender: UITapGestureRecognizer) {
        
        editClicked()
    }
}

extension BOFavHeaderCell: EditCellClicked{
    
    func editClicked() {
        
        guard let editDelegate = delegate else { print("editDelegate not set in BOFavHeaderCell"); return }
        editDelegate.editClicked()
    }
}

extension BOFavHeaderCell{
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        imgViewEdit.addDropShadow(color: .black, opacity: Constants.lowShadowOpacity, offset: .zero, radius: 1)
    }
}
