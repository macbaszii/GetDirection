//
//  ViewController.swift
//  GetDirection
//
//  Created by Kiattisak Anoochitarom on 3/12/2558 BE.
//  Copyright (c) 2558 Kiattisak Anoochitarom. All rights reserved.
//

import UIKit
import CMMapLauncher
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
        var chooseLocation = CLLocationCoordinate2DMake(latitudeField.text.toDouble() ?? 0.0, longitudeField.text.toDouble() ?? 0.0)
        
        if CMMapLauncher.isMapAppInstalled(.GoogleMaps) {
            var alert = UIAlertController(title: "Get Direction", message: "from following apps", preferredStyle: .ActionSheet)
            alert.addAction(UIAlertAction(title: "Apple Maps", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                
                self.getDirectionByAppleMaps(chooseLocation)
            }))
            alert.addAction(UIAlertAction(title: "Google Maps", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                self.getDirectionByGoogleMap(chooseLocation)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            getDirectionByAppleMaps(chooseLocation)
        }
    }
    
    private func getDirectionByAppleMaps(coordinate: CLLocationCoordinate2D) {
        var url = String(format: "http://maps.apple.com/?daddr=%f,+%f&saddr=%f,+%f", currentCoordinate!.latitude, currentCoordinate!.longitude, coordinate.latitude, coordinate.longitude)
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    private func getDirectionByGoogleMap(coodinate: CLLocationCoordinate2D) {
        getDirectionBy(.GoogleMaps, coordinate: coodinate)
    }
    
    private func getDirectionBy(app: CMMapApp, coordinate: CLLocationCoordinate2D) {
        if let _ = currentCoordinate {
            CMMapLauncher.launchMapApp(app, forDirectionsTo: CMMapPoint(coordinate: coordinate))
        }
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

