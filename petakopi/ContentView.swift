//
//  ContentView.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import SwiftUI
import MapKit

import Foundation

struct ContentView: View {
    @State var checkpoints: [Checkpoint] = []
    @State private var coffeeShops: [CoffeeShop] = []

    var body: some View {
        MapView(checkpoints: $checkpoints)
            .ignoresSafeArea()
            .task {
                do {
                    coffeeShops = try await CoffeeShopLoader.shared.call()
                    updateCheckpoints()
                } catch {
                    // Handle the error
                    print("Failed to load JSON data: \(error)")
                }
            }
    }

    func updateCheckpoints() {
        checkpoints = coffeeShops.compactMap { coffeeShop in
            guard let lat = coffeeShop.lat, let lng = coffeeShop.lng else {
                return nil
            }
            return Checkpoint(
                title: coffeeShop.name,
                subtitle: coffeeShop.url,
                coordinate: .init(
                    latitude: lat,
                    longitude: lng
                )
            )
        }
    }
}
