//
//  GeoPoint+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import CoreLocation
import FirebaseFirestore

extension GeoPoint{
    
    var toLocation2D : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
