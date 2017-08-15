//
//  Utility.swift
//  Native Weather
//
//  Created by IMTIAZ on 8/14/17.
//  Copyright © 2017 IMTIAZ. All rights reserved.
//

import Foundation


class Utility {
    
    static func formateDate(timeStamp: Int, formate: String) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp))
        
        let dayTimePeriodFormatter = DateFormatter()
        //        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.dateFormat = formate
        
        return dayTimePeriodFormatter.string(from: date as Date)
    }
    
    static func updateWeatherIcon(condition: Int) -> Skycons {
        
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
