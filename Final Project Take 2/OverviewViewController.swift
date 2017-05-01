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
    var milesPerDegreeLatitude = 69.0
    var milesPerDegreeLongitude = 54.6
    
    var chosenPlaceName = ""
    var chosenPlaceLat = 0.0
    var chosenPlaceLong = 0.0
    var chosenPlaceAddress = ""
    var placeChosen = false
    
    @IBOutlet weak var locationTextField: UITextView!
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
    
    
    @IBAction func unwindFromStudentDetailView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as?
            NewPersonViewController {
            let name = sourceViewController.nameField.text
            let lat = sourceViewController.newPersonLatitude
            let long = sourceViewController.newPersonLongitude
            let distance = sourceViewController.newPersonDistance
            let formattedAddress = sourceViewController.newPersonFormattedAddress
            addPersonToArray(name: name!, latitude: lat, longitude: long, formattedAddress: formattedAddress, distance: distance)
            let newIndexPath = IndexPath(row: personArray.count-1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            // Bonus below - scroll to the end!
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
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
        self.chosenPlaceLat = place.coordinate.latitude
        self.chosenPlaceLong = place.coordinate.longitude
        self.chosenPlaceName = place.name
        self.chosenPlaceAddress = place.formattedAddress!
        self.locationTextField.text = "\(place.name) - \(self.chosenPlaceAddress)"
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
        self.calculateDistanceFromChosenPoint(latitude: self.chosenPlaceLat, longitude: self.chosenPlaceLong, array: &self.personArray)
        self.placeChosen = true
    })
}
    
    func calculateDistanceFromChosenPoint(latitude: Double, longitude: Double, array: inout Array<NewPerson>) {
        var distanceArrays = [Double]()
        for person in array {
            var latitudeDistance = latitude - person.latitude
            var longitudeDistance = longitude - person.longitude
            var latMiles = latitudeDistance * milesPerDegreeLatitude
            var longMiles = longitudeDistance * milesPerDegreeLongitude
            var totalDistance = sqrt(squareValue(value: latMiles) + squareValue(value: longMiles))
            totalDistance = round(100.0 * totalDistance) / 100.0
            distanceArrays.append(Double(totalDistance))
            //person.distance = totalDistance
        }
        var count = 0
        for member in distanceArrays {
            personArray[count].distance = member
            count += 1
        }
        tableView.reloadData()
    }
    
    func squareValue(value: Double) -> Double {
        let squaredValue = value * value
        return squaredValue
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
        cell.configurePeopleCell(name: personArray[indexPath.row].name, latitude: personArray[indexPath.row].latitude, longitude: personArray[indexPath.row].longitude, address: personArray[indexPath.row].formattedAddress, distance: personArray[indexPath.row].distance, placeChosen: placeChosen)
        print(personArray[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
