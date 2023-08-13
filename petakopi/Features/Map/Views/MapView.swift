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
    private let tokyoStation = CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671)

    private var cameraLocationConsumer: CameraLocationConsumer!

    override public func viewDidLoad() {
        super.viewDidLoad()

        let option = MapInitOptions(
            cameraOptions: CameraOptions(center: tokyoStation, zoom: 14.5),
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

        cameraLocationConsumer = CameraLocationConsumer(mapView: mapView)

        // Allows the delegate to receive information about map events.
        mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            // Register the location consumer with the map
            // Note that the location manager holds weak references to consumers, which should be retained
            self.mapView.location.addLocationConsumer(newConsumer: self.cameraLocationConsumer)

        }
    }
}

// Create class which conforms to LocationConsumer, update the camera's centerCoordinate when a locationUpdate is received
public class CameraLocationConsumer: LocationConsumer {
    weak var mapView: MapView?

    init(mapView: MapView) {
        self.mapView = mapView
    }

    public func locationUpdate(newLocation: Location) {
        mapView?.camera.ease(
            to: CameraOptions(center: newLocation.coordinate, zoom: 15),
            duration: 1.3)
    }
}
