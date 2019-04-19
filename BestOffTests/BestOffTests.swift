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

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
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
    
    //MARK: Table Data Source
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
    
    func testNumberOfSections() throws{
        
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
        datasource.categoryModel.value.
        
        //3. Then
        XCTAssert(datasourceModelArrayCount == datasource.numberOfRows(), "Number of rows should be equal to the datamodel array count in Table Datasource")
    }
    

}
