//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 08.06.2021.
//

import UIKit

protocol Coordinator{
    var subCoordinators: [Coordinator] {get set}
    var controllers: [UIViewController] {get set}
    func createModule()
}
