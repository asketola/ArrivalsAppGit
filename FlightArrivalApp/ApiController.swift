//
//  ApiController.swift
//  FlightArrivalApp
//
//  Created by Annemarie Ketola on 1/21/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class ApiController
{
    
    static let sharedInstance = ApiController()
    
    func fetchFlights(airportCode: String, minutesBefore: Int, minutesAfter: Int, completionHandler: @escaping ([Arrival2]?) -> Void)
    {
        let urlString1 = "https://api.qa.alaskaair.net/aag/1/dayoftravel/airports/\(airportCode)/flights/flightInfo?minutesBefore=10&minutesAfter=120"
        let urlString = urlString1
        
        let apiTokenHeader : HTTPHeaders = ["Ocp-Apim-Subscription-Key" : "0a570f0bf03d46089b7829d7304831e4", "Accept" : "application/json"]
         
         AF.request(urlString, method: .get, headers: apiTokenHeader).responseJSON {
         response in
             if response.result.isSuccess
             {
             let arrivalData = JSON(response.result.value!)
                completionHandler(self.createArrivals(arrivalData: arrivalData))
             }
             else
             {
             print("we didn't have success")
             completionHandler(nil)
             }
         }
    }
    
    func createArrivals(arrivalData: JSON) -> Array<Arrival2>
    {
        var arrivalsArray = Array<Arrival2>()
        if let dataFromJson = arrivalData.array
        {
            for i in 0..<dataFromJson.count
            {
                let data = dataFromJson[i]
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return arrivalsArray
                }
                let managedContext =
                    appDelegate.persistentContainer.viewContext
                
                let newArrival = Arrival2.init(entity: .entity(forEntityName: "Arrival2", in:managedContext)!, insertInto: managedContext)
                
                newArrival.fltId = data["FltId"].stringValue
                newArrival.orig = data["Orig"].stringValue
                newArrival.dest = data["Dest"].stringValue
                
                let schedDateStringRaw = data["SchedArrTime"].stringValue
                let schedDate = formatStringToDate(date: schedDateStringRaw)
                let schedString = formateDateToString(dateObject: schedDate)
                
                newArrival.schedArrTimeDate = schedDate
                newArrival.schedArrTimeString = schedString
                
                newArrival.estArrTime = data["EstArrTime"].stringValue
                newArrival.destZuluOffset = data["DestZuluOffset"].stringValue
                arrivalsArray.append(newArrival)
            }
        }
        arrivalsArray.sort(by:{ $0.schedArrTimeDate!.compare($1.schedArrTimeDate!) == .orderedAscending })
        return arrivalsArray
    }
    
    func formateDateToString(dateObject: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: dateObject)
        
    }
    
    func formatStringToDate(date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: date)!
    }
    
    
}
