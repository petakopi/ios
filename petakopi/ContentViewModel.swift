//
//  ContentViewModel.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import MapKit

enum MapDetails {
  static let startingLocation = CLLocationCoordinate2D(
      latitude: 37.331516,
      longitude: -121.891054
    )
  static let defaultSpan = MKCoordinateSpan(
      latitudeDelta: 0.05,
      longitudeDelta: 0.05
    )
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var region = MKCoordinateRegion(
      center: MapDetails.startingLocation,
      span: MapDetails.defaultSpan
    )

  var locationManager: CLLocationManager?

  func checkIfLocationServiceIsEnabled() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager = CLLocationManager()
      locationManager!.delegate = self
    } else {
      print("Show alert location not enabled")
    }
  }

  private func checkLocationAuthorization() {
    guard let locationManager = locationManager else { return }

    switch locationManager.authorizationStatus {
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .restricted:
        print("Your location is restricted")
      case .denied:
        print("Your location is denied. Go to Settings to change it")
      case .authorizedAlways, .authorizedWhenInUse:
        region = MKCoordinateRegion(
            center: locationManager.location!.coordinate,
            span: MapDetails.defaultSpan
          )
      @unknown default:
        break
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuthorization()
  }
}
