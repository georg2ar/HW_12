//
//  WeatherLoader.swift
//  HW_12
//
//  Created by Юрий Четырин on 13.11.2019.
//  Copyright © 2019 Юрий Четырин. All rights reserved.
//

import Foundation
import Alamofire

class WeatherLoader{
    private let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let openWeatherForecastURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let openWeatherMapAPIKey = "48b3d7488ed0a0f438f2b9e9f9001d00"
    private let units = "metric"
    private let lang = "ru"
    
    func loadCurWheather(city: String, completion: @escaping (Weather) -> Void){
        let url = URL(string: "\(openWeatherMapBaseURL)?appid=\(openWeatherMapAPIKey)&q=\(city)&units=\(units)&lang=\(lang)")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            let weatherData = try? (JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String: AnyObject])
            let weather = Weather(weatherData: weatherData!)
            DispatchQueue.main.async {
                completion(weather!)
            }
        }
        task.resume()
    }
    
    
    func loadForecastWeather(city: String, completion: @escaping ([ForecastWeather]) -> Void){
        let url = URL(string: "\(openWeatherForecastURL)?appid=\(openWeatherMapAPIKey)&q=\(city)&units=\(units)&lang=\(lang)")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                let jsonDict = json as? NSDictionary{
                let list = jsonDict["list"] as? NSArray
                var forecastWeather: [ForecastWeather] = []
                for item in list! {
                    let obj = item as? NSDictionary
                    if let weather = ForecastWeather(weatherData: obj as! [String : AnyObject]){
                        forecastWeather.append(weather)
                    }
                }
                DispatchQueue.main.async {
                    completion(forecastWeather)
                }
            }
            
        }
        task.resume()
    }
    
    func loadCurWheatherAlamofire(city: String, completion: @escaping (Weather) -> Void){        Alamofire.request("\(openWeatherMapBaseURL)?appid=\(openWeatherMapAPIKey)&q=\(city)&units=\(units)&lang=\(lang)").responseJSON{ response in
            let weather = Weather(weatherData: response.result.value as! [String : AnyObject])
            DispatchQueue.main.async {
                completion(weather!)
            }
            
        }
    }
    
    
    func loadForecastWeatherAlamofire(city: String, completion: @escaping ([ForecastWeather]) -> Void){
        Alamofire.request("\(openWeatherForecastURL)?appid=\(openWeatherMapAPIKey)&q=\(city)&units=\(units)&lang=\(lang)").responseJSON{ response in
            if let object = response.result.value,
                let jsonDict = object as? NSDictionary{
                let list  = jsonDict["list"] as? NSArray
                var forecastWeather: [ForecastWeather] = []
                for item in list! {
                    let obj = item as? NSDictionary
                    if let weather = ForecastWeather(weatherData: obj as! [String : AnyObject]){
                        forecastWeather.append(weather)
                    }
                }
                DispatchQueue.main.async {
                    completion(forecastWeather)
                }
            }
        }
    }
}
