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
        setupUIBindings()
    }
}

extension BOGuideViewController: MenuViewClick{
    
    func rvkClicked() {
        
        
    }
    
    func iceClicked() {
        
        
    }
    
    func favClicked() {
        
        
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
        viewModel.menuOpen.value = shouldShowMenu
    }
    
    func didPressBackFromGuideDetail() {
        
        self.tableViewHeader.viewModel.isDetailActive.value = false
        self.changeToGuides()
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
    
    private func setupBackground(){
        view.backgroundColor = UIColor.colorRed
    }
}

//MARK: Tableview Setup
extension BOGuideViewController{
    
    private func setupTable(){
        
        registerCells()
        registerDelegateGuides()
        styleTableDefault()
    }
    
    private func styleTableDefault(){
        
        tableView.separatorStyle = .none
    }
    
    private func disableTableDelegate(){
        tableView.delegate = nil
    }
    
    private func registerCells(){
        
        registerGuideListCells()
        registerGuideDetail()
        registerCategoryWinnerCells()
        registerFavouriteCell()
    }
    
    private func registerFavouriteCell(){
        
        let favCell = UINib(nibName: BOFavouriteCell.nibName(), bundle: nil)
        tableView.register(favCell, forCellReuseIdentifier: BOFavouriteCell.reuseIdentifier())
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
    
    private func registerDelegateGuides(){
        
        viewModel.setDidPressListDelegateForGuideList(delegater: self)
    }
    
    private func registerDelegateRvk(){

        viewModel.setDidPressListDelegateForGuideList(delegater: self)
    }
    
    private func registerDelegateSubcategories(){
        
        viewModel.setDidPressListDelegateForGuideList(delegater: self)
    }
}

//MARK: UI Bindings
extension BOGuideViewController{
    
    private func setupUIBindings(){
        
        //Menu open
        _ = viewModel.menuOpen.observeOn(.main).observeNext{ [weak self] shouldOpen in
            
            guard let this = self else{ return }
            
            shouldOpen ? this.openMenu() : this.hideMenu()
        }
        
        //Changes in TableView DataSource
        _ = viewModel.activeTableDataSource.observeOn(.main).observeNext{ [weak self] activeDataSourceValue in
            
            guard let this = self else { return }
            this.tableView.dataSource = activeDataSourceValue
            this.animateTableReloadData()
        }
        
        _ = viewModel.activeTableDelegate.observeOn(.main).observeNext{ [weak self] activeTableDelegateValue in
            
            guard let this = self else { return }
            this.tableView.delegate = activeTableDelegateValue
        }
        
        //ContentTypeSwitching
        _ = viewModel.screenContentType.observeOn(.main).observeNext{ [weak self] contentTypeValue in
            
            guard let this = self else { return }
            
            switch contentTypeValue{
                
            case .guides:
                this.setupForGuides()
                
            case .guideDetail:
                this.setupForGuideDetail()
                
            case .reykjavik:
                this.setupForRvk()
                
            case .iceland:
                this.setupForIceland()
                
            case .reykjavikSubCategories:
                this.setupForSubcategories()
                
            case .favourites:
                this.setupForFavourites()
            }
        }
    }
}

extension BOGuideViewController{
    
    private func animateTableReloadData(){
        
        UIView.transition(with: self.tableView,
                          duration: self.viewModel.tableDataSourceAnimationDuration,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            this.tableView.reloadData()
                            
        }) { [weak self] _ in
            guard let this = self else { return }
            
            this.viewModel.shouldSwipeBeEnabled() ? this.enableSwipe() : this.disableSwipe()
            this.tableView.scroll(to: .top, animated: true)
        }
    }
    
    private func animateHeaderToGuideDetail(){
        
        UIView.animate(withDuration: self.viewModel.tableDataSourceAnimationDuration, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let this = self else { return }
            
            this.tableViewHeader.showDetail(withDetailText: "GUIDES")
            }, completion: nil)
    }
}

