//
//  WindDirection.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 16.06.2021.
//

import Foundation

enum WindDirection: String, Equatable {
    case north = "СЕВЕРНЫЙ"
    case south = "ЮЖНЫЙ"
    case west = "ЗАПАДНЫЙ"
    case east = "ВОСТОЧНЫЙ"
    case northWest = "СЕВЕРО-ЗАПАДНЫЙ"
    case southWest = "ЮГО-ЗАПАДНЫЙ"
    case northEast = "СЕВЕРО-ВОСТОЧНЫЙ"
    case southEast = "ЮГО-ВОСТОЧНЫЙ"
   
}

extension WindDirection {
    init?(degrees: Int) {
        switch degrees {
        case 0...22, 338...360:
            self = .north
        case 23...67:
            self = .northEast
        case 68...112:
            self = .east
        case 113...157:
            self = .southEast
        case 158...202:
            self = .south
        case 203...247:
            self = .southWest
        case 248...292:
            self = .west
        case 292...337:
            self = .northWest
        default:
            return nil
        }
    }
}
