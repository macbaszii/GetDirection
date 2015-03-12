//
//  ViewController.swift
//  GetDirection
//
//  Created by Kiattisak Anoochitarom on 3/12/2558 BE.
//  Copyright (c) 2558 Kiattisak Anoochitarom. All rights reserved.
//

import UIKit
import CMMapLauncher;
import CoreLocation;

class ViewController: UIViewController {

    @IBOutlet var latitudeField: UITextField!
    @IBOutlet var longitudeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
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
        } else {
            getDirectionByAppleMaps(chooseLocation)
        }
    }
    
    private func getDirectionByAppleMaps(coordinate: CLLocationCoordinate2D) {
        
    }
    
    private func getDirectionByGoogleMap(coodinate: CLLocationCoordinate2D) {
        
    }
}

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

