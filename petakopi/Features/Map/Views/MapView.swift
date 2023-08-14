//
//  MapView.swift
//  petakopi
//
//  Created by Amree Zaid on 13/08/2023.
//

import SwiftUI
import MapboxMaps

struct MapViewWrapper : UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {

    }
}

class ViewController: UIViewController {

    internal var mapView: MapView!
    private let klcc = CLLocationCoordinate2D(
        latitude: 3.1575732144536355,
        longitude: 101.71174101512028
    )

    override public func viewDidLoad() {
        super.viewDidLoad()

        let option = MapInitOptions(
            // Can we use the last known location?
            cameraOptions: CameraOptions(center: klcc, zoom: 14.5),
            styleURI: StyleURI.streets
        )
        mapView = MapView(frame: view.bounds, mapInitOptions: option)

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.addSubview(mapView)

        // Hide the scale bar at the top left
        mapView.ornaments.options.scaleBar.visibility = .hidden

        // Add user position icon to the map with location indicator layer
        let configuration = Puck2DConfiguration.makeDefault(showBearing: true)

        mapView.location.options.puckType = .puck2D(configuration)

        mapView.mapboxMap.onNext(event: .mapLoaded) { [self]_ in
            // Ensure it will set the camera to the current location
            self.locationUpdate(newLocation: mapView.location.latestLocation!)
        }

        let loc = CLLocationCoordinate2D(latitude: 3.1575732144536355, longitude: 101.71174101512028)
        var pointAnnotation = PointAnnotation(coordinate: loc)
        pointAnnotation.image = .init(image: UIImage(named: "red_marker")!, name: "red_marker")

        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()

        pointAnnotationManager.annotations = [pointAnnotation]
    }
}

extension ViewController: LocationPermissionsDelegate, LocationConsumer {
    func locationUpdate(newLocation: Location) {
        mapView.camera.fly(to: CameraOptions(center: newLocation.coordinate, zoom: 14.0), duration: 5.0)
    }
}
