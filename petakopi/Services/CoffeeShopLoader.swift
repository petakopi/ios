//
//  CoffeeShopLoader.swift
//  petakopi
//
//  Created by Amree Zaid on 09/07/2023.
//

import Foundation

class CoffeeShopLoader {
    static let shared = CoffeeShopLoader()

    #if DEBUG
    private let baseURL = "http://127.0.0.1:3000/api/v1"
    #else
    private let baseURL = "https://petakopi.my/api/v1"
    #endif

    func index() async throws -> [CoffeeShop] {
        let url = URL(string: "\(baseURL)/coffee_shops.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let coffeeShops = try JSONDecoder().decode([CoffeeShop].self, from: data)
        
        return coffeeShops
    }

    func show(slug: String) async throws -> CoffeeShop {
        let url = URL(string: "\(baseURL)/coffee_shops/\(slug).json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let coffeeShop = try JSONDecoder().decode(CoffeeShop.self, from: data)

        return coffeeShop
    }
}
