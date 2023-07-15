//
//  MapCoordinator.swift
//  petakopi
//
//  Created by Amree Zaid on 15/07/2023.
//

import MapKit
import Combine

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    var cancellables = Set<AnyCancellable>()
    var didSelectAnnotation: ((MKAnnotation) -> Void)?

    init(_ parent: MapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "Checkpoint"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let checkpoint = view.annotation as? Checkpoint {
            didSelectAnnotation?(checkpoint)
        }
    }
}

protocol MapViewCoordinatorDelegate: AnyObject {
    func didSelectAnnotation(_ annotation: MKAnnotation)
}
