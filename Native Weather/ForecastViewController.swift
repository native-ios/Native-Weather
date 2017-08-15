//
//  ForecastViewController.swift
//  Native Weather
//
//  Created by IMTIAZ on 8/14/17.
//  Copyright © 2017 IMTIAZ. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import GooglePlaces


class ForecastViewController : UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var TempMorn: UILabel!
    @IBOutlet weak var TempDay: UILabel!
    @IBOutlet weak var TempEve: UILabel!
    @IBOutlet weak var TempNight: UILabel!
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var LabelHumidity: UILabel!
    @IBOutlet weak var foreCastTableView: UITableView!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast/daily"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let locationManager = CLLocationManager()
    let forecastModel = ForeCastModel()
    
    var forcastArray = [ForeCastModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        foreCastTableView.delegate = self
        foreCastTableView.dataSource = self
        foreCastTableView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: "forecastCell")
        foreCastTableView.separatorStyle = .none
        configureTableView()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let param : [String : String] = ["lat": String(location.coordinate.latitude),
                                             "lon": String(location.coordinate.longitude),
                                             "appid": APP_ID]
            
            self.getWeatherData(url: WEATHER_URL, params: param)
        }
    }
    
    func getWeatherData(url: String, params: [String:String]) {
        Alamofire.request(url, method: .get, parameters: params).responseJSON{
            response in
            if response.result.isSuccess{
                let weatherJson = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJson)
            }else{
                print("Error \(String(describing: response.result.error))")
//                self.textCity.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        if let list = json["list"].array {
            TempMorn.text = "\(list[0]["temp"]["morn"].floatValue - 273.15)°"
            TempDay.text = "\(list[0]["temp"]["day"].floatValue - 273.15)°"
            TempEve.text = "\(list[0]["temp"]["eve"].floatValue - 273.15)°"
            TempNight.text = "\(list[0]["temp"]["night"].floatValue - 273.15)°"
            LabelDate.text = Utility.formateDate(timeStamp: list[0]["dt"].intValue, formate: "EEE, MMM d")
            LabelHumidity.text = "Humidity \(list[0]["humidity"]) %"
            for temp in list {
                
                let forecastModel = ForeCastModel()
                forecastModel.date =  Utility.formateDate(timeStamp: temp["dt"].intValue, formate: "EEE, MMM d")
                forecastModel.condition = temp["weather"]["id"].intValue
                forecastModel.tempDiff = "↑\(temp["temp"]["max"].floatValue - 273.15)° ↓\(temp["temp"]["min"].floatValue - 273.15)°"
                forecastModel.humidity = "\(temp["humidity"].intValue) %"
                forecastModel.pressure = "\(temp["pressure"].intValue) hPa"
                forecastModel.description = temp["weather"][0]["description"].stringValue
                
                forcastArray.append(forecastModel)
            }
            
            self.configureTableView()
            self.foreCastTableView.reloadData()
        }else{
            print("Weather Unavailable")
//            textCity.text = "Weather Unavailable"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastCell
        
        cell.weatherDate.text = forcastArray[indexPath.row].date
        
        let size = Int((cell.weatherIcon.frame.height) * (4/5))
        let iconView = SKYIconView(frame: CGRect(x: Int(Float(cell.weatherIcon.frame.width / 2) - Float(size / 2)), y: Int(Float(cell.weatherIcon.frame.height / 2) - Float(size / 2)), width: size, height: size))
        iconView.setType = Utility.updateWeatherIcon(condition: forecastModel.condition)
        iconView.setColor = UIColor.white
        iconView.backgroundColor = UIColor(white: 1, alpha: 0)
        cell.weatherIcon.subviews.forEach{$0.removeFromSuperview()}
        cell.weatherIcon.addSubview(iconView)
        
        cell.weatherTemp.text = forcastArray[indexPath.row].tempDiff
        cell.weatherHumidity.text = forcastArray[indexPath.row].humidity
        cell.weatherPressure.text = forcastArray[indexPath.row].pressure
        cell.weatherDesc.text = forcastArray[indexPath.row].description
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.view.frame.height * (1/12)
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forcastArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(forcastArray[indexPath.row].date)
    }
    
    func configureTableView() {
        foreCastTableView.rowHeight = UITableViewAutomaticDimension
        foreCastTableView.estimatedRowHeight = 120.0
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
