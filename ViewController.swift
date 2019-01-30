//
//  ViewController.swift
//  FlightAttendantApp
//
//  Created by Annemarie Ketola on 1/19/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var BannerLogo: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AirportCodeTextfield: UITextField!
    @IBOutlet weak var AirportCodeLabel: UILabel!
    @IBOutlet weak var ArrivalsLabel: UILabel!
    @IBOutlet weak var ArrivalsTable: UITableView!
    @IBOutlet weak var GoButton: UIButton!
    
    let minutesBefore = 10 // minutes, 600 seconds
    let minutesAfter = 120 // minutes, 7200 seconds
    var airportCode = "SEA" //default SEA
    var refreshTimer = Timer()
    
    var arrivalsInfo = Array<Arrival2>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AirportCodeTextfield.delegate = self
        checkTimestamp()
        createLiveTimer()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        TitleLabel.text = "Find Arrival Information"
        AirportCodeLabel.text = "Airport Code"
        ArrivalsLabel.text = "Arrivals"
        
        if let previousAirportCode = StorageProcessor.sharedInstance.getPreviousAirportCode()
        {
            airportCode = previousAirportCode
        }
        AirportCodeTextfield.text = airportCode
        
        if let storedFlights = StorageProcessor.sharedInstance.getFlightData()
        {
            arrivalsInfo = storedFlights
            ArrivalsTable.reloadData()
        }
    }
    
    func checkTimestamp()
    {   let timeIsTooOld = 10.0 * 60.0
        let now = Date().timeIntervalSinceReferenceDate
        if let oldTimestamp = StorageProcessor.sharedInstance.getTimestamp()
        {
            let timeDifference = (now - oldTimestamp)
            if timeDifference > timeIsTooOld
            {
                if let previousAirportCode = StorageProcessor.sharedInstance.getPreviousAirportCode()
                {
                    airportCode = previousAirportCode
                }
                AirportCodeTextfield.text = airportCode
                RefreshApiCallForArrivalsInfo()
            } 
        }
    }
    
    func createLiveTimer()
    {
        let tenMinutes = 10.0 * 60.0
        refreshTimer = Timer.scheduledTimer(withTimeInterval: tenMinutes, repeats: true, block: { (Timer) in
            self.RefreshApiCallForArrivalsInfo()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrivalsInfo.count > 0
        {
        return arrivalsInfo.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("Arrivals info from tableView \(arrivalsInfo.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightResultsCell") as! FlightResultsTableViewCell
        let arrivalForRow = arrivalsInfo[indexPath.row]
        
        cell.FltIdLabel?.text = arrivalForRow.value(forKeyPath: "fltId") as? String
        cell.OriginLabel?.text = arrivalForRow.value(forKeyPath: "orig") as? String
        
        cell.SchedArrTimeLabel?.text = arrivalForRow.value(forKeyPath: "schedArrTimeString") as? String
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        AirportCodeTextfield.text = ""
    }
    
    @IBAction func GoButtonPressed(_ sender: Any)
    {
        if AirportCodeTextfield.text!.count == 3
        {
            airportCode = AirportCodeTextfield.text!
            RefreshApiCallForArrivalsInfo()
        }
        else
        {
            alertForAirportCode()
        }
    }
    
    func alertForAirportCode()
    {
        let alert = UIAlertController(title: "Alert", message: "Please add valid airport code", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.AirportCodeTextfield.text = ""
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if AirportCodeTextfield.text!.count == 3
        {
            textField.resignFirstResponder()
            airportCode = AirportCodeTextfield.text!
            RefreshApiCallForArrivalsInfo()
            return true
        }
        else
        {
            alertForAirportCode()
            return true
        }
    }
    
    func RefreshApiCallForArrivalsInfo()
    {
        StorageProcessor.sharedInstance.deletePreviousArrivals()
        ApiController.sharedInstance.fetchFlights(airportCode: airportCode, minutesBefore: minutesBefore, minutesAfter: minutesAfter) { (arrivalData) in
            if let list = arrivalData
            {
                self.arrivalsInfo = list
                print("from refreshAPICall count \(self.arrivalsInfo.count)")
                self.ArrivalsTable.reloadData()
                StorageProcessor.sharedInstance.storeTimestamp()
                StorageProcessor.sharedInstance.storeAirportCode(airportCode: self.AirportCodeTextfield.text!)
            }
        }
    }
    
}
