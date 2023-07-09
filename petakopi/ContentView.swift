//
//  ContentView.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        MapView()
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
