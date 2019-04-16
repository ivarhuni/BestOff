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
    private let disposeBag = DisposeBag()
    
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
        
        view.backgroundColor = .blue
        setupBindings()
    }
}

//MARK UI Bindings
extension BOGuideViewController{
    
    func setupBindings(){
        
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
        
        _ = viewModel.arrGuideCategory.bind(to: self){ me, array in
            
            print("Detected new value for guide array")
        }
    }
}
