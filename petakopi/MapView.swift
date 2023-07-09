//
//  MapView.swift
//  petakopi
//
//  Created by Amree Zaid on 09/07/2023.
//

import SwiftUI
import MapKit
import Combine

struct MapView: UIViewRepresentable {
    @Binding var checkpoints: [Checkpoint]
    @ObservedObject var viewModel: MapViewModel

    var locationManager = CLLocationManager()

    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        setupManager()

        let mapView = MKMapView(frame: UIScreen.main.bounds)

        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        viewModel.centerOnUserPublisher
            .sink { [weak mapView] _ in
                self.centerMapOnUserLocation(mapView)
            }
            .store(in: &context.coordinator.cancellables)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.addAnnotations(checkpoints)
    }

    private func centerMapOnUserLocation(_ mapView: MKMapView?) {
        if let userLocation = mapView?.userLocation.location {
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate,
                                                      latitudinalMeters: regionRadius,
                                                      longitudinalMeters: regionRadius)
            mapView?.setRegion(coordinateRegion, animated: true)
        }
    }
}

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

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    var cancellables = Set<AnyCancellable>()

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
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let checkpoint = view.annotation as? Checkpoint, let urlString = checkpoint.subtitle, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
