//
//  Monu.swift
//  AppTristanVarciat 1.1
//
//  Created by Tristan Varciat on 03/12/2020.
//  Copyright © 2020 Tristan Varciat. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Monu : MKPointAnnotation {
    
    //MARK: Properties
    var id: String
    var name: String
    var photo: UIImage?
    var details: String
    var longitude: Double
    var latitude: Double
    var adress: String
    var website: String
    
    init?(id: String, name: String, photo: UIImage?, details:String, longitude:Double, latitude:Double, adress:String, website:String) {
       
    guard !name.isEmpty else {
               return nil
           }
self.id = id
       // Initialize stored properties.
       self.name = name
       self.photo = photo
        self.details = details
        self.longitude = longitude
        self.latitude = latitude
        self.adress = adress
        self.website = website
   }
}
