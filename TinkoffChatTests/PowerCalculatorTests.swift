//
//  PowerCalculatorTests.swift
//  TinkoffChatTests
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import XCTest
@testable import TinkoffChat

class PowerCalculatorTests: XCTestCase {
    
    
    var calculator: PowerCalculator!
    
    override func setUp() {
        super.setUp()
        
        calculator = PowerCalculator()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        calculator = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalculationOfPower() {
        //given
        let a = 2
        let power = 3
        let expectedResult = 8
        
        //when
        let result = calculator.makePow(value: a, power: power)
        
        //then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testCalculationOfZeroPower() {
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
