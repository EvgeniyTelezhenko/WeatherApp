//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 15.06.2021.
//

import UIKit
import SnapKit

class WeatherTableViewCell: UITableViewCell {
    private let weatherComponentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let weatherComponentDesriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .light)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       configureSelf()
        setViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("From coder")
        configureSelf()
        setViews()
    }
    
    func setViews() {
        contentView.addSubview(weatherComponentLabel)
        contentView.addSubview(weatherComponentDesriptionLabel)
        contentView.backgroundColor = .clear
        
        weatherComponentLabel.snp.makeConstraints({ make in
            make.top.left.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalToSuperview().multipliedBy(0.3)
        })
        weatherComponentDesriptionLabel.snp.makeConstraints({ make in
            make.top.equalTo(weatherComponentLabel.snp.bottom)
            make.leading.trailing.equalTo(weatherComponentLabel)
            make.bottom.equalToSuperview().offset(-8)
        })
    }
    func setTextForLabels(componentname: String, weatherComponentDescription: String) {
        self.weatherComponentLabel.text = componentname + ":"
        self.weatherComponentDesriptionLabel.text = weatherComponentDescription 
    }
    
    func configureSelf(){
        backgroundColor = .clear
        selectionStyle = .none
    }
}
