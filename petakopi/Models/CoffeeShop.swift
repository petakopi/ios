//
//  CoffeeShop.swift
//  petakopi
//
//  Created by Amree Zaid on 09/07/2023.
//

import Foundation

struct CoffeeShop: Identifiable, Codable {
    let id: String
    let name: String
    let logoUrl: String?
    let url: String
    let links: [LinkItem]?
    let tags: [String]?

    private let latString: String
    private let lngString: String

    var lat: Double? {
        return Double(latString)
    }

    var lng: Double? {
        return Double(lngString)
    }

    enum CodingKeys: String, CodingKey {
        case id = "slug"
        case name
        case logoUrl = "logo_url"
        case url
        case links
        case tags
        case latString = "lat"
        case lngString = "lng"
    }
}

struct LinkItem: Codable {
    let name: String
    let url: String
}
