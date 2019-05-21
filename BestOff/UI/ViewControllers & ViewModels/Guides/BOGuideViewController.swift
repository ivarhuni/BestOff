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
    
    //MARK: Properties
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

//MARK: Setup
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

//MARK: Header Methods
extension BOGuideViewController: BOAppHeaderViewDelegate{
    
    func setupMenu(){
        viewMenu.setupWithType(screenType: .reykjavik)
        viewMenu.alpha = 0
    }
    
    func setupHeaderDelegate(){
        tableViewHeader.delegate = self
    }
    
    func didPressRightButton(shouldShowMenu: Bool) {
        self.viewModel.menuOpen.value = shouldShowMenu
    }
    
    func didPressBack() {
        self.viewModel.changeDataSourceToDefault()
    }
    
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

//MARK: Styling
extension BOGuideViewController{
    
    func setupBackground(){
        view.backgroundColor = UIColor.colorRed
    }
}

//MARK: Tableview Setup
extension BOGuideViewController{
    
    private func setupTable(){
        
        registerCells()
        registerDelegateDefault()
        styleTableDefault()
    }
    
    private func styleTableDefault(){
        
        tableView.separatorStyle = .none
    }
    
    private func registerCells(){
        
        registerGuideListCells()
        registerGuideDetail()
    }
    
    private func registerGuideDetail(){
        
        let dtlItemTxtCell = UINib(nibName: BOCatItemTextDescriptionCell.nibName(), bundle: nil)
        tableView.register(dtlItemTxtCell, forCellReuseIdentifier: BOCatItemTextDescriptionCell.reuseIdentifier())
        
        let detailImgCell = UINib(nibName: GuideItemCell.nibName(), bundle: nil)
        tableView.register(detailImgCell, forCellReuseIdentifier: GuideItemCell.reuseIdentifier())
    }
    
    private func registerGuideListCells(){
        
        let topCellNib = UINib(nibName: TopGuideCell.nibName(), bundle: nil)
        tableView.register(topCellNib, forCellReuseIdentifier: TopGuideCell.reuseIdentifier())
        
        let headerCell = UINib(nibName: BOCatHeaderCell.nibName(), bundle: nil)
        tableView.register(headerCell, forCellReuseIdentifier: BOCatHeaderCell.reuseIdentifier())
        
        let doubleItemCell = UINib(nibName: DoubleItemCell.nibName(), bundle: nil)
        tableView.register(doubleItemCell, forCellReuseIdentifier: DoubleItemCell.reuseIdentifier())
    }
    
    private func registerDelegateDefault(){
        tableView.delegate = viewModel.listDataSource.value
        viewModel.listDataSource.value?.tableDelegate = self
    }
    
    private func registerDelegateDetail(){
        tableView.delegate = viewModel.detailListDataSource.value
    }
}

extension BOGuideViewController: didPressListDelegate{
    
    func didPressAtIndexPath(indexPath: IndexPath) {
        viewModel.tableViewPressedAt(indexPath.row)
    }
    
    func didPressItem(item: BOCatItem){
        viewModel.changeDataSourceToDetailWith(item: item)
    }
}

//MARK: UI Bindings
extension BOGuideViewController{
    
    private func setupBindings(){
        
        //regular list
        _ = viewModel.listDataSource.value?.categoryModel.observeOn(.main).observeNext{ [weak self] catModelValue in
            
            guard let this = self else{ return }
            
            if catModelValue != nil {
                
                this.setTableToDefault()
            }
        }
        
        //Detail Item being viewed
        _ = viewModel.detailListDataSource.observeOn(.main).observeNext{ [weak self] detailListDataSourceValue in
            
            guard let this = self else { return }
            
            if detailListDataSourceValue != nil{
                
                this.setupForDetail()
                return
            }
            
            this.setTableToDefault()
        }
        
        //Menu open
        _ = viewModel.menuOpen.observeOn(.main).observeNext{ [weak self] shouldOpen in
            
            guard let this = self else{ return }
            
            shouldOpen ? this.openMenu() : this.hideMenu()
        }
    }
}

//MARK: Default Setup
extension BOGuideViewController{
    
    private func animateToDefault(){
        
                UIView.transition(with: self.tableView,
                                  duration: self.viewModel.tableDataSourceAnimationDuration,
                                  options: .transitionCrossDissolve,
                                  animations: { [weak self] in
                                    guard let this = self else { return }
        
                                    this.tableViewHeader.viewModel.isDetailActive.value = false
                                    this.tableView.reloadData()
                }) { (finished) in
                    
                    self.scrollToTopDefault()
                }
    }
    
    private func setTableToDefault(){
        
        tableView.dataSource = viewModel.listDataSource.value

        registerDelegateDefault()
        
        animateToDefault()
    }
    
    private func scrollToTopDefault(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        if viewModel.listDataSource.value?.categoryModel.value != nil {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

//MARK: Detail Screen setup
extension BOGuideViewController{
    
    func setupForDetail(){
        
        tableView.dataSource = viewModel.detailListDataSource.value
        registerDelegateDetail()
        styleVCForDetail()
        animateReloadDataDetail()
        animateHeaderToDetail()
    }
    
    func animateHeaderToDetail(){
        
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
        
        UIView.transition(with: self.tableView, duration: self.viewModel.tableDataSourceAnimationDuration, options: .transitionCrossDissolve, animations: {
            
            self.tableView.reloadData()
        }) { (finished) in
            
            self.scrollToTopDetail()
        }
    }
    
    func scrollToTopDetail(){
        let indexPath = IndexPath(row: 0, section: 0)
        
        if viewModel.detailListDataSource.value?.catItem.value != nil {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func styleVCForDetail(){
        
    }
}


//MARK: Swipe handling
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
