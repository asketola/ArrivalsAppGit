//
//  StorageProcessorTests.swift
//  FlightArrivalAppTests
//
//  Created by Annemarie Ketola on 1/27/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import XCTest
import Foundation
import CoreData
import UIKit
@testable import FlightArrivalApp

class StorageProcessorTests: XCTestCase {
    
    var storageProcessor = StorageProcessor()

    override func setUp() {
        storageProcessor.deletePreviousArrivals()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testStoreAirportCode()
    {
        let airportCode = "SEA"
        storageProcessor.storeAirportCode(airportCode: airportCode)
        
        let previousAirportCode = storageProcessor.getPreviousAirportCode()
        XCTAssertEqual(airportCode, previousAirportCode, "The StorageProcessor should fetch the saved airportCode")
    }
    
    func testStoreTimeStamp()
    {
        storageProcessor.storeTimestamp()
        
        let fetchedTimestamp = storageProcessor.getTimestamp()
        XCTAssertNotNil(fetchedTimestamp, "The StorageProcessor should retrieve the stored timestamp")
    }
    
    func testStoreArrival()
    {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        
        let testArrival = Arrival2.init(entity: .entity(forEntityName: "Arrival2", in:managedContext)!, insertInto: managedContext)
        
        testArrival.fltId = "1234"
        testArrival.dest = "SEA"
        testArrival.orig = "LAS"
        testArrival.destZuluOffset = "testTime"
        testArrival.estArrTime = "testTimeArr"
        testArrival.schedArrTimeString = "testTimeEst"
        
        storageProcessor.storeArrival(singleArrival: testArrival)
        
        let fetchedArrival = storageProcessor.getFlightData()
        let fetchedArrivalCount = fetchedArrival?.count
        XCTAssertEqual(testArrival.fltId, fetchedArrival![0].fltId, "The StorageProcessor should retrieve the saved arrival")
    }
    
    func testDeleteOldArrivals()
    {
        let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
        let managedContext =
            appDelegate!.persistentContainer.viewContext
        
        let testArrival = Arrival2.init(entity: .entity(forEntityName: "Arrival2", in:managedContext)!, insertInto: managedContext)
        
        testArrival.fltId = "1234"
        testArrival.dest = "SEA"
        testArrival.orig = "LAS"
        testArrival.destZuluOffset = "testTime"
        testArrival.estArrTime = "testTimeArr"
        testArrival.schedArrTimeString = "testTimeEst"
        
        let fetchedArrival = storageProcessor.getFlightData()
        XCTAssertGreaterThanOrEqual((fetchedArrival?.count)!, 0)
        
        storageProcessor.deletePreviousArrivals()
        let fetchedDeletedArrivals = storageProcessor.getFlightData()
        let fetchedDeletedArrivalsCount = fetchedDeletedArrivals?.count
        XCTAssertEqual(0, fetchedDeletedArrivalsCount, "The StorageProcessor should delete all the arrivals")
        
    }

}
