//
//  ContentView.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
  @State private var region =
    MKCoordinateRegion(
      center:
        CLLocationCoordinate2D(
          latitude: 51.507222,
          longitude: -0.1275
        ),
      span:
        MKCoordinateSpan(
          latitudeDelta: 0.05,
          longitudeDelta: 0.05
        )
    )

  var body: some View {
    Map(
      coordinateRegion: $region,
      showsUserLocation: true
    )
    .ignoresSafeArea()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
