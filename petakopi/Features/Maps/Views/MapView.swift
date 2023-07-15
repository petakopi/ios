//
//  MapView.swift
//  petakopi
//
//  Created by Amree Zaid on 09/07/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var checkpoints: [Checkpoint]
    @ObservedObject var viewModel: MapViewModel

    var locationManager = CLLocationManager()
    var didSelectAnnotation: ((MKAnnotation) -> Void)?

    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func makeCoordinator() -> MapViewCoordinator {
        let coordinator = MapViewCoordinator(self)
        coordinator.didSelectAnnotation = didSelectAnnotation

        return coordinator
    }

    func makeUIView(context: Context) -> MKMapView {
        setupManager()

        let mapView = MKMapView(frame: UIScreen.main.bounds)

        viewModel.mapView = mapView
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
