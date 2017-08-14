//
//  ViewController.swift
//  Native Weather
//
//  Created by IMTIAZ on 8/13/17.
//  Copyright © 2017 IMTIAZ. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = DataModel()
    
    @IBOutlet weak var viewIcon: UIView!
    @IBOutlet weak var textDate: UILabel!
    @IBOutlet weak var textStatus: UILabel!
    @IBOutlet weak var textCity: UILabel!
    @IBOutlet weak var textTemperature: UILabel!
    @IBOutlet weak var textTempMinMax: UILabel!
    @IBOutlet weak var textWind: UILabel!
    @IBOutlet weak var textPressure: UILabel!
    @IBOutlet weak var textVisibility: UILabel!
    @IBOutlet weak var textSunset: UILabel!
    @IBOutlet weak var textSunrise: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
//            locationManager.delegate = nil
            
            let param : [String : String] = ["lat": String(location.coordinate.latitude),
                                             "lon": String(location.coordinate.longitude),
                                             "appid": APP_ID]
            
            self.getWeatherData(url: WEATHER_URL, params: param)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeatherData(url: String, params: [String:String]) {
        Alamofire.request(url, method: .get, parameters: params).responseJSON{
            response in
            if response.result.isSuccess{
                let weatherJson = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJson)
            }else{
                print("Error \(String(describing: response.result.error))")
                self.textCity.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.today = formateDate(timeStamp: json["dt"].intValue, formate: "EEEE, MMM d")
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.pressure = "\(json["main"]["pressure"].intValue) MB"
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            weatherDataModel.visibility = "\(json["visibility"].intValue / 1000) KM"
            weatherDataModel.temp_min = Int(json["main"]["temp_min"].double! - 273.15)
            weatherDataModel.temp_max = Int(json["main"]["temp_max"].double! - 273.15)
            weatherDataModel.windSpeed = json["wind"]["speed"].doubleValue
            weatherDataModel.sunrise = formateDate(timeStamp: json["sys"]["sunrise"].intValue, formate: "hh:mm a")
            weatherDataModel.sunset = formateDate(timeStamp: json["sys"]["sunset"].intValue, formate: "hh:mm a")
            weatherDataModel.city = "\(json["name"].stringValue), \(json["sys"]["country"].stringValue)"
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.status = json["weather"][0]["description"].stringValue.capitalized
            
            updateUIWithWeatherData()
        }else{
            textCity.text = "Weather Unavailable"
        }
    }
    
    func formateDate(timeStamp: Int, formate: String) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp))
        
        let dayTimePeriodFormatter = DateFormatter()
//        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.dateFormat = formate
        
        return dayTimePeriodFormatter.string(from: date as Date)
    }

    func updateUIWithWeatherData() {
        textTemperature.text = "\(weatherDataModel.temperature)°"
        textCity.text = "\(weatherDataModel.city)"
        textDate.text = "\(weatherDataModel.today)"
        textStatus.text = weatherDataModel.status
        textTempMinMax.text = "\(weatherDataModel.temp_min)° / \(weatherDataModel.temp_max)°"
        
        textWind.text = "\(weatherDataModel.windSpeed) mps"
        textVisibility.text = weatherDataModel.visibility
        textPressure.text = weatherDataModel.pressure
        textSunrise.text = weatherDataModel.sunrise
        textSunset.text = weatherDataModel.sunset
        
        let size = Int((self.viewIcon.frame.height) * (4/5))
        let iconView = SKYIconView(frame: CGRect(x: 15, y: 15, width: size, height: size))
        iconView.setType = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        iconView.setColor = UIColor.white
        iconView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        self.viewIcon.addSubview(iconView)

    }
}

