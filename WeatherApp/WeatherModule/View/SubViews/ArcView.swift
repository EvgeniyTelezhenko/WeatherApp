//
//  PathView.swift
//  WeatherApp
//
//  Created by Евгений Тележенко on 09.06.2021.
//

import UIKit
import SDWebImage
import Darwin

let exp = Darwin.M_E

class ArcView: UIView {

    private let lineWidth: CGFloat
    private var path: UIBezierPath?
    private var sunrise: Float
    var current: Float
    var dayPercentInOval: Float
    private var sunset: Float
    private var firstLayer: CAGradientLayer? {
        didSet {
            if firstLayer != nil {
                layer.addSublayer(firstLayer!)
            }
        }
    }
    private var secondLayer: CAGradientLayer? {
        didSet {
            if secondLayer != nil {
                layer.addSublayer(secondLayer!)
            }
        }
    }
    
    private var iconImageView: UIImageView?
    
    init(frame: CGRect, lineWidth: CGFloat,  currentPercent: Float, sunrisePercent: Float, sunsetPercent: Float) {
        self.lineWidth = lineWidth
        self.sunrise = sunrisePercent
        self.current = currentPercent
        self.sunset = sunsetPercent
        self.dayPercentInOval = current
        super.init(frame: frame)
        print(frame)
        self.backgroundColor = .clear
        clipsToBounds = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc func animate(percentOfDay: CGFloat) {
        let imageCoordinates = calculateByPercent(percent: percentOfDay)
        print(iconImageView?.frame)
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")

        strokeEndAnimation.toValue = percentOfDay - 0.023
        strokeEndAnimation.duration = 0.3
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.fillMode = .forwards
        firstLayer?.mask!.add(strokeEndAnimation, forKey: "strokeEnd")
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.toValue = percentOfDay + 0.023
        strokeStartAnimation.duration = 0.3
        strokeStartAnimation.isRemovedOnCompletion = false
        strokeStartAnimation.fillMode = .forwards
        
        secondLayer?.mask!.add(strokeStartAnimation, forKey: "strokeStart")
        CATransaction.begin()
       
        let picChangeXPositionAnimation = CABasicAnimation(keyPath: "position.x")
        picChangeXPositionAnimation.toValue = imageCoordinates.0
        picChangeXPositionAnimation.duration = 1
        picChangeXPositionAnimation.isRemovedOnCompletion = false
        picChangeXPositionAnimation.fillMode = .forwards
        
        let picChangeYPositionAnimation = CABasicAnimation(keyPath: "position.y")
        picChangeYPositionAnimation.toValue = imageCoordinates.1
        picChangeYPositionAnimation.duration = 1
        picChangeYPositionAnimation.isRemovedOnCompletion = false
        picChangeYPositionAnimation.fillMode = .forwards
        
        iconImageView?.layer.add(picChangeXPositionAnimation, forKey: "position.x")
        iconImageView?.layer.add(picChangeYPositionAnimation, forKey: "position.y")
        print(iconImageView?.frame)
        CATransaction.setCompletionBlock({
            self.iconImageView?.frame.centerX = imageCoordinates.0
            self.iconImageView?.frame.centerY = imageCoordinates.1
            print("FINISHED")
        })
        
        CATransaction.commit()
        
    }
    
    func addDayPath() {
        let bezierPath = BezierPath(ovalIn: bounds.insetBy(dx: lineWidth, dy: lineWidth))
        addShape(atPath: bezierPath, withStart: 0, withEnd: dayPercentInOval - 0.023, sunrisePercent: sunrise, currentPercent: current, sunsetPercent: sunset)
        addShape(atPath: bezierPath, withStart: dayPercentInOval + 0.023, withEnd: 1, sunrisePercent: sunrise, currentPercent: current, sunsetPercent: sunset)
    }
    
    func addShape(atPath path: BezierPath, withStart strokeStart: Float, withEnd strokeEnd: Float, sunrisePercent: Float, currentPercent: Float, sunsetPercent: Float){
        let gradient = CAGradientLayer()
        
        gradient.type = .conic
        let interval: Float = 0.05
        let arrayOfPercents = [sunrisePercent - interval,sunrisePercent, sunrisePercent + interval, sunsetPercent - interval,sunsetPercent, sunsetPercent + interval]
        gradient.locations = arrayOfPercents.map{NSNumber(value: $0)}
        
        gradient.startPoint = CGPoint(x: CGFloat(0.5), y:  CGFloat(0.5))
        gradient.endPoint = CGPoint(x: CGFloat(0.5), y:  CGFloat(1.0))
        
        gradient.colors = [
            UIColor(named: "nightColor")?.cgColor,
            UIColor(named: "sunriseColor")?.cgColor,
            UIColor.white.cgColor.copy(alpha: 0.6)!,
            UIColor.white.cgColor.copy(alpha: 0.6)!,
            UIColor(named: "sunsetColor")?.cgColor,
            UIColor(named: "nightColor")?.cgColor
        ]
        gradient.frame = bounds
        
        let shape  = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeStart = CGFloat(strokeStart)
        shape.strokeEnd = CGFloat(strokeEnd)
        
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        shape.lineWidth = lineWidth
        gradient.mask = shape
        
        if firstLayer == nil {
            firstLayer = gradient
        } else if secondLayer == nil  {
            secondLayer = gradient
        }
    }
    
    func createImage(weatherStatusIconURL: String){
        let imageCenterCoordinates = calculateByPercent(percent: CGFloat(current))
        
        let imageView: UIImageView = {
            let iv = UIImageView(frame: CGRect(center: CGPoint(x: imageCenterCoordinates.0 , y: imageCenterCoordinates.1 ), size: CGSize(width: frame.width / 6, height: frame.width / 6) ))
            iv.tintColor = .white
            iv.backgroundColor = .clear
            iv.clipsToBounds = false
            self.iconImageView = iv
            return iv
        }()
        
     setIconImage(weatherStatusIconURL: weatherStatusIconURL)
        
        self.addSubview(imageView)
    }
    
    func setIconImage(weatherStatusIconURL: String) {
        iconImageView?.sd_setImage(with: URL(string: weatherStatusIconURL), completed: nil)
    }
    
    private func calculateByPercent(percent current: CGFloat) -> (CGFloat,CGFloat) {
        
        var resultXPointer: CGFloat = 0
        var resultYPointer: CGFloat = 0
        
        let width = Float(frame.width / 2)
        let height = Float(frame.height / 2)
        
        func calculateY(xCoordinate: Float, isFirst: Bool ) -> Float{
            
            var firstUnderRoot = 1.0 - ((xCoordinate - width) * (xCoordinate - width) / (width * width))
            if firstUnderRoot < 0 {
                firstUnderRoot = 0
            }
            
            let y1 = height * ( 1.0 + (firstUnderRoot).squareRoot())
            print(y1)
            
            var secondUnderRoot = (1 - (pow(xCoordinate - width, 2) / pow(width, 2)))
            if secondUnderRoot < 0 {
                secondUnderRoot = 0
            }
            
            let y2 = height * ( 1 - sqrt(secondUnderRoot))
            print(y2)
            if isFirst {
                return y1
            }
            return y2
        }
        switch current {
        
        case 0..<0.25:
            let xNum = CGFloat(dayPercentInOval)
            resultXPointer = (2562.7272 * xNum * xNum * xNum - 2951.9133 * xNum * xNum - 61.8145 * xNum + 320.0599) * frame.width / 320
            resultYPointer = CGFloat(calculateY(xCoordinate: Float(resultXPointer), isFirst: true))
            
        case 0.25..<0.5:
            let xNum = Double(dayPercentInOval)
            resultXPointer =  (CGFloat(2495.0 * xNum * xNum * xNum - 832.1324 * xNum * xNum - 1108.9042 * xNum + 450.5304)) * frame.width / 320
            resultYPointer = CGFloat(calculateY(xCoordinate: Float(resultXPointer), isFirst: true))
            
        case 0.5..<0.75:
            let xNum = Double(1 - dayPercentInOval)
            resultXPointer = ( CGFloat(2495.0 * xNum * xNum * xNum - 832.1324 * xNum * xNum - 1108.9042 * xNum + 450.5304))  * frame.width / 320
            resultYPointer = CGFloat(calculateY(xCoordinate: Float(resultXPointer), isFirst: false))
            
        case 0.75...1:
            let xNum = CGFloat(1 - dayPercentInOval)
            resultXPointer = (2562.7272 * xNum * xNum * xNum - 2951.9133 * xNum * xNum - 61.8145 * xNum + 320.0599) * frame.width / 320
            resultYPointer = CGFloat(calculateY(xCoordinate: Float(resultXPointer), isFirst: false))
        default:
            break
        }
        return (resultXPointer, resultYPointer)
    }
}

