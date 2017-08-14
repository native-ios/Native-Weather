//
//  DataModel.swift
//  Native Weather
//
//  Created by IMTIAZ on 8/14/17.
//  Copyright © 2017 IMTIAZ. All rights reserved.
//

import Foundation

class DataModel {
    //Declare your model variables here
    var today : String = ""
    var temperature: Int = 0
    var pressure : String = ""
    var humidity : Int = 0
    var temp_min : Int = 0
    var temp_max : Int = 0
    var visibility : String = ""
    var windSpeed : Double = 0
    var sunrise : String = ""
    var sunset : String = ""
    var clouds : Int = 0
    var city: String = ""
    var condition: Int = 0
    var status : String = ""
    var weatherIconName: String = ""
    
    //This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(condition: Int) -> Skycons {
        
        switch (condition) {
            
        case 0...299 :
            return .rain
            
        case 300...399 :
            return .rain
            
        case 400...510 :
            return .sleet
            
        case 511...599,  600...700 :
            return .snow
            
        case 701...771, 772...799 :
            return .fog
            
        case 800 :
            return .clearNight
            
        case 801...804 :
            return .cloudy
            
        case 900 :
            return .wind
            
        case 901 :
            return .wind
            
        case 902 :
            return .wind
            
        case 903 :
            return .fog
            
        case 904 :
            return .clearDay
            
        case 905 :
            return .wind
        
        case 906 :
            return .sleet
            
        case 951...956:
            return .partlyCloudyDay
            
        case 957...962:
            return .wind
            
        default :
            return .partlyCloudyDay
        }
        
    }
}
