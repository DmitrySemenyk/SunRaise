//
//  MainViewController.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 11/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, WeatherManagerDelegate {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var mainWeatherView: UIView!
    @IBOutlet weak var weatherByHoursView: UIView!
    @IBOutlet weak var fullDescriptionWeatherView: UIView!
    @IBOutlet weak var propertiesWeatherView: UIView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDiscription: UILabel!
    @IBOutlet weak var currentWeatherTempretureLabel: UILabel!
    @IBOutlet weak var curentWeakDayLabel: UILabel!
    @IBOutlet weak var stateOfTheDayLabel: UILabel!
    @IBOutlet weak var nightTempretureLabel: UILabel!
    @IBOutlet weak var dayTempretureLabel: UILabel!
    @IBOutlet weak var weaherByHoursCollectionView: UICollectionView!
    @IBOutlet weak var weatherByDayTableView: UITableView!
    @IBOutlet weak var fullDescriptionWeatherLabel: UILabel!
    @IBOutlet weak var timeWhenSunriseLabel: UILabel!
    @IBOutlet weak var rainProbability: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var precipitationValueLabel: UILabel!
    @IBOutlet weak var distanceVisibilityLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    
    let cellCollectionReuseIdentifier = "WeatherByHoursCollectionViewCell"
    let cellSunRaiseCollectionReuseIdentifier = "SunRaiseCollectionViewCell"
    let cellTableReuseIdentifier = "WeatherByDayTableViewCell"
    
    var weather: WeatherData?
    var weatherManager = WeatherManager()
    var dayName: [String] = []
    var dailyWeather = DailyWeatherData()
    
    var loadingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfigurationViewConttroller()
    }
    
    
    //MARK: - ConfigurattionViewController
    func setConfigurationViewConttroller(){
        loadingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height))
        loadingView.backgroundColor = .white
        
        let loadingImageView = UIImageView()
        loadingImageView.image = UIImage(named: "100-1001332_forest-mountains-sunset-cool-weather-minimalism-weather-wallpaper")
        loadingImageView.frame = loadingView.bounds
        loadingImageView.contentMode = .scaleToFill
        
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.center = loadingView.center
        indicator.startAnimating()
        
        loadingView.addSubview(loadingImageView)
        loadingView.addSubview(indicator)

        
        self.view.addSubview(loadingView)
        
        
        bgImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        bgImageView.contentMode = .scaleToFill
        
        
        
        mainWeatherView.addBottomLine(color: .white, height: 1)
        fullDescriptionWeatherView.addBottomLine(color: .white, height: 1)
        weatherByHoursView.addBottomLine(color: .white, height: 1)
        propertiesWeatherView.addBottomLine(color: .white, height: 1)
        weatherByDayTableView.addBottomLine(color: .white, height: 1)
        
        setWeatherManager()
        setLocationManager()
        setCollectionView()
        setTableView()
        
        dayName = Calendar.current.getDayOfTheWeeak()
        curentWeakDayLabel.text = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
    }
    
    //MARK: - LocationManager
    func setLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //MARK: - CollectionViewDelegate
    func setCollectionView(){
        weaherByHoursCollectionView.delegate = self
        weaherByHoursCollectionView.dataSource = self
        weaherByHoursCollectionView.register(UINib(nibName: cellCollectionReuseIdentifier,
                                                   bundle: Bundle.main),
                                             forCellWithReuseIdentifier: cellCollectionReuseIdentifier)
        weaherByHoursCollectionView.register(UINib(nibName: cellSunRaiseCollectionReuseIdentifier,
                                                   bundle: Bundle.main) ,
                                             forCellWithReuseIdentifier: cellSunRaiseCollectionReuseIdentifier)
        
        weaherByHoursCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let hourlyWeather = dailyWeather.hourly{
            if !hourlyWeather.isEmpty{
                return hourlyWeather.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCollectionReuseIdentifier, for: indexPath) as! WeatherByHoursCollectionViewCell
        
        let sunCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellSunRaiseCollectionReuseIdentifier, for: indexPath) as! SunRaiseCollectionViewCell
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH"
        
        let dateFormaterWithMinutes = DateFormatter()
        dateFormaterWithMinutes.dateFormat = "HH:mm"
        
        if indexPath.item == 0 {
            if let hourWeather = dailyWeather.hourly {
                cell.hourLabel.text = "NOW"
                if let rainProbability = hourWeather[indexPath.item].rain?.oneHour {
                    cell.rainProbabilityLabel.text = "\(rainProbability * 100)%"
                }
                if let temp = hourWeather[indexPath.item].temp {
                    let urlIcon = "https://openweathermap.org/img/wn/\(hourWeather[indexPath.item].weather[0].icon)@2x.png"
                    if let imageUrl: URL = URL(string: urlIcon){
                        cell.iconWeather.load(url: imageUrl)
                        cell.tempretureLabel.text = "\(Int(temp))˚"
                        return cell
                    }
                }
            }
        }else{
            if (dailyWeather.hourly?.indices.contains(indexPath.item+1))! {
            
                if dateFormater.string(from: (dailyWeather.hourly?[indexPath.item].dt!)!) == dateFormater.string(from: (weather?.sunrise)!) && dateFormater.string(from: (dailyWeather.hourly?[indexPath.item+1].dt!)!) > dateFormater.string(from: (weather?.sunrise)!) {
                    
                    sunCell.timeLabel.text = dateFormaterWithMinutes.string(from: (weather?.sunrise)!)
                    sunCell.iconImageView.image = UIImage(named: "sunraise")
                    
                    return sunCell
                }else if dateFormater.string(from: (dailyWeather.hourly?[indexPath.item].dt!)!) <= dateFormater.string(from: (weather?.sunset)!) && dateFormater.string(from: (dailyWeather.hourly?[indexPath.item+1].dt!)!) > dateFormater.string(from: (weather?.sunset)!) {
                    
                    sunCell.timeLabel.text = dateFormaterWithMinutes.string(from: (weather?.sunset)!)
                    sunCell.iconImageView.image = UIImage(named: "sunset")
                    
                    return sunCell
                }
            }
        }
        
        
        
        if let hourWeather = dailyWeather.hourly {
            
            cell.hourLabel.text = dateFormater.string(from: hourWeather[indexPath.item].dt!)
            
            if let rainProbability = hourWeather[indexPath.item].rain?.oneHour {
                cell.rainProbabilityLabel.text = "\(rainProbability * 100)%"
            }
            if let temp = hourWeather[indexPath.item].temp {
                
                let urlIcon = "https://openweathermap.org/img/wn/\(hourWeather[indexPath.item].weather[0].icon)@2x.png"
                if let imageUrl: URL = URL(string: urlIcon){
                    cell.iconWeather.load(url: imageUrl)
                    cell.tempretureLabel.text = "\(Int(temp))˚"
                    return cell
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: self.weaherByHoursCollectionView.frame.size.height)
    }
    
    //MARK: - TableViewDelegate
    func setTableView(){
        weatherByDayTableView.delegate = self
        weatherByDayTableView.dataSource = self
        weatherByDayTableView.register(UINib(nibName: "WeatherByDayTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellTableReuseIdentifier)
        
        weatherByDayTableView.rowHeight = 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableReuseIdentifier, for: indexPath) as! WeatherByDayTableViewCell
        if let dayleWeather = dailyWeather.daily {
            if let max = dayleWeather[indexPath.row].temp?.max, let min = dayleWeather[indexPath.row].temp?.min {
                
                let urlIcon = "https://openweathermap.org/img/wn/\(dayleWeather[indexPath.item].weather![0].icon)@2x.png"
                
                cell.dayLabel.text = dayName[indexPath.row]
                cell.weatherIcon.load(url: URL(string: urlIcon)!)
                cell.maxTemprtureLabel.text = "\(String(describing: Int(max)))˚"
                cell.minTempretureLabel.text = "\(String(describing: Int(min)))˚"
            }
        }
        return cell
    }
    //MARK: - WeatherManagerDelegate
    func setWeatherManager(){
        weatherManager.delegate = self
    }
    
    func getWeather(weather: WeatherData) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        self.weather = weather
        
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
            self.weatherDiscription.text = weather.mainDiscr
            self.currentWeatherTempretureLabel.text = "\(Int?(weather.tempreture!) ?? 0)˚"
            self.dayTempretureLabel.text = "\(weather.maxTempreture ?? 0)˚"
            self.nightTempretureLabel.text = "\(weather.minTempreture ?? 0)˚"
            self.fullDescriptionWeatherLabel.text = weather.fullDescription
            self.timeWhenSunriseLabel.text = dateFormater.string(from: weather.sunrise)
            self.rainProbability.text = "0%"
            self.windSpeedLabel.text = "\(weather.clouds ?? 0)"
            self.precipitationValueLabel.text = "\(weather.pressure ?? 0)"
            self.distanceVisibilityLabel.text = "\(weather.visibility ?? 0)"
            
            
        }
        
        
        
    }
    
    func getDailyWeather(dailyWeather: DailyWeatherData) {
        DispatchQueue.main.async {
            self.dailyWeather = dailyWeather
            self.weatherByDayTableView.reloadData()
            self.weaherByHoursCollectionView.reloadData()
            
            self.loadingView.animate(isHidden: true)
        }
        
    }
    
}







