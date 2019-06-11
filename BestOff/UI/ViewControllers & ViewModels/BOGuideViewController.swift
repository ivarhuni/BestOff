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
import NVActivityIndicatorView

protocol MenuController{
    
    func openMenu()
    func hideMenu()
}

class BOGuideViewController: UIViewController {
    
    //MARK: Properties
    private let  viewModel: BOGuideViewModel
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewControllerHeadder: BOAppHeaderView!
    @IBOutlet weak var viewMenu: BOMenuView!
    @IBOutlet weak var viewLoadingScreen: UIView!
    @IBOutlet weak var imgViewGrapevine: UIImageView!
    @IBOutlet weak var viewActivity: NVActivityIndicatorView!
    @IBOutlet weak var viewAnimationBox: UIView!
    
    @IBOutlet weak var constantAnimBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var constantAnimBoxWidth: NSLayoutConstraint!
    @IBOutlet weak var constantViewActivity: NSLayoutConstraint!
    @IBOutlet weak var constantViewActivityWidth: NSLayoutConstraint!
    @IBOutlet weak var constantImgViewGHeight: NSLayoutConstraint!
    @IBOutlet weak var constantImgViewGWidth: NSLayoutConstraint!
    
    
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

extension BOGuideViewController{
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        BOGuideViewController.roundCorners(view: tableView, .allCorners, radius: 0)
        if !BOGuideViewModel.getRoundedCornerFor(screenContentType: viewModel.screenContentType.value).isEmpty{
            
            _ = BOGuideViewModel.getRoundedCornerFor(screenContentType: viewModel.screenContentType.value).compactMap{ rectCorner in
                
                BOGuideViewController.roundCorners(view: tableView, rectCorner, radius: 10)
            }
            return
        }
    }
}


//MARK: Setup
extension BOGuideViewController{
    
    private func setupVC(){
        setupLoadingScreen()
        setupMenu()
        setupHeaderDelegate()
        setupBackground()
        setupTable()
        setupSwipeGestureRec()
        setupUIBindings()
    }
}

extension BOGuideViewController{
    
    func setupLoadingScreen(){
        
        viewLoadingScreen.backgroundColor = .colorRed
        imgViewGrapevine.image = Asset.grapevineIcon.img
        viewActivity.backgroundColor = .clear
        viewActivity.type = .ballScaleRippleMultiple
        viewActivity.alpha = viewModel.viewActivityAlpha
        viewLoadingScreen.alpha = 1
        viewAnimationBox.backgroundColor = .colorRed
        viewActivity.startAnimating()

    }
    
    private func hideLoadingScreen(){
        
        print("hiding loading screen")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.viewModel.animationDelay) {
            
            self.view.setNeedsLayout()
            
            UIView.animate(withDuration: self.viewModel.loaderDissapearDuration) { [weak self] in
                
                guard let this = self else { return }
                this.constantAnimBoxWidth.constant = 0
                this.constantAnimBoxHeight.constant = 0
                this.constantViewActivity.constant = 0
                this.constantViewActivityWidth.constant = 0
                
                this.constantImgViewGWidth.constant = 27
                this.constantImgViewGHeight.constant = 30
                
                this.imgViewGrapevine.frame.origin.x = this.viewControllerHeadder.imgLeftIcon.frame.origin.x
                this.imgViewGrapevine.frame.origin.y = this.viewControllerHeadder.imgLeftIcon.frame.origin.y + this.viewControllerHeadder.frame.origin.y
                
                this.view.layoutIfNeeded()
            }
            
            
            UIView.animate(withDuration: self.viewModel.containerDissapearDuration) { [weak self] in
                
                guard let this = self else { return }
                
                this.viewLoadingScreen.alpha = 0
                
                this.view.layoutIfNeeded()
            }
        }
    }
}

extension BOGuideViewController: MenuViewClick{
    
    func rvkClicked() {
        
        viewControllerHeadder.viewModel.isHamburgerActive.value = true
        viewControllerHeadder.setTitleText(text: "BEST OF REYKJAVÍK")
        changeToGuides()
    }
    
    func subCatClicked(){
        viewControllerHeadder.viewModel.isHamburgerActive.value = true
        viewControllerHeadder.setTitleText(text: "BEST OF REYKJAVÍK")
        changeToRvkCategories()
    }
    
