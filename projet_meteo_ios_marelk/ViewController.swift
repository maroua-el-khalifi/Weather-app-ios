//
//  ViewController.swift
//  projet_meteo_ios_marelk
//
//  Created by user on 02/02/2023.
//  Copyright © 2023 user. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController ,  UITextFieldDelegate {
    @IBOutlet weak var conditionImage: UIImageView!
    
    @IBOutlet weak var hour1: UILabel!
    @IBOutlet weak var hour2: UILabel!
    @IBOutlet weak var hour3: UILabel!
    @IBOutlet weak var hour4: UILabel!
    @IBOutlet weak var hour5: UILabel!
    
    @IBOutlet weak var temp5: UILabel!
    @IBOutlet weak var icon5: UIImageView!
    @IBOutlet weak var day5: UILabel!
    @IBOutlet weak var temp4: UILabel!
    @IBOutlet weak var temp3: UILabel!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var day4: UILabel!
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var tem1: UILabel!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var day1: UILabel!
    @IBOutlet weak var sliderHour: UISlider!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    let weatherManager = WeatherManager()
    var city : String?
    var isCitySale = true
    var sameDay : Int?
    var weatherTable : [DailyModel]?
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textView: UITextField) -> Bool {
        if searchTextField.text != ""{
            return true
        }
        else {
            searchTextField.placeholder = "Please type something"
            return false
    }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        if isCitySale || city == ""{
            isCitySale = false
            city = "sale"
            if sliderHour.value != 0 {
                       weatherManager.fetchForecastWeather(cityName: city!, index: Int(sliderHour.value))
                   }
                   else{
                       weatherManager.fetchCurrentWeather(cityName: city!)
                       }
        }
        else {
           
        if sliderHour.value != 0 {
            weatherManager.fetchForecastWeather(cityName: city!, index: Int(sliderHour.value))
             // to change the slider maxValue to how many forcast hour in the same day
                sliderHour.maximumValue = Float(self.sameDay ?? 1 )
            
           
        }
        
        else{
            weatherManager.fetchCurrentWeather(cityName: city!)
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         searchTextField.endEditing(true)
    }
    
    func  textFieldDidEndEditing(_ textView: UITextField) {
       if let city = searchTextField.text {
        self.city = city.replacingOccurrences(of: " ", with: "%20")
        let cityWitoutSpace = city.replacingOccurrences(of: " ", with: "%20")
        for i in 0..<6{
                   self.dailyWeather(city: cityWitoutSpace, i : i)
               }
             if sliderHour.value != 0 {
                       weatherManager.fetchForecastWeather(cityName: cityWitoutSpace, index: Int(sliderHour.value))
                sliderHour.maximumValue = Float(self.sameDay ?? 1 )
                   }
                   
                   else{
                       weatherManager.fetchCurrentWeather(cityName: cityWitoutSpace)
                       }
            
        }
        searchTextField.text=""
         sliderHour.value = 0 // to make the slider in default value
       
    }
    
    func hourSlider(hour : Int) -> String {
        let calendar = Calendar.current
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:00"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        
        let futureDate = calendar.date(byAdding: dateComponents, to: currentTime)
            
        let FutureDateString = dateFormatter.string(from: futureDate!)
        return FutureDateString

    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        self.hour1.text = hourSlider(hour: 3)
        self.hour2.text = hourSlider(hour: 6)
        self.hour3.text = hourSlider(hour: 9)
        self.hour4.text = hourSlider(hour: 12)
        self.hour5.text = hourSlider(hour: 15)
        
        sliderHour.value = 0
        sliderHour.maximumValue = 3
        sliderHour.minimumValue = 0
           weatherManager.delegate = self
           searchTextField.delegate = self
          
        if sliderHour.value != 0 {
            weatherManager.fetchForecastWeather(cityName: "sale", index: Int(round(sliderHour!.value)))}
        else {
             weatherManager.fetchCurrentWeather(cityName: "sale")
        }
        for i in 0..<6{
            self.dailyWeather(city: "sale", i : i)
        }
       }
    
    
    func dailyWeather(city : String, i :Int){
        weatherManager.fetchCurrentWeatherCoord(cityName: city, i: i)
    }
    
   
}

extension ViewController:WeatherManagerDelegate{
    
    func didUpdateCoords (_ weatherdata: WeatherManager, weather: WeathetModel, i: Int){
        
        let lon = weather.lon
        let lat = weather.lat
        weatherManager.fetchDailyWeather(lon: lon, lat: lat, i: i)
    }
    
    func didUpdateWeather3(_ weatherdata: WeatherManager, weather: [DailyModel], i: Int) {
        DispatchQueue.main.async {
            var icon_tab = [String]()
            var day_tab = [String]()
            var temp_tab = [String]()
            for i in 0..<weather.count{
            let icon = weather[i].icon
            let temp = weather[i].temperature
            let day = weather[i].date
                icon_tab.append(icon)
                day_tab.append("\(day.dateFromMilliseconds().dayMonthly())")
                temp_tab.append("\(Int(temp)) °C")
            }
            self.day1.text = "Today"
            self.day2.text = day_tab[1]
            self.day3.text = day_tab[2]
            self.day4.text = day_tab[3]
            self.day5.text = day_tab[4]
            
            let icon1=URL(string: "https://openweathermap.org/img/wn/\(icon_tab[0]).png")!
                          URLSession.shared.dataTask(with: icon1){ (data, response, error) in
                              if let data = data {
                                  DispatchQueue.main.async {
                                      self.icon1.image = UIImage(data : data)
                                  }
                              }
                          }.resume()
            let icon2=URL(string: "https://openweathermap.org/img/wn/\(icon_tab[1]).png")!
            URLSession.shared.dataTask(with: icon2){ (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.icon2.image = UIImage(data : data)
                    }
                }
            }.resume()
            let icon3=URL(string: "https://openweathermap.org/img/wn/\(icon_tab[2]).png")!
            URLSession.shared.dataTask(with: icon3){ (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.icon3.image = UIImage(data : data)
                    }
                }
            }.resume()
            let icon4=URL(string: "https://openweathermap.org/img/wn/\(icon_tab[3]).png")!
            URLSession.shared.dataTask(with: icon4){ (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.icon4.image = UIImage(data : data)
                    }
                }
            }.resume()
            let icon5=URL(string: "https://openweathermap.org/img/wn/\(icon_tab[4]).png")!
            URLSession.shared.dataTask(with: icon5){ (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.icon5.image = UIImage(data : data)
                    }
                }
            }.resume()
            
            self.tem1.text = temp_tab[0]
            self.temp2.text = temp_tab[1]
            self.temp3.text = temp_tab[2]
            self.temp4.text = temp_tab[3]
            self.temp5.text = temp_tab[4]
        }
    }
    
    
    
    func didUpdateWeather2(_ weatherdata: WeatherManager, weather: [WeathetModel],i:Int) {
         DispatchQueue.main.async {
            
               // print(weather.count)
               // print(weather)
            
            let dayWord = weather[i].date.dateFromMilliseconds().dayWord()
           // let day = weather[i].date.dateFromMilliseconds().dayMonthly()
            let date = weather[i].date.dateFromMilliseconds().yearMonthDay()
           // let hour = weather[i].date.dateFromMilliseconds().hourMinute()
            let iconString = weather[i].icon
            let iconURL=URL(string: "https://openweathermap.org/img/wn/\(iconString)@4x.png")!

               URLSession.shared.dataTask(with: iconURL){ (data, response, error) in
                   if let data = data {
                       DispatchQueue.main.async {
                           self.conditionImage.image = UIImage(data : data)
                       }
                   }
               }.resume()
            var weatherCounts: [String: Int] = [:]

            for w in weather {
                weatherCounts[w.date.dateFromMilliseconds().dayWord(), default: 0] += 1
            }

            let duplicateDay = weatherCounts.filter { $0.value > 1 }
            
            self.sameDay = duplicateDay[weather[0].date.dateFromMilliseconds().dayWord()]
            
        
            
            self.temperatureLabel.text = "\(Int(weather[i].temperature)) °C"
            self.date.text = "\(dayWord) , \(date)"
            self.minTempLabel.text = "\(Int(weather[i].temp_min)) °C"
            self.maxTempLabel.text = "\(Int(weather[i].temp_max)) °C"
            self.humidityLabel.text = "\(weather[i].humidity) %"
            self.windLabel.text = "\(weather[i].wind) Km/h"
            self.pressureLabel.text = "\(weather[i].pressure) hPa"
            self.countryLabel.text = "\(weather[i].country) , \( weather[i].cityName)"
            self.conditionLabel.text=weather[i].description
            //self.hourLabel.text = " h"
            }
               
           
    }
    