//Guide delegate
extension BOGuideViewController: didPressListDelegate{
    
    func didPressAtIndexPath(indexPath: IndexPath) {
        
        viewModel.tableViewPressedAt(indexPath.row)
    }
    
    func didPressItem(item: BOCatItem){
        
        viewModel.changeDataSourceToDetailWith(item: item)
    }
}

//MARK: Setup Content Type Guides
extension BOGuideViewController{
    
    private func changeToGuides(){
        viewModel.screenContentType.value = .guides
    }
    
    private func setupForGuides(){
        disableTableDelegate()
        viewModel.setTableDelegateFor(contentType: .guides)
        viewModel.setTableDataSourceFor(contentType: .guides)
        registerDelegateGuides()
    }
    
    private func scrollToTopGuides(){
        
        if viewModel.getGuideListDataSourceNumberOfRows() > 0{
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

//MARK: Setup Content Type Guide Detail
extension BOGuideViewController{
    
    private func changeToGuideDetail(){
        viewModel.screenContentType.value = .guideDetail
    }
    
    private func setupForGuideDetail(){
        
        disableTableDelegate()
        animateHeaderToGuideDetail()
        viewModel.setTableDelegateFor(contentType: .guideDetail)
        viewModel.setTableDataSourceFor(contentType: .guideDetail)
        disableSwipe()
    }
    
    
}

//MARK: Setup Content Type Reykjavik
extension BOGuideViewController: TakeMeThereProtocol{
    
    private func changeToRvkCategories() {
        viewModel.screenContentType.value = .reykjavik
    }
    
    private func setupForRvk(){
        
        disableTableDelegate()
        registerDelegateRvk()
        viewModel.setTableDelegateFor(contentType: .reykjavik)
        viewModel.setTableDataSourceFor(contentType: .reykjavik)
        enableSwipe()
    }
    
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
}

//MARK: Favourites
extension BOGuideViewController{
    
    private func changeToFavourites(){
        viewModel.screenContentType.value = .favourites
    }
    
    private func setupForFavourites(){
        
        disableTableDelegate()
        viewModel.setTableDelegateFor(contentType: .favourites)
        viewModel.setTableDataSourceFor(contentType: .favourites)
        disableSwipe()
    }
    
    private func setHeaderToFavs(){
        
        tableViewHeader.viewModel.isDetailActive.value = true
        tableViewHeader.showDetail(withDetailText: "FAVOURITES")
    }
}

//MARK: Subcategories
extension BOGuideViewController{
    
    private func setupForSubcategories(){

        disableTableDelegate()
        registerDelegateSubcategories()
        viewModel.setTableDelegateFor(contentType: .reykjavikSubCategories)
        viewModel.setTableDataSourceFor(contentType: .reykjavikSubCategories)
        disableSwipe()
        setHeaderToSubcategory()
    }
    
    private func setHeaderToSubcategory(){
        tableViewHeader.viewModel.isDetailActive.value = true
        tableViewHeader.showDetail(withDetailText: viewModel.getHeaderDetailTxtFromSubCategory())
    }
    
    private func animateReloadDataSubcategories(){
        
        UIView.transition(with: tableView, duration: viewModel.tableDataSourceAnimationDuration, options: .transitionCrossDissolve, animations: { [weak self] in
            
            guard let this = self else { return }
            this.tableViewHeader.viewModel.isDetailActive.value = true
            //TODO: FIX
//            if let title = this.viewModel.subcategoriesListDataSource.value?.catTitle{
//                this.tableViewHeader.showDetail(withDetailText: title)
//            }
//            this.tableView.reloadData()
            
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
            self.changeToGuides()
        case .left:
            self.setupForRvk()
        default:
            break
        }
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
}

extension BOGuideViewModel: DeleteFavouriteItem{
   
    func deleteClicked() {
        
    }
}


extension BOGuideViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}




extension BOGuideViewController{
    
    //TODO: Implement
    func setupForIceland(){
        
    }
}
