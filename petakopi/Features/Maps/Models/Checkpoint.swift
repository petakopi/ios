//
//  Checkpoint.swift
//  petakopi
//
//  Created by Amree Zaid on 15/07/2023.
//

import MapKit

final class Checkpoint: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let data: CoffeeShop

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, data: CoffeeShop) {
        self.title = title
        self.coordinate = coordinate
        self.data = data
    }
}