func didUpdateWeather(_ weatherdata: WeatherManager, weather: WeathetModel) {
    DispatchQueue.main.async {
        let iconString = weather.icon
        let iconURL=URL(string: "https://openweathermap.org/img/wn/\(iconString)@4x.png")!
        self.temperatureLabel.text = "\(weather.temperatureString) °C"
        
        URLSession.shared.dataTask(with: iconURL){ (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.conditionImage.image = UIImage(data : data)
                }
            }
        }.resume()
        let dayWord = weather.date.dateFromMilliseconds().dayWord()
        let date = weather.date.dateFromMilliseconds().yearMonthDay()
        self.countryLabel.text = "\(weather.country) , \(weather.cityName)"
        self.minTempLabel.text = "\(Int(weather.temp_min)) °C"
        self.maxTempLabel.text = "\(Int(weather.temp_max)) °C"
        self.humidityLabel.text = "\(weather.humidity) %"
        self.pressureLabel.text = "\(weather.pressure) hPa"
        
        self.windLabel.text = "\(weather.wind) Km/h"
        self.conditionLabel.text=weather.description
        self.date.text = "\(dayWord) , \(date)"
       // self.hourLabel.text = "\(weather.date.dateFromMilliseconds().hourMinute()) h"
    }
}
    
    

func didFailWithError(error: Error) {
    print(error)
}
}

