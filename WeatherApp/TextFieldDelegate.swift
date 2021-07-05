////
////  TextFieldDelegate.swift
////  WeatherApp
////
////  Created by Евгений Тележенко on 15.06.2021.
////
//
//import Foundation
//
//
//extension CityWeatherViewController: UITextFieldDelegate {
//    //Triggers, when user tap return button
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        //Dismiss keyboard
//        searchCityTextField.endEditing(true)
//        print(searchCityTextField.text!)
//        return true
//    }
//    
//    
//    //Don't dismiss keyboard if user didn't tapped anything (used to check something before keyboard disappear)
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            return true
//        } else {
//            textField.placeholder = "type something here"
//            return false
//        }
//    }
//    
//    //Triggered, when user pressed "return" or search button tapped (after user endEditing)
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//        // Imports inputted city name in url in weather manager url function
//        if let city = searchCityTextField.text {
//            
//        }
//        
//        //Use searchfield.text
//        searchCityTextField.text = ""
//    }
//}
