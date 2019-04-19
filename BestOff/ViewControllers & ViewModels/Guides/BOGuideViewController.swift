//
//  BOGuideViewController.swift
//  BestOff
//
//  Created by Ivar Johannesson on 16/04/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

class BOGuideViewController: UIViewController {
    
    private let  viewModel: BOGuideViewModel
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Initalization
    init(viewModel: BOGuideViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
}

extension BOGuideViewController{
    
    private func setupVC(){
        setupTable()
        setupBindings()
    }
}

//MARK: Tableview Setup
extension BOGuideViewController{
    
    private func setupTable(){
        registerCell()
        registerDelegate()
    }
    
    private func registerCell(){
        let guideCellNib = UINib(nibName: "BOGuideCell", bundle: nil)
        tableView.register(guideCellNib, forCellReuseIdentifier: BOGuideCell.reuseIdentifier())
    }
    
    private func registerDelegate(){
        tableView.delegate = self
    }
}

extension BOGuideViewController: UITableViewDelegate{
    
    private func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
    }
}

//MARK: UI Bindings
extension BOGuideViewController{
    
    private func setupBindings(){
        
        _ = viewModel.dataSource.value?.categoryModel.observeOn(.main).observeNext{ [weak self] something in
            
            guard let this = self else{ return }
            this.tableView.dataSource = this.viewModel.dataSource.value
            this.tableView.reloadData()
        }
    }
}
