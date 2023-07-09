//
//  MapView.swift
//  petakopi
//
//  Created by Amree Zaid on 09/07/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var locationManager = CLLocationManager()

    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func makeUIView(context: Context) -> MKMapView {
        setupManager()

        let mapView = MKMapView(frame: UIScreen.main.bounds)

        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}
