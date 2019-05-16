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
        setupSwipeGestureRec()
        setupBindings()
    }
}

extension BOGuideViewController{
    
    func setupSwipeGestureRec(){
        
        setupLeftSwipe()
        setupRightSwipe()
    }
    
    func setupLeftSwipe(){
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = false
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(swipeLeft)
    }
    
    func setupRightSwipe(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = false
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }
        
        switch swipeGesture.direction {

        case .right:
            
            print("right")
        
        case .left:
            print("left")
        default:
            break
        }
    }
}

//MARK: Header
extension BOGuideViewController{
    
    func setupMenu(){
        viewMenu.setupWithType(screenType: .reykjavik)
        viewMenu.alpha = 0
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
        styleTableDefault()
    }
    
    private func styleTableDefault(){
        
        let tableCornerRadius:CGFloat = 10.0
        tableView.separatorStyle = .none
        
        tableView.roundCorners(corners: .topLeft, radius: tableCornerRadius)
    }
    
    private func registerCells(){
        
        registerGuideListCells()
        
    }
    
    private func registerGuideDetail(){
        
        
    }
    
    private func registerGuideListCells(){
        
        let topCellNib = UINib(nibName: TopGuideCell.nibName(), bundle: nil)
        tableView.register(topCellNib, forCellReuseIdentifier: TopGuideCell.reuseIdentifier())
        
        let headerCell = UINib(nibName: BOCatHeaderCell.nibName(), bundle: nil)
        tableView.register(headerCell, forCellReuseIdentifier: BOCatHeaderCell.reuseIdentifier())
        
        let doubleItemCell = UINib(nibName: DoubleItemCell.nibName(), bundle: nil)
        tableView.register(doubleItemCell, forCellReuseIdentifier: DoubleItemCell.reuseIdentifier())
    }
    
    private func registerDelegate(){
        tableView.delegate = self
    }
}

extension BOGuideViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getListCellHeightAt(indexPath: indexPath)
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
        _ = viewModel.listDataSource.value?.categoryModel.observeOn(.main).observeNext{ [weak self] catModelValue in
            
            guard let this = self else{ return }
            
            if catModelValue != nil {
                
                this.tableView.dataSource = this.viewModel.listDataSource.value
                UIView.transition(with: this.tableView,
                                  duration: this.viewModel.tableDataSourceAnimationDuration,
                                  options: .transitionCrossDissolve,
                                  animations: { this.tableView.reloadData() })
            }
        }
        
        _ = viewModel.detailListDataSource.observeOn(.main).observeNext{ [weak self] detailListDataSourceValue in
            
            guard let this = self else { return }
            
            if detailListDataSourceValue != nil{
                
                this.setupForDetail()
            }
        }
        
        _ = viewModel.menuOpen.observeOn(.main).observeNext{ [weak self] value in
            
            guard let this = self else{ return }
            
            value ? this.openMenu() : this.hideMenu()
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
        
        UIView.animate(withDuration: viewModel.menuAnimationDuration) { [weak self] in
            guard let this = self else { return }
            this.viewMenu.alpha = this.viewModel.alphaVisible
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: viewModel.menuAnimationDuration) { [weak self] in
            guard let this = self else { return }
            this.viewMenu.alpha = this.viewModel.alphaInvisible
        }
    }
}

extension BOGuideViewController{
    
    func setupForDetail(){
        
        
        self.tableView.dataSource = self.viewModel.detailListDataSource.value
        styleVCForDetail()
        animateReloadDataDetail()
       
        animateHeaderToDetail()
    }
    
    func animateHeaderToDetail(){
        
//        UIView.transition(with: tableViewHeader,
//                          duration: self.viewModel.tableDataSourceAnimationDuration,
//                          options: .transitionCrossDissolve,
//                          animations: { self.tableViewHeader.showDetail() })
        
        UIView.animate(withDuration: self.viewModel.tableDataSourceAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            
            self.tableViewHeader.showDetail()
        }, completion: nil)
    }
    
    func animateReloadDataDetail(){
        UIView.transition(with: self.tableView,
                          duration: self.viewModel.tableDataSourceAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: {
                            
                            self.tableView.reloadData()
        })
    }
    
    func styleVCForDetail(){
        
        tableView.roundCorners(corners: .topLeft, radius: 0)
    }
}
