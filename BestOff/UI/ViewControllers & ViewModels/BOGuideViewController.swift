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
    private var swipeLeft: UISwipeGestureRecognizer?
    private var swipeRight: UISwipeGestureRecognizer?
    
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
        
        let catWinnerCellImg = UINib(nibName: BOBigCatImgCell.nibName(), bundle: nil)
        tableView.register(catWinnerCellImg, forCellReuseIdentifier: BOBigCatImgCell.reuseIdentifier())
        
        let doubleItemImgCell = UINib(nibName: DoubleItemImgCell.nibName(), bundle: nil)
        tableView.register(doubleItemImgCell, forCellReuseIdentifier: DoubleItemImgCell.reuseIdentifier())
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
        viewModel.guideListDataSource.value?.tableDelegate = nil
    }
    
    private func registerDelegateCategoryWinner(){
        tableView.delegate = viewModel.categoryWinnerListDataSource.value
        viewModel.guideListDataSource.value?.tableDelegate = self
    }
    
    private func registerDelegateSubcategories(){
        tableView.delegate = viewModel.subcategoriesListDataSource.value
        viewModel.guideListDataSource.value?.tableDelegate = self
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
        _ = viewModel.guideListDataSource.value?.categoryModel.observeOn(.main).observeNext{ [weak self] catModelValue in
            
            guard let this = self else{ return }
            
            if catModelValue != nil{
                this.setTableToDefault()
            }
            else{
                print("nothing in guidelistdatasourcevalue binding")
            }
        }
        
        //Detail Item being viewed
        _ = viewModel.guideDetailDataSource.observeOn(.main).observeNext{ [weak self] detailListDataSourceValue in
            
            guard let this = self else { return }
           
            if detailListDataSourceValue == nil{
                if this.viewModel.shouldRefreshTableWithNewCategoryWinner(){
                    this.setupForCategoryWinners()
                }
                else{
                    this.setTableToDefault()
                }
            }
            else{
                this.setupForDetail()
            }
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
        
        //CategoryWinners
        _ = viewModel.categoryWinnerListDataSource.value?.dining.observeOn(.main).observeNext{ [weak self] _ in
            
            guard let this = self else { return }
            this.viewModel.shouldRefreshTableWithNewCategoryWinner() ? this.reloadWith(winner: .rvkDining) : print("notReloadingDining")
        }
        
        _ = viewModel.categoryWinnerListDataSource.value?.drinking.observeOn(.main).observeNext{ [weak self] _ in
            
            guard let this = self else { return }
            this.viewModel.shouldRefreshTableWithNewCategoryWinner() ? this.reloadWith(winner: .rvkDrink) : print("notReloadingDrinking")
        }
        
        _ = viewModel.categoryWinnerListDataSource.value?.activities.observeOn(.main).observeNext{ [weak self] _ in
            
            guard let this = self else { return }
            this.viewModel.shouldRefreshTableWithNewCategoryWinner() ? this.reloadWith(winner: .rvkActivities) : print("notReloadingActivities")
        }
        
        _ = viewModel.categoryWinnerListDataSource.value?.shopping.observeOn(.main).observeNext{ [weak self] _ in
            
            guard let this = self else { return }
            this.viewModel.shouldRefreshTableWithNewCategoryWinner() ? this.reloadWith(winner: .rvkShopping) : print("notReloadingShopping")
        }
        
        //Subcategories
        _ = viewModel.subcategoriesListDataSource.observeOn(.main).observeNext{ [weak self] dataSourceValue in
            
            guard let this = self else { return }
            this.setupForSubcategories()
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
                }) { [weak self] (finished) in
                    guard let this = self else { return }
                    this.scrollToTopDefault()
                }
    }
    
    private func setTableToDefault(){
        
        tableView.dataSource = viewModel.guideListDataSource.value
        registerDelegateDefault()
        animateToDefault()
        enableSwipe()
    }
    
    private func scrollToTopDefault(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        (viewModel.guideListDataSource.value?.categoryModel.value != nil) ? self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) : print("nothing")
    }
}

//MARK: Detail Screen setup
extension BOGuideViewController{
    
    private func setupForDetail(){
        
        tableView.dataSource = viewModel.guideDetailDataSource.value
        
        registerDelegateDetail()
        animateReloadDataDetail()
        animateHeaderToDetail()
        disableSwipe()
    }
    
