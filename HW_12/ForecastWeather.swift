//
//  ForecastWeather.swift
//  HW_12
//
//  Created by Юрий Четырин on 16.11.2019.
//  Copyright © 2019 Юрий Четырин. All rights reserved.
//

import Foundation

struct ForecastWeather{
    let dateAndTime: NSDate
    
    let dt_txt: String
    
    let weatherID: Int
    let mainWeather: String
    let weatherDescription: String
    let weatherIconID: String
    
    let temp: Double
    let humidity: Int
    let pressure: Double
    let cloudCover: Int
    let windSpeed: Double
    
    // опшионалы, т.к. в запрсе от OpenWeatherMap может не быть значений:
    // - направления ветра, если ветра нет
    let windDirection: Double?
    
    init?(weatherData: [String: AnyObject]) {
        dateAndTime = NSDate(timeIntervalSince1970: weatherData["dt"] as! TimeInterval)
        
        dt_txt = weatherData["dt_txt"] as! String
        
        let mainDict = weatherData["main"] as! [String: AnyObject]
        temp = mainDict["temp"] as! Double
        humidity = mainDict["humidity"] as! Int
        pressure = Double(round(100 * (mainDict["pressure"] as! Double * 0.750062))/100)
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        weatherID = weatherDict["id"] as! Int
        mainWeather = weatherDict["main"] as! String
        weatherDescription = weatherDict["description"] as! String
        weatherIconID = weatherDict["icon"] as! String
        
        cloudCover = weatherData["clouds"]!["all"] as! Int
        
        let windDict = weatherData["wind"] as! [String: AnyObject]
        windSpeed = windDict["speed"] as! Double
        windDirection = windDict["deg"] as? Double
    }
}
