//
//  ContentView.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var checkpoints: [Checkpoint] = [
        Checkpoint(
            title: "Kopi Che Aminah",
            coordinate: .init(
                latitude: 3.032240368437851,
                longitude: 101.46523714719324
            )
        )
    ]

    var body: some View {
        MapView(checkpoints: $checkpoints)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