    private func disableSwipe(){
        if let leftSwipe = self.swipeLeft{
            leftSwipe.isEnabled = false
        }
        if let rightSwipe = self.swipeRight{
            rightSwipe.isEnabled = false
        }
    }
    
    private func enableSwipe(){
        if let leftSwipe = self.swipeLeft{
            leftSwipe.isEnabled = true
        }
        if let rightSwipe = self.swipeRight{
            rightSwipe.isEnabled = true
        }
    }
    
    private func animateHeaderToDetail(){
        
        UIView.animate(withDuration: self.viewModel.tableDataSourceAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            
            self.tableViewHeader.showDetail(withDetailText: "GUIDES")
        }, completion: nil)
    }
    
    private func animateReloadDataDetail(){
        
        UIView.transition(with: self.tableView, duration: self.viewModel.tableDataSourceAnimationDuration, options: .transitionCrossDissolve, animations: {
            
            self.tableView.reloadData()
        }) { (finished) in
            
            self.scrollToTopDetail()
        }
    }
    
    private func scrollToTopDetail(){
        let indexPath = IndexPath(row: 0, section: 0)
        
        (viewModel.guideDetailDataSource.value?.catItem.value != nil) ? self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) : print("")
    }
}

//MARK: Setup For CategoryWinner List View
extension BOGuideViewController: TakeMeThereProtocol{
    
    
    func didPressTakeMeThere(type: Endpoint) {
        
        switch type{
            
        case .rvkDining:
            print("dining")
        case .rvkDrink:
            print("drink")
        case .rvkShopping:
            print("shopping")
        case .rvkActivities:
          print("activities")
            
        default:
            print("default takemethereVCprotocol")
        }
    }
    
    private func setupForCategoryWinners(){
        
        //Header same as Guide
        tableView.dataSource = viewModel.categoryWinnerListDataSource.value
        registerDelegateCategoryWinner()
        animateReloadDataWinners()
        enableSwipe()
    }
    
    private func animateReloadDataWinners(){
        
        UIView.transition(with: tableView, duration: viewModel.tableDataSourceAnimationDuration, options: .transitionCrossDissolve, animations: { [weak self] in
            
            guard let this = self else { return }
            this.tableViewHeader.viewModel.isDetailActive.value = false
            this.tableView.reloadData()
        }) { (finished) in }
    }
    
    private func reloadWith(winner: Endpoint){
        
        switch winner {
        case .rvkDining:
            tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .left)
        case .rvkDrink:
            tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .left)
        case .rvkShopping:
            tableView.reloadRows(at: [IndexPath(item: 2, section: 0)], with: .left)
        case .rvkActivities:
            tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .left)
        default:
            print("")
        }
    }
    
    private func scrollToTopCatWinner(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        (viewModel.categoryWinnerListDataSource.value != nil) ?  self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) : print("")
    }
}

//MARK: Subcategories
extension BOGuideViewController{
    
    private func setupForSubcategories(){
        
        //Header same as Guide
        tableView.dataSource = viewModel.subcategoriesListDataSource.value
        registerDelegateSubcategories()
        disableSwipe()
        animateReloadDataSubcategories()
    }
    
    private func animateReloadDataSubcategories(){
        
        UIView.transition(with: tableView, duration: viewModel.tableDataSourceAnimationDuration, options: .transitionCrossDissolve, animations: { [weak self] in
            
            guard let this = self else { return }
            this.tableViewHeader.viewModel.isDetailActive.value = true
            if let title = this.viewModel.subcategoriesListDataSource.value?.catTitle{
                this.tableViewHeader.showDetail(withDetailText: title)
            }
            this.tableView.reloadData()
        }) { (finished) in }
    }
}

//MARK: Swipe handling
extension BOGuideViewController{
    
    private func setupSwipeGestureRec(){
        
        setupLeftSwipe()
        setupRightSwipe()
        enableSwipe()
    }
    
    private func setupLeftSwipe(){
        
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        guard let swLeft = swipeLeft else { return }
        
        swLeft.direction = .left
        swLeft.cancelsTouchesInView = false
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(swLeft)
    }
    
    private func setupRightSwipe(){
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        guard let swRight = swipeRight else { return }
        
        swRight.direction = .right
        swRight.cancelsTouchesInView = false
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(swRight)
    }
    
    
    
    static func clearGestureRecForView(view: UIView){
        
        for recognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(recognizer)
        }
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
    
    private func disableTableDelegate(){
        tableView.delegate = nil
    }
}

extension BOGuideViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


