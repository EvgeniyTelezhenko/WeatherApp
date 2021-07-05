//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 17.06.2021.
//

import UIKit 

extension String {
    @discardableResult
    func makeAttribute() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [ NSAttributedString.Key.foregroundColor : UIColor.white,
                                                                       NSAttributedString.Key.strokeColor : UIColor.lightGray,
                                                                       NSAttributedString.Key.strokeWidth : -2,])
//
//        return NSAttributedString(string: string, attributes: [
//                                    NSAttributedString.Key.foregroundColor : UIColor.white,
//                                    NSAttributedString.Key.strokeColor : UIColor.lightGray,
//                                    NSAttributedString.Key.strokeWidth : -2,
//                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 36, weight: .light)
//        ])
    }
}
