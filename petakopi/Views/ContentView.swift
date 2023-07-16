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
    @State private var coffeeShop: CoffeeShop?
    @State private var selectedAnnotation: MKAnnotation?

    @StateObject var viewModel = MapViewModel()

    var body: some View {
        ZStack {
            MapView(checkpoints: $checkpoints, viewModel: viewModel) { annotation in
                selectedAnnotation = annotation

                if let checkpoint = annotation as? Checkpoint {
                    let selectedCoffeeShopSlug = checkpoint.data.id

                    Task.init {
                        do {
                            coffeeShop = try await CoffeeShopLoader.shared.show(slug: selectedCoffeeShopSlug )
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
            .sheet(item: $coffeeShop, onDismiss: {
                if let annotation = selectedAnnotation {
                    viewModel.unselect(annotation: annotation)
                }

                coffeeShop = nil
            }) { coffeeShop in
                BottomSheetView(coffeeShop: coffeeShop)
                    .presentationDetents([.fraction(0.5), .large])
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
    let imageSize: CGFloat = 60

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                if let logoUrl = coffeeShop.logoUrl,
                   let url = URL(string: logoUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: imageSize, height: imageSize)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: imageSize, height: imageSize)
                }

                VStack(alignment: .leading) {
                    Text(coffeeShop.name)
                        .font(.headline)
                    Text(coffeeShop.tags?.joined(separator: ", ") ?? "")
                        .font(.caption2)
                        .padding(.top, 2)
                }
                .padding(.leading)

                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)

            VStack(alignment: .leading) {
                List {
                    Section(header: Text("Links")) {
                        ForEach(coffeeShop.links ?? [], id: \.url) { item in
                            if let url = URL(string: item.url) {
                                Link(destination: url) {
                                    HStack {
                                        Text(item.name)
                                        Spacer()
                                        Image(systemName: "arrow.up.right.square")
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .padding(.top, 10)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
