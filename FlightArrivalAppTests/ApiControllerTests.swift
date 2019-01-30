//
//  ApiControllerTests.swift
//  FlightArrivalAppTests
//
//  Created by Annemarie Ketola on 1/27/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import XCTest
import Foundation
import CoreData
@testable import FlightArrivalApp

class ApiControllerTests: XCTestCase {
    
    var apiController = ApiController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFormateDateToString()
    {
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 1
        dateComponents.day = 28
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour = 7
        dateComponents.minute = 40
        dateComponents.second = 0
        let userCalendar = Calendar.current
        let testDate = userCalendar.date(from: dateComponents)

        let expectedDateString = "11:40 PM" // 8hrs diff
        let stringDate = apiController.formateDateToString(dateObject: testDate!)

        XCTAssertEqual(expectedDateString, stringDate, "The apiController should create a string version")
    }
    
    func testFormatStringToDate()
    {
        let testString = "2019-01-28T07:40:00"
        
        var dateComponents = DateComponents()
        dateComponents.year = 2019
        dateComponents.month = 1
        dateComponents.day = 28
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour = (7 + 8) // 8hrs diff
        dateComponents.minute = 40
        dateComponents.second = 0
        let userCalendar = Calendar.current
        let expectedDate = userCalendar.date(from: dateComponents)
        
        let dateResult = apiController.formatStringToDate(date: testString)
        
        XCTAssertEqual(expectedDate, dateResult, "The apiController should create a date version")
    }
    
    /*func testCreateArrivals()
    {
        let jsonString = "[{\"FltId\":\"20\",\"Carrier\":\"AS\",\"Orig\":\"SEA\",\"Dest\":\"ORD\",\"CutOffTime\":\"40\",\"FltDirection\":0,\"SchedDepTime\":\"2019-01-27T17:50:00\",\"EstDepTime\":\"2019-01-27T17:50:00\",\"SchedArrTime\":\"2019-01-27T23:40:00\",\"EstArrTime\":\"2019-01-27T23:40:00\",\"ActualTime\":\"\",\"OrigZuluOffset\":\"-8\",\"DestZuluOffset\":\"-6\",\"DestGate\":\"H4\",\"OrigGate\":\"\",\"CodeShares\":[{\"FltId\":\"\",\"Carrier\":\"\"}],\"TailId\":\"224\",\"FleetType\":\"737-900R\",\"Status\":\"ON TIME\"}]"
         
         // TODO: turn into JSON
            
        
        let testArrival = Arrival2()
        testArrival.fltId = "20"
        testArrival.dest = "ORD"
        testArrival.orig = "SEA"
        testArrival.destZuluOffset = "-6"
        testArrival.estArrTime = "2019-01-27T23:40:00"
        testArrival.schedArrTimeString = "11:40 PM"
        testArrival.schedArrTimeDate = 2019-01-27T23:40:00
        
        let expectedResult =
        
        let dataResult = apiController.createArrivals(arrivalData: jsonString)
        let dataResultZero = dataResult[0]
        XCTAssertEqual(testArrival.fltId, dataResultZero.fltId)
        XCTAssertEqual(testArrival.orig, dataResultZero.orig)
        XCTAssertEqual(testArrival.destZuluOffset, dataResultZero.destZuluOffset)
    }*/
}
