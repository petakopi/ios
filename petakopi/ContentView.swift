//
//  ContentView.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
  @State private var viewModel = ContentViewModel()

  var body: some View {
    Map(
      coordinateRegion: $viewModel.region,
      showsUserLocation: true
    )
    .ignoresSafeArea()
    .accentColor(Color(.systemPink))
    .onAppear {
      viewModel.checkIfLocationServiceIsEnabled()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
