//
//  ViewController.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 08.06.2021.
//

import UIKit
import SnapKit
import CoreLocation
import SDWebImage


class CityWeatherViewController: UIViewController {
    
    internal var viewModel: CityWeatherViewModelProtocol
    
    private let backgroundImageView: SDAnimatedImageView = {
        let imageView = SDAnimatedImageView()
        return imageView
    }()
    
    private var currentHourSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["current", "per hour"])
        sc.selectedSegmentTintColor = .lightGray
        sc.selectedSegmentIndex = 0
        sc.isEnabled = false
        sc.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return sc
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 72, weight: .regular)
        return label
    }()
    
    private let weatherStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .thin)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    internal var oval: ArcView? {
        didSet{
            makeStackView()
            oval?.addDayPath()
            if let weatherModel = viewModel.weatherModel {
                oval?.createImage(weatherStatusIconURL: weatherModel.signImage)
            }
        }
    }

    var hourView: HourView?
    
     var stackViewWithOval: UIStackView?
    
    private var weatherTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.clipsToBounds = true
        tv.backgroundColor = .clear
        tv.register(WeatherTableViewCell.self, forCellReuseIdentifier: String.init(describing: WeatherTableViewCell.self))
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.event = .initial
    }
    
    init(viewModel: CityWeatherViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewModel(){
        viewModel.onSetupInitialState = {
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.isTranslucent = true
            
            self.view.backgroundColor = .clear
            self.view.addSubview(self.backgroundImageView)
            self.view.addSubview(self.cityLabel)
            self.view.addSubview(self.temperatureLabel)
            self.view.addSubview(self.weatherStateLabel)
            self.view.addSubview(self.weatherTableView)
            self.view.addSubview(self.currentHourSegment)
            self.viewModel.onCheckHourSegment?()
            
            self.weatherTableView.delegate = self
            self.weatherTableView.dataSource = self
            
            self.setViews()
        }
        
        viewModel.onChangeSegmentValue = {
            self.currentHourSegment.selectedSegmentIndex = 1
        }
        
        viewModel.onSetCurrentWeatherModel = {
            self.viewModel.weatherModel = self.viewModel.currentWeatherModel
            self.currentHourSegment.selectedSegmentIndex = 0
        }
        
        viewModel.onCheckHourSegment = {
            DispatchQueue.main.async {
                if self.currentHourSegment.selectedSegmentIndex == 0 && self.viewModel.currentWeatherModel?.time != self.viewModel.weatherModel?.time{
                    self.viewModel.onSetCurrentWeatherModel?()
                    self.currentHourSegment.isEnabled = false
               } else if self.currentHourSegment.selectedSegmentIndex == 1  {
                self.currentHourSegment.isEnabled = true
               }
            }
        }
        
        viewModel.onSetupCityView = { cityName in
            if let cityName = cityName {
                self.cityLabel.attributedText = cityName.makeAttribute()
            }
            
            DispatchQueue.main.async {
                self.weatherStateLabel.text = self.viewModel.weatherModel?.description
                for row in 0...5 {
                    self.weatherTableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
                }
                self.temperatureLabel.text = self.viewModel.weatherModel?.temperature
            }
        }
        
        viewModel.onSetImages = { [weak self] in
            guard let self = self else { return }
            guard let weatherModel = self.viewModel.weatherModel else { return }
            
            let imageStringURL = self.viewModel.fetchGIFURL(weatherModel: weatherModel)
            if let url = URL(string: imageStringURL) {
                self.backgroundImageView.sd_setImage(with: url, completed: nil)
            }
        }
        
        viewModel.onSetupArcView = { [weak self] in
            guard let self = self else {return}
            
            let dates = self.viewModel.convertDateToDayPercent()
            
            DispatchQueue.main.async {
                if dates.current >= 0.75 {
                    self.oval = ArcView(frame: CGRect(origin: CGPoint(x: 16, y: 0), size: CGSize(width: self.view.bounds.width - 32, height: self.view.frame.height * 0.15)), lineWidth: 4, currentPercent: Float(dates.current) - 0.75, sunrisePercent: dates.sunrise, sunsetPercent: dates.sunset)
                } else {
                    self.oval = ArcView(frame: CGRect(origin: CGPoint(x: 16, y: 0), size: CGSize(width: self.view.bounds.width - 32, height: self.view.frame.height * 0.15)), lineWidth: 4, currentPercent:  Float(dates.current) + 0.25, sunrisePercent: dates.sunrise, sunsetPercent: dates.sunset)
                }
            }
        }
        viewModel.onAnimateArcView = { [weak self ] in
            
            guard let self = self else {return}
            guard let oval = self.oval else {return}
            oval.setIconImage(weatherStatusIconURL: self.viewModel.weatherModel!.signImage)
            
            let dates = self.viewModel.convertDateToDayPercent()
            if dates.current >= 0.75 {
                oval.current = Float(dates.current) - 0.75
                oval.dayPercentInOval = oval.current
            } else {
                oval.current =  Float(dates.current) + 0.25
                oval.dayPercentInOval = oval.current
            }
            oval.animate(percentOfDay: CGFloat(oval.dayPercentInOval))

        }
    }
    
    private func setViews() {
        backgroundImageView.snp.makeConstraints({ make in
            make.leading.trailing.bottom.top.equalToSuperview()
        })
        
        currentHourSegment.snp.makeConstraints({ make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.width.equalTo(120)
        })
        
        cityLabel.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalToSuperview().multipliedBy(0.05)
        })
        
        temperatureLabel.snp.makeConstraints({ make in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(cityLabel)
            make.height.equalTo(cityLabel).multipliedBy(2)
        })
        
        weatherStateLabel.snp.makeConstraints( { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(cityLabel)
            make.height.equalTo(cityLabel).multipliedBy(0.6)
        })
        
        weatherTableView.snp.makeConstraints({ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(weatherStateLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        })
    }
    
    func makeStackView() {
        let rect = weatherTableView.rectForHeader(inSection: 0)
        let sv = UIStackView(frame: .zero)
        let firstSpacingView = UIView()
        firstSpacingView.backgroundColor = .clear
        let secondSpacingView = UIView()
        secondSpacingView.backgroundColor = .clear
        
        sv.addArrangedSubview(firstSpacingView)
        sv.addArrangedSubview(oval!)
        sv.addArrangedSubview(secondSpacingView)
        sv.spacing = 16
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        oval?.clipsToBounds = false
        sv.clipsToBounds = false
        
        sv.distribution = .fill
        sv.axis = .vertical
        self.stackViewWithOval = sv
        
        weatherTableView.reloadSections([0], with: .fade)
    }
    
    @objc func segmentChanged() {
        switch currentHourSegment.selectedSegmentIndex {
        case 0:
            viewModel.event = .segmentDidChangedValue
        case 1:
            print("First")
        default:
            print("default")
        }
    }
}

