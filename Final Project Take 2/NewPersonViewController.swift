//
//  NewPersonViewController.swift
//  Final Project Take 2
//
//  Created by Nick on 4/30/17.
//  Copyright © 2017 Nick Ryan. All rights reserved.
//

import UIKit
import GooglePlaces

/*
 steps
 1. add new location
 2. return to VC
 3. add new locations
 4. return to VC
 */

class NewPersonViewController: UIViewController {
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    var overviewViewController = OverviewViewController()
    var newPerson = OverviewViewController.NewPerson()
    var didChooseLocation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("***** viewDidLoad NPVC \(overviewViewController.personArray)")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func locationPicker(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    //    @IBAction func savePerson(_ sender: UIButton) {
    //
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SavePerson" {
            var nameTest = nameField.text
            let controller = segue.destination as! OverviewViewController
            print("***** Prepare before segue and before append \(controller.personArray)")
            if didChooseLocation == true {
                if let name = nameTest {
                    controller.newNamePlaceholder = nameField.text!
                    controller.newLatPlaceholder = newPerson.latitude
                    controller.newLongPlaceholder = newPerson.longitude
                    controller.newDistancePlaceholder = 0.0
                    controller.newFormattedAddressPlaceholder = newPerson.formattedAddress
                }
                //working append
                controller.personArray.append(OverviewViewController.NewPerson(name: nameField.text!, latitude: newPerson.latitude, longitude: newPerson.longitude, formattedAddress: newPerson.formattedAddress, distance: 0.0))
                print("***** Prepare before segue but after append \(controller.personArray)")
            } else {
                errorMessage.isHidden = false
            }
        }
    }
}

extension NewPersonViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        var location: String
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        locationAddressLabel.text = place.formattedAddress
        locationNameLabel.text = place.name
        location = String(lat) + String(long)
        dismiss(animated: true, completion: nil)
        newPerson.latitude = Double(lat)
        newPerson.longitude = Double(long)
        newPerson.formattedAddress = place.formattedAddress!
        didChooseLocation = true
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
