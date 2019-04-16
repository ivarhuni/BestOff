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

    private let viewModel: BOGuideViewModel
    @IBOutlet weak var tableView: UITableView!
    var tableDataSource: BOGuideTableDataSource?
    
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

//MARK UI Bindings
extension BOGuideViewController{
    
    private func setupBindings(){
        
//        This is an alternative way of writing
//        ---------
//                _ = viewModel.arrGuideCategory.observeNext{ [weak self] array in
//                    guard let this = self else{ return }
//                    print("Detected new value for guide array")
//                }.dispose(in: disposeBag)
//        ---------
//        Here we don't have to dispose of the binding since it's bound to self
//        And hence deallocates with it when self is destroyed
//        And we dont have to worry about
//        threading, retain cycles and disposing because bindings take care of all that automatically
        
        _ = viewModel.category.skip(first: 1).bind(to: self){ this, array in

            print("Detected new value for guide category in GuideVC")
            this.setupTable()
        }
        
        
    }
}

//MARK: Tableview Setup
extension BOGuideViewController: UITableViewDelegate{
    

    private func setupTable(){
        
        guard let category = self.viewModel.category.value else{
            print("category in guide viewmodel has nil as value")
            return
        }
        print("category in guide viewmodel has value, setting up table")
        let guideCellNib = UINib(nibName: "BOGuideCell", bundle: nil)
        tableView.register(guideCellNib, forCellReuseIdentifier: BOGuideCell.reuseIdentifier())
        tableDataSource = BOGuideTableDataSource(categoryModel: category, tableView: tableView)
        tableView.dataSource = tableDataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