    func iceClicked() {
        
        viewControllerHeadder.viewModel.isHamburgerActive.value = true
        viewControllerHeadder.setTitleText(text: "BEST OF ICELAND")
        changeToIceland()
    }
    
    func favClicked() {
        
        changeToFavourites()
    }
}

//MARK: Header Methods
extension BOGuideViewController: BOAppHeaderViewDelegate{
    
    func setupMenu(){
        viewMenu.setupWithType(screenType: .reykjavik)
        viewMenu.alpha = 0
        viewMenu.menuViewClickDelegate = self
    }
    
    func setupHeaderDelegate(){
        viewControllerHeadder.delegate = self
    }
    
    func didPressRightButton(shouldShowMenu: Bool) {
        viewModel.menuOpen.value = shouldShowMenu
    }
    
    func didPressBackFromAppHeader() {
        
        viewControllerHeadder.viewModel.isHamburgerActive.value = true
        viewControllerHeadder.viewModel.isDetailActive.value = false
        guard let lastScreenType = self.viewModel.getLastContentType() else {
            
            viewMenu.setupWithType(screenType: .guides)
            changeToGuides()
            return
        }
        if lastScreenType == .favourites{
            
            viewMenu.setupWithType(screenType: .guides)
            changeToGuides()
            return
        }
        
        guard let nextToLastScreenType = self.viewModel.getNextToLastContentType() else {
            
            viewMenu.setupWithType(screenType: .guides)
            changeToGuides()
            return
        }
        
        viewModel.screenContentType.value = nextToLastScreenType
        viewMenu.setupWithType(screenType: nextToLastScreenType)
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
            this.viewControllerHeadder.setTitleText(text: this.viewModel.getTextForScreenType())
        }
    }
    
    func getMenuTypeFromContentScreenType() -> ContentType{
        
        if viewModel.screenContentType.value == .favourites { return .favourites }
        if viewModel.screenContentType.value == .iceland { return .iceland }
        
        return .reykjavik
    }
}

//MARK: Styling
extension BOGuideViewController{
    
    private func setupBackground(){
        view.backgroundColor = .colorRed
    }
}

//MARK: Tableview Setup
extension BOGuideViewController{
    
    private func setupTable(){
        
        //tableView.alpha = 0
        registerCells()
        registerDelegateGuides()
        styleTableDefault()
        setupEditDelegateForFavourites()
        setupDeleteDelegateForFavourites()
    }
    
    private func styleTableDefault(){
        
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = Constants.editRowHeight
    }
    
    private func disableTableDelegate(){
        tableView.delegate = nil
    }
    
    private func registerCells(){
        
        registerGuideListCells()
        registerGuideDetail()
        registerCategoryWinnerCells()
        registerFavouriteCell()
        registerCatDetailCells()
    }
    
    private func registerCatDetailCells(){
        let runnerUpCell = UINib(nibName: RunnerUpCell.nibName(), bundle: nil)
        tableView.register(runnerUpCell, forCellReuseIdentifier: RunnerUpCell.reuseIdentifier())
    }
    
    private func registerFavouriteCell(){
        
        let favHeaderCell = UINib(nibName: BOFavHeaderCell.nibName(), bundle: nil)
        tableView.register(favHeaderCell, forCellReuseIdentifier: BOFavHeaderCell.reuseIdentifier())
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
}

//MARK: Delegates
extension BOGuideViewController{
    
    private func registerDelegateGuides(){
        
        registerDidPressList()
    }
    
    private func registerDelegateRvk(){
        
        registerDidPressList()
        viewModel.setCategoryDetailClickDelegate(delegate: self)
    }
    
    private func registerDelegateIce(){
        viewModel.setCategoryDetailClickDelegate(delegate: self)
    }
    
    private func registerDidPressList(){
        viewModel.setDidPressListDelegate(delegater: self)
    }
    
    private func registerDelegateSubcategories(){
        
        viewModel.setDidPressListDelegate(delegater: self)
    }
    
    private func setupEditDelegateForFavourites(){
        
        viewModel.setEditDelegateForFavourites(delegate: self)
    }
    
