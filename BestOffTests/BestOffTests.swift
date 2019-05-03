//
//  BestOffTests.swift
//  BestOffTests
//
//  Created by Ivar Johannesson on 05/03/2019.
//  Copyright © 2019 Ivar Johannesson. All rights reserved.
//

import XCTest
import Foundation
@testable import BestOff

class BestOffTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}


extension BestOffTests{
    
    //MARK: Datamodel
    func testCategoryModelJSONMapping() throws {
        
        //1. Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "drinking", withExtension: "json") else {
            XCTFail("Missing file: drinking.json")
            return
        }
        //2. When
        let json = try Data(contentsOf: url)
        let catModel = try JSONDecoder().decode(BOCategoryModel.self, from: json)
        
        //3. Then
        XCTAssert(catModel.title == "The Reykjavik Grapevine", "JSON CategoryModel Mapping throws error")
    }
    
    func testCategoryModelJSONMappingFail() throws {
        
        //1. Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "drinkingFail", withExtension: "json") else {
            XCTFail("Missing file: drinkingFail.json")
            return
        }
        //2. When
        //This json has the title field missing, and hence the decode should fail
        let json = try Data(contentsOf: url)
        
        //3. Then
        XCTAssertThrowsError(try JSONDecoder().decode(BOCategoryModel.self, from: json), "FAIL-JSON actually succeeds")
    }
}

//MARK: Table methods
extension BestOffTests{
    
    func testTblSDataSourceInit() throws{
        
        //1. Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "drinking", withExtension: "json") else {
            XCTFail("Missing file: drinking.json")
            return
        }
        let json = try Data(contentsOf: url)
        let catModel = try JSONDecoder().decode(BOCategoryModel.self, from: json)
        
        //2. When
        let datasource = BOGuideTableDataSource(categoryModel: catModel)
        
        //3. Then
        XCTAssertNotNil(datasource, "Datasource should not be nil when initialized with a valid model")
    }
    
    func testItemAtIndexPath() throws{
        //1. Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "drinking", withExtension: "json") else {
            XCTFail("Missing file: drinking.json")
            return
        }
        let json = try Data(contentsOf: url)
        let catModel = try JSONDecoder().decode(BOCategoryModel.self, from: json)
        let datasource = BOGuideTableDataSource(categoryModel: catModel)
        
        //2. When
        //Check if we get the first and last IDs correct
        let firstItemId = catModel.items[0].id
        let lastItemId = catModel.items.last?.id
        let indexPathFirst = IndexPath(item: 0, section: 0)
        let indexPathLast = IndexPath(item: catModel.items.count - 1, section: 0)
        
        //3. Then
        XCTAssertEqual(firstItemId, datasource.item(at: indexPathFirst)?.id, "Item at index 0 incorrect")
        XCTAssertEqual(lastItemId, datasource.item(at: indexPathLast)?.id, "Item at last index incorrect in BOGuideTableDataSource")
    }
    
    func testNumberOfRows() throws{
     
        //1. Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "drinking", withExtension: "json") else {
            XCTFail("Missing file: drinking.json")
            return
        }
        let json = try Data(contentsOf: url)
        let catModel = try JSONDecoder().decode(BOCategoryModel.self, from: json)
        let datasource = BOGuideTableDataSource(categoryModel: catModel)
        
        //2. When
        let datasourceModelArrayCount = datasource.categoryModel.value?.items.count
        
        //3. Then
        XCTAssert(datasourceModelArrayCount == datasource.numberOfRows(), "Number of rows should be equal to the datamodel array count in Table Datasource")
    }
    
    func testNumberOfSectionsGuide() throws{
        
        //1. Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "guides", withExtension: "json") else {
            XCTFail("Missing file: drinking.json")
            return
        }
        let json = try Data(contentsOf: url)
        let catModel = try JSONDecoder().decode(BOCategoryModel.self, from: json)
        
        //2. When
        let datasource = BOGuideTableDataSource(categoryModel: catModel)
        
        //3. Then
        XCTAssert(datasource.numberOfSections() == 1, "Guides datasource should have numberOfSections = 1")
    }
}

//MARK: ViewModel
extension BestOffTests{

    func testGetCategoryItemsWhenThereAreNone(){
        
        //1. Given
        let viewModel = BOGuideViewModel()
        
        //2. ...When there arent any items...
        
        //3. Then
        XCTAssertTrue(viewModel.getCategoryItems().isEmpty, "getCategoryItems should return 0 items")
    }
    
    func testGetCategoryCount() throws{
        //1. Given
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "drinking", withExtension: "json") else {
            XCTFail("Missing file: drinking.json")
            return
        }
        let json = try Data(contentsOf: url)
        let catModel = try JSONDecoder().decode(BOCategoryModel.self, from: json)
        let viewModel = BOViewModel()
        
        //2. When
        viewModel.category.value = catModel
        
        //3. Then
        XCTAssert(viewModel.getCategoryItems().count == catModel.items.count)
    }
    
    func testShouldViewModelShowErrorTrue(){
        
        //1. Given
        let vm = BOViewModel()
        
        //2. When
        vm.showDataError()
        
        //3. Then
        XCTAssertTrue(vm.shouldShowError.value, "VM should show error after showDataError is called")
    }
    
    func testShouldViewModelShowErrorFalse(){
        //1. Given
        let vm = BOViewModel()
        
        //2. When
        vm.hideDataError()
        
        //3. Then
        XCTAssertFalse(vm.shouldShowError.value, "VM should not show error after hideDataError is called")
    }
}

//MARK: Coordinators
extension BestOffTests{
    
    func testIsGuideVCFirstVCWhenAppStarts(){
        
        //1. Given
        let mainCoord = BOMainCoordinator.init(navigationController: UINavigationController())
        
        //2. When
        mainCoord.start()
        
        //3. Then
        XCTAssert(mainCoord.navController.viewControllers.first! is BOGuideViewController, "First Screen should be guide screen")
    }
}

//MARK: Image Asset Helper
extension BestOffTests{
    
    func testImageAssetHelper() {
        
        //1. Given all the assets in the Assets folder
        Asset.allCases.forEach {strImg in
            
            //2. When
            guard let img = UIImage(named: strImg.rawValue) else{
                
                //3. Then
                XCTFail(strImg.rawValue + "Failed to initialize in Asset Helper")
                return
            }
            
            //3. Then
            XCTAssertNotNil(img)
        }
    }
}
