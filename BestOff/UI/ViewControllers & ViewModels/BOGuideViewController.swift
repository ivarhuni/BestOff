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
        registerCategoryWinnerCells()
    }
    
    private func registerCategoryWinnerCells(){
        
        let catWinnerCell = UINib(nibName: CategoryWinnerCell.nibName(), bundle: nil)
        tableView.register(catWinnerCell, forCellReuseIdentifier: CategoryWinnerCell.reuseIdentifier())
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
        tableView.delegate = viewModel.guideListDataSource.value
        viewModel.guideListDataSource.value?.tableDelegate = self
    }
    
    private func registerDelegateDetail(){
        tableView.delegate = viewModel.guideDetailDataSource.value
    }
    
    private func registerDelegateCategoryWinner(){
        tableView.delegate = viewModel.categoryWinnerListDataSource.value
    }
}

extension BOGuideViewController: didPressListDelegate{
    
    func didPressAtIndexPath(indexPath: IndexPath) {
        print("didPress")
        viewModel.tableViewPressedAt(indexPath.row)
    }
    
    func didPressItem(item: BOCatItem){
        print("didPress")
        viewModel.changeDataSourceToDetailWith(item: item)
    }
}

//MARK: UI Bindings
extension BOGuideViewController{
    
    private func setupBindings(){
        
        //regular list
        _ = viewModel.guideListDataSource.value?.categoryModel.observeOn(.main).observeNext{ [weak self] catModelValue in
            
            guard let this = self else{ return }
            
            (catModelValue != nil) ? this.setTableToDefault() : print("nothing")
        }
        
        //Detail Item being viewed
        _ = viewModel.guideDetailDataSource.observeOn(.main).observeNext{ [weak self] detailListDataSourceValue in
            
            guard let this = self else { return }
            
            (detailListDataSourceValue != nil) ? this.setupForDetail() : this.setTableToDefault()
        }
        
        //Menu open
        _ = viewModel.menuOpen.observeOn(.main).observeNext{ [weak self] shouldOpen in
            
            guard let this = self else{ return }
            
            shouldOpen ? this.openMenu() : this.hideMenu()
        }
        
        //Active Page After Swipe
        _ = viewModel.activePage.observeOn(.main).observeNext{ [weak self] newActivePage in
            
            guard let this = self else { return }
            (newActivePage == .right) ? this.setupForCategoryWinners() : this.setTableToDefault()
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
        
        tableView.dataSource = viewModel.guideListDataSource.value

        registerDelegateDefault()
        
        animateToDefault()
    }
    
    private func scrollToTopDefault(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        (viewModel.guideListDataSource.value?.categoryModel.value != nil) ? self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) : print("nothing")
    }
}

//MARK: Detail Screen setup
extension BOGuideViewController{
    
    func setupForDetail(){
        
        tableView.dataSource = viewModel.guideDetailDataSource.value
        registerDelegateDetail()
        animateReloadDataDetail()
        animateHeaderToDetail()
    }
    
    func animateHeaderToDetail(){
        
        UIView.animate(withDuration: self.viewModel.tableDataSourceAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            
            self.tableViewHeader.showDetail()
        }, completion: nil)
    }
    
    func animateReloadDataDetail(){
        
        UIView.transition(with: self.tableView, duration: self.viewModel.tableDataSourceAnimationDuration, options: .transitionCrossDissolve, animations: {
            
            self.tableView.reloadData()
        }) { (finished) in
            
            self.scrollToTopDetail()
        }
    }
    
    func scrollToTopDetail(){
        let indexPath = IndexPath(row: 0, section: 0)
        
        (viewModel.guideDetailDataSource.value?.catItem.value != nil) ? self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) : print("")
    }
}

//MARK: Setup For CategoryWinner List View
extension BOGuideViewController{
    
    private func setupForCategoryWinners(){
        
        //Header same as Guide
        tableView.dataSource = viewModel.categoryWinnerListDataSource.value
        registerDelegateCategoryWinner()
        animateReloadDataWinners()
    }
    
    private func animateReloadDataWinners(){
        
        UIView.transition(with: tableView, duration: viewModel.tableDataSourceAnimationDuration, options: .transitionCrossDissolve, animations: { [weak self] in
            
            guard let this = self else { return }
            this.tableView.reloadData()
        }) { [weak self] (finished) in
            
            guard let this = self else { return }
            this.scrollToTopCatWinner()
        }
    }
    
    func scrollToTopCatWinner(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        (viewModel.categoryWinnerListDataSource.value != nil) ?  self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) : print("")
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
            disableTableDelegate()
            viewModel.setActivePage(page: .left)
        case .left:
            disableTableDelegate()
            viewModel.setActivePage(page: .right)
        default:
            break
        }
    }
    
    func disableTableDelegate(){
        tableView.delegate = nil
    }
}
