//
//  ContentView.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var coffeeShops: [CoffeeShop] = []

    var body: some View {
        VStack {
            MapViewWrapper(coffeeShops: coffeeShops)
        }
        .task {
            do {
                coffeeShops = try await CoffeeShopLoader.shared.index()
            } catch {
                // Handle the error
                print("[ERROR] Failed to load JSON data: \(error)")
            }
        }
    }
}
