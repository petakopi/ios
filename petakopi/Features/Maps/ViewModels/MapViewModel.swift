//
//  MapViewModel.swift
//  petakopi
//
//  Created by Amree Zaid on 15/07/2023.
//

import Combine
import MapKit

class MapViewModel: ObservableObject {
    let centerOnUserPublisher = PassthroughSubject<Void, Never>()
    var mapView: MKMapView? = nil

    func unselect(annotation: MKAnnotation) {
        mapView?.deselectAnnotation(annotation, animated: true)
    }
}
