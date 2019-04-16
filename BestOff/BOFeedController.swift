//
//  ViewController.swift
//  BestOff
//
//  Created by Ivar Johannesson on 05/03/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond


class BOFeedController: UIViewController {
    
    //MARK: Init
    fileprivate let viewModel = BOFeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }
}

//MARK: Styling & Bindings
extension BOFeedController{
    
    fileprivate func setup(){
        setupBindings()
    }
    
    fileprivate func setupBindings(){
        
        //        _ = viewModel.arrData.observeOn(.main).observeNext(with: { (arrCourses) in
        //            arrCourses.isEmpty ? self.style(.emptyOrError) : self.style(.success)
        //        })
    }
    
    fileprivate func style(_ type: BOFeedViewModel.styleType){
        switch type {
        case .success:
            view.backgroundColor = .green
        case .emptyOrError:
            view.backgroundColor = .red
        }
    }
}

fileprivate struct BOFeedViewModel{
    
    fileprivate enum styleType{
        case success
        case emptyOrError
    }
    
    //fileprivate let arrData = Observable<[BOCategoryProtocol]>([])
    
    init(){
        
        let shoppingService = BOCategoryService()
        
        shoppingService.getCategory(.rvkShopping) { (model, error) in
            if(error != nil){
                print(error!)
            }
        }
        
        let diningService = BOCategoryService()
        diningService.getCategory(.rvkDining) { (model, error) in
            if(error != nil){
                print(error!)
            }
        }
        
        let drinkingSerivce = BOCategoryService()
        drinkingSerivce.getCategory(.rvkDrink) { (model, error) in
            if(error != nil){
                print(error!)
            }
        }
        
        let activityService = BOCategoryService()
        activityService.getCategory(.rvkActivities) { (model, error) in
            if(error != nil){
                print(error!)
            }
        }
        
        shoppingService.getCategory(.guides) { (model, error) in
            if(error != nil){
                print(error!)
            }
        }
    }
}
