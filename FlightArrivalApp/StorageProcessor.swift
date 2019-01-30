//
//  StorageProcessor.swift
//  FlightAttendantApp
//
//  Created by Annemarie Ketola on 1/20/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class StorageProcessor {
    
    static let sharedInstance = StorageProcessor()
    
    func storeTimestamp()
    {
        let currentDate = Date().timeIntervalSinceReferenceDate
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Timestamp1")

        do
        {
            let oldTimestamps = try managedContext.fetch(fetchRequest)
            if oldTimestamps.count > 0
            {
            for timestamp in oldTimestamps
            {
                let timeToDelete = timestamp as! NSManagedObject
                managedContext.delete(timeToDelete)
                    do
                    {
                        try managedContext.save()
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
        }
        catch
        {
            print(error)
        }

        let entity =
            NSEntityDescription.entity(forEntityName: "Timestamp1",
                                       in: managedContext)!
        
        let timeStamp = NSManagedObject(entity: entity,
                                        insertInto: managedContext)

        timeStamp.setValue(currentDate, forKeyPath: "time")

        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func storeAirportCode(airportCode: String)-> Void
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AirportCode")

        do
        {
            let oldAirportCodes = try managedContext.fetch(fetchRequest)
            if oldAirportCodes.count > 0
            {
                for airport in oldAirportCodes
                {
                    let airportToDelete = airport as! NSManagedObject
                    managedContext.delete(airportToDelete)
                        do
                        {
                            try managedContext.save()
                        }
                        catch
                        {
                            print(error)
                        }
                }
            }
        }
        catch
        {
            print(error)
        }

        let entity =
            NSEntityDescription.entity(forEntityName: "AirportCode",
                                       in: managedContext)!
        
        let timeStamp = NSManagedObject(entity: entity,
                                     insertInto: managedContext)

        timeStamp.setValue(airportCode, forKeyPath: "code")

        do
        {
            try managedContext.save()
            //people.append(person)
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deletePreviousArrivals()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
        return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Arrival2")

        do
        {
        let oldArrivals = try managedContext.fetch(fetchRequest)
            if oldArrivals.count > 0 {
                for arrival in oldArrivals {
                    let arrivalToDelete = arrival as! NSManagedObject
                    managedContext.delete(arrivalToDelete)
                    do
                    {
                        try managedContext.save()
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
        }
        catch
        {
        print(error)
        }
    }
    

    
    func storeArrival(singleArrival: Arrival2)-> Void
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Arrival2",
                                       in: managedContext)!
        
        let arrival = NSManagedObject(entity: entity,
                                        insertInto: managedContext)

        arrival.setValue(singleArrival.fltId, forKeyPath: "fltId")
        arrival.setValue(singleArrival.orig, forKeyPath: "orig")
        arrival.setValue(singleArrival.dest, forKeyPath: "dest")
        arrival.setValue(singleArrival.schedArrTimeString, forKeyPath: "schedArrTimeString")
        arrival.setValue(singleArrival.schedArrTimeDate, forKeyPath: "schedArrTimeDate")
        arrival.setValue(singleArrival.estArrTime, forKeyPath: "estArrTime")
        arrival.setValue(singleArrival.destZuluOffset, forKeyPath: "destZuluOffset")

        do
        {
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getPreviousAirportCode()->String?
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return "Could not fetch"
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "AirportCode")
        var airportCodes = [NSManagedObject]()
        
        do
        {
            airportCodes = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let singleAirportCode = airportCodes[0]
        let code = singleAirportCode.value(forKeyPath: "code") as! String
        return code
    }
    
    func getFlightData()->Array<Arrival2>?
    {
        var flights = Array<Arrival2>()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return flights
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Arrival2")

        do
        {
            flights = try managedContext.fetch(fetchRequest) as! [Arrival2]
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return flights
    }
    
    func getTimestamp()->TimeInterval?
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return 0.0
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Timestamp1")
        var timeStamps = [NSManagedObject]()
        
        do
        {
            timeStamps = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if timeStamps.count > 0
        {
            let lastTimestamp = timeStamps[0]
            let timeAsDouble = lastTimestamp.value(forKeyPath: "time")
            return timeAsDouble as? TimeInterval
        }
        return 0.0
    }
}
