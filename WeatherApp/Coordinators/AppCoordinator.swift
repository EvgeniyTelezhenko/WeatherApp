//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 08.06.2021.
//

import UIKit

class AppCoordinator: Coordinator {
    var subCoordinators: [Coordinator] = []
    
    var controllers: [UIViewController] = []
    
    func createModule() {
        let networkService = CurrentWeatherNetworkService()
        let locationService = LocationService()
        let cityVM = CityWeatherViewModel(networkService: networkService, locationService: locationService)
        locationService.delegate = cityVM
        networkService.delegate = cityVM
        let cityVC = CityWeatherViewController(viewModel: cityVM)
        let mainNavController = UINavigationController(rootViewController: cityVC)
        controllers.append(mainNavController)
    }
}