    private func setupDeleteDelegateForFavourites(){
        viewModel.setFavouriteDelegateForFavourites(delegate: self)
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
            
            if activeDataSourceValue != nil{
                this.tableView.dataSource = activeDataSourceValue
                this.animateTableReloadData()
                
                if this.viewModel.shouldBeAnimating.value{
                    this.viewModel.shouldBeAnimating.value = false
                }
            }
        }
        
        _ = viewModel.shouldBeAnimating.observeOn(.main).observeNext{ [weak self] shouldAnimate in
            
            guard let this = self else { return }
            
            if !shouldAnimate { this.hideLoadingScreen() }
        }
        
        _ = viewModel.activeTableDelegate.observeOn(.main).observeNext{ [weak self] activeTableDelegateValue in
            
            guard let this = self else { return }
            this.tableView.delegate = activeTableDelegateValue
        }
        
        //ContentTypeSwitching
        _ = viewModel.screenContentType.observeOn(.main).observeNext{ [weak self] contentTypeValue in
            
            guard let this = self else { return }
            
            if contentTypeValue != .guides {
                this.viewModel.hasLoadedSomethingOtherThanGuide = true
            }
            
            this.viewModel.addContentTypeToHistory(typeToAdd: contentTypeValue)
            
            switch contentTypeValue{
                
            case .categoryDetail:
                this.setupForCatDetail()
                
            case .guides:
                this.setupForGuides()
                
            case .guideDetail:
                this.setupForGuideDetail()
                
            case .reykjavik:
                this.setupForRvk()
                
            case .iceland:
                this.setupForIceland()
                
            case .subCategories:
                this.setupForSubcategories()
                
            case .favourites:
                this.setupForFavourites()
            }
        }
    }
}

extension BOGuideViewController: EditCellClicked{
    
    func editClicked() {
        
        reloadFavourites()
    }
    
    func reloadFavourites(){
        
        viewModel.toggleEditActive()
        
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

extension BOGuideViewController{
    
    private func animateTableReloadData(){
        
        self.view.setNeedsLayout()
        UIView.transition(with: self.tableView,
                          duration: self.viewModel.tableDataSourceAnimationDuration,
                          options: .curveLinear,
                          animations: { [weak self] in
                            
                            guard let this = self else { return }
                            
                            
                            this.tableView.reloadSections(IndexSet(integer: 0), with: this.viewModel.getTableViewAnimationFor(screenContentType: this.viewModel.screenContentType.value))
                            
        }) { [weak self] _ in
            guard let this = self else { return }
            
            this.viewModel.shouldSwipeBeEnabled() ? this.enableSwipe() : this.disableSwipe()
            this.tableView.scroll(to: .top, animated: true)

            UIView.animate(withDuration: 1.5, animations: {
                
                
            })
        }
    }
    
    private func animateHeaderToGuideDetail(){
        
        UIView.animate(withDuration: self.viewModel.tableDataSourceAnimationDuration, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let this = self else { return }
            
            this.viewControllerHeadder.showDetail(withDetailText: "Guides")
        }) { finished in
            
        }
    }
    
    private func animateHeaderToCatDetail(){
        
        UIView.animate(withDuration: self.viewModel.tableDataSourceAnimationDuration, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let this = self else { return }
            this.viewControllerHeadder.showDetail(withDetailText: this.viewModel.getDetailScreenTitle())
        }) { finished in
            
        }
    }
    
    private func animateHeaderTo(txtHeader: String){
        
        UIView.animate(withDuration: self.viewModel.tableDataSourceAnimationDuration, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let this = self else { return }
            
            this.viewControllerHeadder.showDetail(withDetailText: txtHeader)
        }) { finished in
            
        }
    }
}

//Guide delegate
extension BOGuideViewController: didPressListDelegate{
    
    func didPressAtIndexPath(indexPath: IndexPath) {
        
        print("DidPress, contentType: ")
        print(viewModel.screenContentType.value)
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
        registerDelegateGuides()
        viewModel.setTableDelegateFor(contentType: .guides)
        viewModel.setTableDataSourceFor(contentType: .guides)
        hideMenu()
    }
    
