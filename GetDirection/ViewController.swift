//
//  ViewController.swift
//  GetDirection
//
//  Created by Kiattisak Anoochitarom on 3/12/2558 BE.
//  Copyright (c) 2558 Kiattisak Anoochitarom. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    @IBOutlet var latitudeField: UITextField!
    @IBOutlet var longitudeField: UITextField!
    @IBOutlet var getDirectionButton: UIButton!
    
    var locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test with Siam Paragon's Coordinate
        self.latitudeField.text = "13.746388"
        self.longitudeField.text = "100.53494"
        
        getDirectionButton.enabled = false
        setupCoreLocation()
    }
}

extension ViewController {
    private func setupCoreLocation() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    @IBAction func getDirection() {
        var chosenLocation = CLLocationCoordinate2DMake(latitudeField.text.toDouble() ?? 0.0, longitudeField.text.toDouble() ?? 0.0)
        var alert = UIAlertController(title: "Get Direction", message: "from following apps", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            
            self.getDirectionBy(.AppleMaps, coordinate: chosenLocation)
        }))
        alert.addAction(UIAlertAction(title: "Google Maps", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            
            if self.isGoogleMapsAppInstalled() {
                self.getDirectionBy(.GoogleMaps, coordinate: chosenLocation)
            } else {
                self.getDirectionBy(.GoogleMapsWebsite, coordinate: chosenLocation)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func getDirectionBy(map: AvailableMaps, coordinate: CLLocationCoordinate2D) {
        if let userCoordinate = currentCoordinate {
            var url = NSURL(string: String(format: map.urlFormat(), userCoordinate.latitude, userCoordinate.longitude, coordinate.latitude, coordinate.longitude))
            if let openingURL = url {
                UIApplication.sharedApplication().openURL(openingURL)
            }
        }
        
    }
    
    private func isGoogleMapsAppInstalled() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        getDirectionButton.enabled = true
        var currentLocation = locations.last as? CLLocation
        currentCoordinate = currentLocation?.coordinate
    }
}

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

