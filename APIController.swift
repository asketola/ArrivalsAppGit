//
//  APIController.swift
//  FlightAttendantApp
//
//  Created by Annemarie Ketola on 1/19/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ApiController
{
    
    static let sharedInstance = ApiController()
    
    func fetchFlights(airportCode: String, minutesBefore: Int, minutesAfter: Int, completionHandler: @escaping ([Arrivals]?) -> Void)
    {
        let urlString = URL(string: "https://api.qa.alaskaair.net/aag/1/dayoftravel/airports/‬\(airportCode)/flights/flightInfo?minutesBefore=\(minutesBefore)&minutesAfter=\(minutesAfter)")
        
        var urlRequest = URLRequest(url: urlString!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        urlRequest.addValue("0a570f0bf03d46089b7829d7304831e4", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    
        Alamofire.request(urlRequest)
            .response { response in debugPrint(response)
                
        }
        /*let apiTokenHeader : HTTPHeaders = ["Ocp-Apim-Subscription-Key" : "0a570f0bf03d46089b7829d7304831e4", "Accept" : "application/json"]
        
        Alamofire.request(urlString, method: .get, headers: apiTokenHeader).responseJSON {
            response in
            if response.result.isSuccess
            {
                let arrivalData = JSON(response.result.value!)
                completionHandler(Arrivals.createArrivals(arrivalData: arrivalData))
            }
            else{
                print("we didn't have success")
                completionHandler(nil)
            }
        }*/
        
    
    
    }
    
    
}