    private func scrollToTopGuides(){
        
        if viewModel.getGuideListDataSourceNumberOfRows() > 0{
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

//MARK: Setup Content Type Category Detail
extension BOGuideViewController: ShowCategoryDetailForType{
    
    
    func show(categoryDetail: BOCategoryDetail, catItem: BOCatItem, type: Endpoint) {
        changeTo(catDetail: categoryDetail)
    }
    
    func changeTo(catDetail: BOCategoryDetail){
        viewModel.screenContentType.value = .categoryDetail
    }

    func setupForCatDetail(){

        disableTableDelegate()
        animateHeaderToCatDetail()
        if let catTitle = viewModel.detailCategory.value?.categoryTitle {
             animateHeaderTo(txtHeader: catTitle)
        }
        viewModel.setTableDelegateFor(contentType: .categoryDetail)
        viewModel.setTableDataSourceFor(contentType: .categoryDetail)
        hideMenu()
        disableSwipe()
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
        hideMenu()
        disableSwipe()
    }
}

//MARK: Setup Content Type Reykjavik
extension BOGuideViewController{
    
    private func changeToRvkCategories() {
        
        if tableView.delegate != nil{
            viewModel.screenContentType.value = .reykjavik
        }
    }
    
    private func setupForRvk(){
        
        disableTableDelegate()
        registerDelegateRvk()
        viewModel.setTableDelegateFor(contentType: .reykjavik)
        viewModel.setTableDataSourceFor(contentType: .reykjavik)
        viewModel.setCategoryDetailClickDelegate(delegate: self)
        hideMenu()
        enableSwipe()
    }
}

//MARK: Iceland
extension BOGuideViewController{
    
    
    func changeToIceland(){
        viewModel.screenContentType.value = .iceland
    }
    
    func setupForIceland(){
        
        disableTableDelegate()
        registerDelegateIce()
        viewModel.setTableDelegateFor(contentType: .iceland)
        viewModel.setTableDataSourceFor(contentType: .iceland)
        viewModel.setCategoryDetailClickDelegate(delegate: self)
        hideMenu()
        disableSwipe()
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
        setHeaderToFavs()
        hideMenu()
        disableSwipe()
    }
    
    private func setHeaderToFavs(){
        
        viewControllerHeadder.viewModel.isDetailActive.value = true
        viewControllerHeadder.showDetail(withDetailText: "Favourites")
    }
}

//MARK: Subcategories
extension BOGuideViewController{
    
    private func setupForSubcategories(){
        
        if viewModel.screenContentType.value == .guideDetail {
            print("guideDetail, not loading sub categories")
            return
        }
        
        if viewModel.activeTableDataSource.value is BOGuideDetailTableDataSource{
            print("guideDetail, not loading sub cats")
            return
        }
        
        disableTableDelegate()
        registerDelegateSubcategories()
        viewModel.setTableDelegateFor(contentType: .subCategories)
        viewModel.setTableDataSourceFor(contentType: .subCategories)
        hideMenu()
        disableSwipe()
        setHeaderToSubcategory()
    }
    
    private func setHeaderToSubcategory(){
        viewControllerHeadder.viewModel.isDetailActive.value = true
        viewControllerHeadder.showDetail(withDetailText: viewModel.getHeaderDetailTxtFromSubCategory())
    }
    
    private func animateReloadDataSubcategories(){
        
        UIView.transition(with: tableView, duration: viewModel.tableDataSourceAnimationDuration, options: .transitionCrossDissolve, animations: { [weak self] in
            
            guard let this = self else { return }
            this.viewControllerHeadder.viewModel.isDetailActive.value = true
            
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
        //swipeRight?.canBePrevented(by: <#T##UIGestureRecognizer#>)
        
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
            changeToGuides()
            
        case .left:
            if viewModel.shouldChangeToRvkCategoriesFor(tableView: self.tableView){
                print("changeToRvkCategories()")
                changeToRvkCategories()
            }
            
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
        
        self.viewControllerHeadder.viewModel.isHamburgerActive.value = true
    }
}


extension BOGuideViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension BOGuideViewController: DeleteFavouriteItem{
    
    func deleteClicked(deleteItemName: String) {
        reloadTableForFavDeleteAction()
    }
    
    private func reloadTableForFavDeleteAction(){
        
        tableView.reloadData()
    }
}

extension BOGuideViewController{
    
    static func roundCorners(view: UIView, _ corners: UIRectCorner, radius: CGFloat) {
        
        if #available(iOS 11.0, *) {
            view.clipsToBounds = true
            view.layer.cornerRadius = radius
            view.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        }
    }
}
