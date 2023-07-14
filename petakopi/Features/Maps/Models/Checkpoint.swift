//
//  Checkpoint.swift
//  petakopi
//
//  Created by Amree Zaid on 15/07/2023.
//

import MapKit

final class Checkpoint: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
