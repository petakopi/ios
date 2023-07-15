//
//  ContentView.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import SwiftUI

struct ContentView: View {
    @State var checkpoints: [Checkpoint] = []
    @State var showingBottomSheet = false
    @State private var coffeeShops: [CoffeeShop] = []
    @StateObject var viewModel = MapViewModel()

    var body: some View {
        ZStack {
            MapView(checkpoints: $checkpoints, viewModel: viewModel) { annotation in
                showingBottomSheet.toggle()
            }
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

            VStack {
                Spacer()

                Button(action: {
                     viewModel.centerOnUserPublisher.send()
                }) {
                    Text("My Location")
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .sheet(isPresented: $showingBottomSheet) {
                BottomSheetView()
                    .presentationDetents([.fraction(0.25)])
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
                subtitle: nil,
                coordinate: .init(
                    latitude: lat,
                    longitude: lng
                )
            )
        }
    }
}

struct BottomSheetView: View {
    var body: some View {
        HStack {
            Image(systemName: "star")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
