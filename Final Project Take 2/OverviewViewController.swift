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
    
    var people = People()
    var personArray = [People.NewPerson()]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        populateFakePersonArray(numberOfPeople: 5)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addPersonPressed(_ sender: Any) {
        
    }
    
    func populateFakePersonArray(numberOfPeople: Int) {
        var count = 0
        repeat {
            var newPerson = People.NewPerson()
            newPerson.name = "Placeholder \(count)"
            newPerson.latitude = 40.0 + Double(count)
            newPerson.longitude = 40.0 - Double(count)
            newPerson.status = "Waiting"
            newPerson.image = "placeholder"
            count += 1
            personArray.append(newPerson)
        } while count < numberOfPeople
    }
    
    func convertPeopleArrayToLocationArray() -> Array<Any> {
        var locationArray = [String]()
        for person in personArray {
            locationArray.append(String(person.latitude) + "," + String(person.longitude))
        }
        return locationArray
    }
    
    func findAverageLocation(arrayOfLocations: Array<Any>) -> String {
        var latitudeArray = [Double]()
        var longitudeArray = [Double]()
        for location in arrayOfLocations {
        latitudeArray.append(Double(separateLatitudeAndLongitude(coordinates: String(describing: location)).0))
            longitudeArray.append(Double(separateLatitudeAndLongitude(coordinates: String(describing: location)).1))
        }
        let averageLat = computeAverage(array: latitudeArray)
        let averageLong = computeAverage(array: longitudeArray)
        let averageCoordinates = String(averageLat) + ", " + String(averageLong)
        return averageCoordinates
    }
    
    
    @IBAction func findLocation(_ sender: UIButton) {
        findAverageLocation(arrayOfLocations: convertPeopleArrayToLocationArray())
    }
    
    //Function to find places given a location
    
    func separateLatitudeAndLongitude(coordinates: String) -> (Int, Int) {
        var combinedArray = coordinates.components(separatedBy: ",")
        var latitude = Int(combinedArray[0])
        var longitude = Int(combinedArray[1])
        return (latitude!, longitude!)
    }
    
    func computeAverage(array: Array<Double>) -> Double {
        var runningSum = 0.0
        var count = 1.0
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
        cell.configurePeopleCell(icon: personArray[indexPath.row].image, name: personArray[indexPath.row].name, latitude: personArray[indexPath.row].latitude, longitude: personArray[indexPath.row].longitude, status: personArray[indexPath.row].status)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
