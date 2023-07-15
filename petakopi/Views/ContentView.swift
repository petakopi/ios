//
//  ContentView.swift
//  petakopi
//
//  Created by Amree Zaid on 08/07/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var checkpoints: [Checkpoint] = []
    @State var showingBottomSheet = false
    @State private var coffeeShops: [CoffeeShop] = []
    @State private var selectedAnnotation: MKAnnotation?
    @State private var selectedCoffeeShop: CoffeeShop?
    @StateObject var viewModel = MapViewModel()

    var body: some View {
        ZStack {
            MapView(checkpoints: $checkpoints, viewModel: viewModel) { annotation in
                if let checkpoint = annotation as? Checkpoint {
                    Task.init {
                        do {
                            selectedAnnotation = checkpoint
                            selectedCoffeeShop = checkpoint.data

                            let slug = selectedCoffeeShop?.slug ?? ""
                            let detailedCoffeeShop = try await CoffeeShopLoader.shared.show(slug: slug)

                            DispatchQueue.main.async {
                                showingBottomSheet.toggle()
                            }
                        } catch {
                            print("Failed to load data")
                        }
                    }
                }
            }
                .ignoresSafeArea()
                .task {
                    do {
                        coffeeShops = try await CoffeeShopLoader.shared.index()
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
            .sheet(isPresented: $showingBottomSheet, onDismiss: {
                if let annotation = selectedAnnotation {
                    viewModel.unselect(annotation: annotation)
                }
            }) {
                if let coffeeShop = selectedCoffeeShop {
                    BottomSheetView(coffeeShop: coffeeShop)
                        .presentationDetents([.fraction(0.25)])
                } else {
                    EmptyView()
                }
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
                ),
                data: coffeeShop
            )
        }
    }

}

struct BottomSheetView: View {
    var coffeeShop: CoffeeShop

    var body: some View {
        VStack {
            Text(coffeeShop.slug)
                .font(.title)
                .padding()
            Image(systemName: "star")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
