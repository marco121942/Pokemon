//
//  PokePin.swift
//  PokemonGo
//
//  Created by Marco Antonio Sotomayor Lopez on 17/05/19.
//  Copyright © 2019 Tecsup. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class PokePin : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    init(coord: CLLocationCoordinate2D, pokemon : Pokemon ) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}

