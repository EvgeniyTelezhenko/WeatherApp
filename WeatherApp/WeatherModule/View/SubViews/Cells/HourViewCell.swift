//
//  HourViewCell.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 23.06.2021.
//

import SDWebImage
import SnapKit

class HourViewCell: UICollectionViewCell {
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setParameters(time: String, iconURLString: String, temperature: String){
        self.timeLabel.text = time
        iconImageView.sd_setImage(with: URL(string: iconURLString), completed: nil)
        
        self.temperatureLabel.text = temperature
    }
}

//MARK:- addViews and Constraints
extension HourViewCell {
    func setViews(){
        contentView.backgroundColor = .clear
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconImageView)
    }
    
    func setConstraints() {
        
        iconImageView.snp.makeConstraints({ make in
            make.centerX.centerY.equalTo(contentView)
            make.height.equalTo(contentView).multipliedBy(0.4)
            make.width.equalTo(contentView.snp.height).multipliedBy(0.4)
        })
        timeLabel.snp.makeConstraints({ make in
            make.top.equalTo(contentView).offset(8)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(iconImageView.snp.top)
        })
        
        temperatureLabel.snp.makeConstraints({ make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
            make.leading.trailing.equalTo(contentView)
        })
    }
}
