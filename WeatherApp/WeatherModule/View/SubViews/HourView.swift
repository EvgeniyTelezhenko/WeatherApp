//
//  HourView.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 23.06.2021.
//

import UIKit
import SnapKit

protocol HourViewDelegate: class   {
    var weatherModel: WeatherModel? {get set}
    func convertDateFromUTF(_ dateInUTF: Int) -> String
    func selectedItemAt(_ indexPath: IndexPath)
}

class HourView: UIView {
    
    private let delegate: HourViewDelegate
    
    private var numberOfItemsInSection: Int = 0
    
    let hourCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.register(HourViewCell.self, forCellWithReuseIdentifier: String(describing: HourViewCell.self))
        cv.backgroundColor = .clear
        return cv
    }()
    
    init(frame: CGRect, delegate: HourViewDelegate) {
        self.delegate = delegate
        if let weatherModel = delegate.weatherModel{
        self.numberOfItemsInSection = weatherModel.hourly.count
        }
        super.init(frame: frame)
        setCollectionView()
        setDataForCollectionlView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionView() {
        addSubview(hourCollectionView)
        hourCollectionView.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
    }
    
    private func setDataForCollectionlView(){
        hourCollectionView.dataSource = self
        hourCollectionView.delegate = self
    }
}


extension HourView: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(hourCollectionView.frame.width)
       return CGSize(width: (hourCollectionView.frame.width / 5 - (3 * Helpers.inset)) , height: hourCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.selectedItemAt(indexPath)
    }
}

extension HourView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HourViewCell.self), for: indexPath) as? HourViewCell {
            guard let weatherModel = delegate.weatherModel else { return UICollectionViewCell() }
            for (index, hour) in weatherModel.hourly.enumerated() {
                if let cell = hourCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? HourViewCell{
                    let time = delegate.convertDateFromUTF(hour.dt)
                    let iconUrlString = "https://openweathermap.org/img/wn/\(hour.weather[0].icon)@2x.png"
                    let temperature = String(hour.feelsLike)
                    cell.setParameters(time: time, iconURLString: iconUrlString, temperature: temperature)
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
