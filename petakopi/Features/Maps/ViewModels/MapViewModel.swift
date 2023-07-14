//
//  MapViewModel.swift
//  petakopi
//
//  Created by Amree Zaid on 15/07/2023.
//

import Combine

class MapViewModel: ObservableObject {
    let centerOnUserPublisher = PassthroughSubject<Void, Never>()
}
