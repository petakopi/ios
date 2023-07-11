//
//  CoffeeShopLoader.swift
//  petakopi
//
//  Created by Amree Zaid on 09/07/2023.
//

import Foundation

class CoffeeShopLoader {
    static let shared = CoffeeShopLoader()

    func call() async throws -> [CoffeeShop] {
        let url = URL(string: "https://petakopi.my/api/v1/coffee_shops.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let coffeeShops = try JSONDecoder().decode([CoffeeShop].self, from: data)
        
        return coffeeShops
    }
}
