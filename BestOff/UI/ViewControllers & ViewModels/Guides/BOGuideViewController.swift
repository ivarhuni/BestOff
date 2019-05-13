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

protocol MenuController{
    
    func openMenu()
    func hideMenu()
}

class BOGuideViewController: UIViewController {
    
    private let  viewModel: BOGuideViewModel
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeader: BOAppHeaderView!
    @IBOutlet weak var viewMenu: BOMenuView!
    
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
        setupMenu()
        setupHeaderDelegate()
        setupBackground()
        setupTable()
        setupBindings()
    }
}

//MARK: Header
extension BOGuideViewController{
    
    func setupMenu(){
        print("")
        viewMenu.setupWithType(screenType: .reykjavik)
        viewMenu.alpha = 0
        print("")
    }
    
    func setupHeaderDelegate(){
        tableViewHeader.delegate = self
    }
}

extension BOGuideViewController{
    
    func setupBackground(){
        view.backgroundColor = UIColor.colorRed
    }
}

//MARK: Tableview Setup
extension BOGuideViewController{
    
    private func setupTable(){
        
        registerCells()
        registerDelegate()
        styleTable()
    }
    
    private func styleTable(){
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
    }
    
    private func registerCells(){
        
        let topCellNib = UINib(nibName: TopGuideCell.nibName(), bundle: nil)
        tableView.register(topCellNib, forCellReuseIdentifier: TopGuideCell.reuseIdentifier())
        
        let guideCellNib = UINib(nibName: BOGuideCell.nibName(), bundle: nil)
        tableView.register(guideCellNib, forCellReuseIdentifier: BOGuideCell.reuseIdentifier())
        
        let headerCell = UINib(nibName: BOCatHeaderCell.nibName(), bundle: nil)
        tableView.register(headerCell, forCellReuseIdentifier: BOCatHeaderCell.reuseIdentifier())
    }
    
    private func registerDelegate(){
        tableView.delegate = self
    }
}

extension BOGuideViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BOGuideViewModel.getCellHeightAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableViewPressedAt(indexPath.row)
    }
}

//MARK: UI Bindings
extension BOGuideViewController{
    
    private func setupBindings(){
        
        //Each time the datamodel property 'categoryModel' has a new value
        //Tableview is refreshed
        //Performed on main thread
        _ = viewModel.dataSource.value?.categoryModel.observeOn(.main).observeNext{ [weak self] something in
            
            guard let this = self else{ return }
            this.tableView.dataSource = this.viewModel.dataSource.value
            this.tableView.reloadData()
        }
        
        _ = viewModel.menuOpen.observeOn(.main).observeNext{ value in
            
            if value{
                self.openMenu()
            }
            else{
                self.hideMenu()
            }
        }
    }
}

extension BOGuideViewController: BOAppHeaderViewDelegate{
    
    func didPressRightButton(shouldShowMenu: Bool) {
        self.viewModel.menuOpen.value = shouldShowMenu
    }
}

extension BOGuideViewController: MenuController{
    
    func openMenu() {
        
        UIView.animate(withDuration: 0.5) {
            self.viewMenu.alpha = 1
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.5) {
            self.viewMenu.alpha = 0
        }
    }
}
