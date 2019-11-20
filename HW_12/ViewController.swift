//
//  ViewController.swift
//  HW_12
//
//  Created by Юрий Четырин on 12.11.2019.
//  Copyright © 2019 Юрий Четырин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var weatherTableView: UITableView!
    var forecastWeather: [ForecastWeather] = []
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunrizeLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherLoader().loadCurWheatherAlamofire(city: "Moscow,ru", completion: {weather in
            self.cityLabel.text = weather.city
            self.weatherLabel.text = weather.weatherDescription
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.sunrizeLabel.text = formatter.string(from: weather.sunrise as Date)
            self.sunsetLabel.text = formatter.string(from: weather.sunset as Date)
            
            self.weatherImage.image = UIImage(named: weather.weatherIconID)!
            self.temperatureLabel.text = "\(Int(round(weather.temp)))°C"
            self.cloudCoverLabel.text = "\(weather.cloudCover)%"
            self.windLabel.text = "\(weather.windSpeed) м/с"
            self.pressureLabel.text = "\(weather.pressure) мм рт.ст."
            /*if let rain = weather.rainfallInLast3Hours {
              self.rainLabel.text = "\(rain) мм"
            }
            else {
              self.rainLabel.text = " - "
            }*/
            
            self.humidityLabel.text = "\(weather.humidity)%"
        })
        
        WeatherLoader().loadForecastWeatherAlamofire(city: "Moscow,ru", completion: {forecastWeather in
            self.forecastWeather = forecastWeather
            self.weatherTableView.reloadData()
        })
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
        let model = forecastWeather[indexPath.row]
        cell.dateTimeLabel.text = model.dt_txt
        cell.temperatureLabel.text = "\(Int(round(model.temp)))°C"
        cell.iconWeatherImage.image = UIImage(named: model.weatherIconID)!
        cell.cloudyLabel.text = "\(model.cloudCover) %"
        cell.pressureLabel.text = "\(model.pressure)"
        cell.humidityLabel.text = "\(model.humidity) %"
        return cell
    }
}

