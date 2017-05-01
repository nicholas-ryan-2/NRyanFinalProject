//
//  ViewController.swift
//  Final Project Take 2
//
//  Created by Nick on 4/24/17.
//  Copyright © 2017 Nick Ryan. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

class OverviewViewController: UIViewController {
    
    var personArray = [NewPerson]()
    var newNamePlaceholder = ""
    var newLatPlaceholder = 0.0
    var newLongPlaceholder = 0.0
    var newFormattedAddressPlaceholder = ""
    var newDistancePlaceholder = 0.0
    
    struct NewPerson {
        var name = ""
        var latitude = 0.0
        var longitude = 0.0
        var formattedAddress = ""
        var distance = 0.0
    }
    func addPersonToArray(name: String, latitude: Double, longitude: Double, formattedAddress: String, distance: Double) {
        var newPerson = NewPerson(name: name, latitude: latitude, longitude: longitude, formattedAddress: formattedAddress, distance: distance)
        personArray.insert(newPerson, at: personArray.count)
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addPersonPressed(_ sender: Any) {
        
    }
    
    func convertPeopleArrayToLocationArray() -> Array<Any> {
        var locationArray = [String]()
        for person in personArray {
            locationArray.append(String(person.latitude) + "," + String(person.longitude))
        }
        print(locationArray)
        return locationArray
    }
    
    func findAverageLocation(arrayOfLocations: Array<Any>) -> String {
        var latitudeArray = [Double]()
        var longitudeArray = [Double]()
        for location in arrayOfLocations {
            print(location)
        latitudeArray.append(Double(separateLatitudeAndLongitude(coordinates: String(describing: location)).0))
            longitudeArray.append(Double(separateLatitudeAndLongitude(coordinates: String(describing: location)).1))
        }
        let averageLat = computeAverage(array: latitudeArray)
        let averageLong = computeAverage(array: longitudeArray)
        let averageCoordinates = String(averageLat) + ", " + String(averageLong)
        return averageCoordinates
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("***** Unwind before adding \(personArray)")
        addPersonToArray(name: newNamePlaceholder, latitude: newLatPlaceholder, longitude: newLongPlaceholder, formattedAddress: newFormattedAddressPlaceholder, distance: newDistancePlaceholder)
        print("***** Unwind after adding \(personArray)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPerson" {
            print("***** Prepare before segue for adding \(personArray)")
        }
    }
    
    
    @IBAction func findLocation(_ sender: UIButton) {
        let averageArray = findAverageLocation(arrayOfLocations: convertPeopleArrayToLocationArray()).components(separatedBy: ", ")
        let center = CLLocationCoordinate2D(latitude: Double(averageArray[0])!, longitude: Double(averageArray[1])!)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001,
                                               longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001,
                                               longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            
            print("Place name \(place.name)")
            
            print("Place address \(place.formattedAddress)")
            print("Place attributions \(place.attributions)")
        })
    }
    
    //Function to find places given a location
    
    func separateLatitudeAndLongitude(coordinates: String) -> (Double, Double) {
        var combinedArray = coordinates.components(separatedBy: ",")
        print(combinedArray)
        print(coordinates)
        var latitude = Double(combinedArray[0])
        var longitude = Double(combinedArray[1])
        print(latitude)
        print(longitude)
        return (latitude!, longitude!)
    }
    
    func computeAverage(array: Array<Double>) -> Double {
        var runningSum = 0.0
        var count = 0.0
        for value in array {
            runningSum += value
            count += 1.0
        }
        let average = runningSum / count
        print(average)
        return average
    }
}

extension OverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Person", for: indexPath) as! PeopleCell
        cell.configurePeopleCell(name: personArray[indexPath.row].name, latitude: personArray[indexPath.row].latitude, longitude: personArray[indexPath.row].longitude, address: personArray[indexPath.row].formattedAddress)
        print(personArray[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
