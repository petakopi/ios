//
//  CoffeeShop.swift
//  petakopi
//
//  Created by Amree Zaid on 09/07/2023.
//

import Foundation

struct CoffeeShop: Codable {
    let id: Int
    let name: String
    let url: String

    private let latString: String
    private let lngString: String

    var lat: Double? {
        return Double(latString)
    }

    var lng: Double? {
        return Double(lngString)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case latString = "lat"
        case lngString = "lng"
    }
}
