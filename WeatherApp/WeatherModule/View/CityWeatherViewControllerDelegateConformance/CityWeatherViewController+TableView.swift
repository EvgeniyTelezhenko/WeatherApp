//
//  CityWeatherViewController+TableView.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 24.06.2021.
//

import UIKit 

extension CityWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return stackViewWithOval
        }
        if section == 1 {
            guard let weatherModel = viewModel.weatherModel else { return nil}
            let hourView = HourView(frame: tableView.rectForHeader(inSection: 1), delegate: viewModel)
            self.hourView = hourView
            return self.hourView
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            let frame = view.frame.height * 0.15
            return frame
        }
        if section == 1 {
            return view.frame.height * 0.15
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height * 0.1
    }
}

extension CityWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return 0
        case 1:
            return 6
        default:
          return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: WeatherTableViewCell.self))! as! WeatherTableViewCell
            let stringTuple = viewModel.fetchDataWithRaw(indexPath)
            cell.setTextForLabels(componentname: stringTuple.0, weatherComponentDescription: stringTuple.1)
            return  cell
        default:
            return UITableViewCell()
        }
       
    }
}
