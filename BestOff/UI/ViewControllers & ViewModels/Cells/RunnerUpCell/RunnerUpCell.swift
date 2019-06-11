//
//  RunnerUpCell.swift
//  BestOff
//
//  Created by Ivar Johannesson on 10/06/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit

class RunnerUpCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension RunnerUpCell{
    
    public static func reuseIdentifier() -> String{
        return "RunnerUpCell"
    }
    
    public static func nibName() -> String{
        return "RunnerUpCell"
    }
}

extension RunnerUpCell{
    
    private func setupDefault(){
        
        label.font = UIFont.catDtlItemSeperator
        label.textColor = .white
        backgroundColor = .colorRed
        self.contentView.backgroundColor = .colorRed
    }
    
    func setupWithText(text: String){
        setupDefault()
        label.text = text
    }
}
