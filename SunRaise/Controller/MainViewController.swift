//
//  MainViewController.swift
//  SunRaise
//
//  Created by Dmitry Semenuk on 11/05/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController,
                            UICollectionViewDelegate,
                            UICollectionViewDataSource,
                            UICollectionViewDelegateFlowLayout,
                            UITableViewDelegate,
                            UITableViewDataSource,
                            CLLocationManagerDelegate,
                            UIScrollViewDelegate,
                            WeatherManagerDelegate {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainWeatherView: UIView!
    @IBOutlet weak var weatherByHoursView: UIView!
    @IBOutlet weak var fullDescriptionWeatherView: UIView!
    @IBOutlet weak var propertiesWeatherView: UIView!
    @IBOutlet weak var weaherByHoursCollectionView: UICollectionView!
    @IBOutlet weak var weatherByDayTableView: UITableView!
    let nibMainWeatherView = MainWeatherView.instantiateFromNib()
    let nibFullDescriptionWeatherView = FullDescriptionWeatherView.instantiateFromNib()
    let nibPropertyisWeatherView = PropertyWeatherView.instantiateFromNib()
    let locationManager = CLLocationManager()
    var weather: WeatherData?
    var weatherManager = WeatherManager()
    var dayName: [String] = []
    var dailyWeather = DailyWeatherData()
    var loadingView = UIView()
    var scrollViewOffset: CGFloat = 0
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfigurationViewConttroller()
    }
    // MARK: - Private
    private func setConfigurationViewConttroller() {
        mainWeatherView.addSubview(nibMainWeatherView)
        fullDescriptionWeatherView.addSubview(nibFullDescriptionWeatherView)
        propertiesWeatherView.addSubview(nibPropertyisWeatherView)
        loadingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height))
        loadingView.backgroundColor = .white
        let loadingImageView = UIImageView()
        loadingImageView.image = UIImage(named: "bgi")
        loadingImageView.frame = loadingView.bounds
        loadingImageView.contentMode = .scaleToFill
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = loadingView.center
        indicator.startAnimating()
        loadingView.addSubview(loadingImageView)
        loadingView.addSubview(indicator)
        view.addSubview(loadingView)
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
        setScrollView()
        dayName = Calendar.current.getDayOfTheWeeak()
    }
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    private func setWeatherManager() {
        weatherManager.delegate = self
    }
    private func setCollectionView() {
        weaherByHoursCollectionView.delegate = self
        weaherByHoursCollectionView.dataSource = self
        weaherByHoursCollectionView.register(UINib(nibName: Constant.cellCollectionReuseIdentifier,
                                                   bundle: Bundle.main),
                                             forCellWithReuseIdentifier: Constant.cellCollectionReuseIdentifier)
        weaherByHoursCollectionView.register(UINib(nibName: Constant.cellSunRaiseCollectionReuseIdentifier,
                                                   bundle: Bundle.main) ,
                                             forCellWithReuseIdentifier: Constant.cellSunRaiseCollectionReuseIdentifier)
        weaherByHoursCollectionView.showsHorizontalScrollIndicator = false
    }
    // MARK: - LocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    // MARK: - CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let hourlyWeather = dailyWeather.hourly {
            if !hourlyWeather.isEmpty {
                return hourlyWeather.count
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constant.cellCollectionReuseIdentifier,
            for: indexPath) as? WeatherByHoursCollectionViewCell
            else { return UICollectionViewCell() }
        guard let sunCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constant.cellSunRaiseCollectionReuseIdentifier,
            for: indexPath) as? SunRaiseCollectionViewCell
            else {return UICollectionViewCell()}
        let dateFormater = DateFormatter()
        let dateFormaterWithMinutes = DateFormatter()
        dateFormater.dateFormat = "HH"
        dateFormaterWithMinutes.dateFormat = "HH:mm"
        if indexPath.item == 0 {
            if let hourWeather = dailyWeather.hourly {
                cell.hourLabel.text = "NOW"
                if let rainProbability = hourWeather[indexPath.item].rain?.oneHour {
                    cell.rainProbabilityLabel.text = "\(rainProbability * 100)%"
                }
                if let temp = hourWeather[indexPath.item].temp {
                    let urlIconPart = "https://openweathermap.org/img/wn/"
                    let urlIcon = "\(urlIconPart)\(hourWeather[indexPath.item].weather[0].icon)@2x.png"
                    if let imageUrl: URL = URL(string: urlIcon) {
                        cell.iconWeather.load(url: imageUrl)
                        cell.tempretureLabel.text = "\(Int(temp))˚"
                        return cell
                    }
                }
            }
        } else {
            if (dailyWeather.hourly?.indices.contains(indexPath.item+1)) ?? false {
                if dateFormater.string(
                    from: (dailyWeather.hourly?[indexPath.item].dt!)!) == dateFormater.string(
                        from: (weather?.sunrise)!) && dateFormater.string(
                            from: (dailyWeather.hourly?[indexPath.item+1].dt!)!) > dateFormater.string(
                                from: (weather?.sunrise)!) {
                    sunCell.timeLabel.text = dateFormaterWithMinutes.string(from: (weather?.sunrise)!)
                    sunCell.iconImageView.image = UIImage(named: "sunraise")
                    return sunCell
                } else if dateFormater.string(
                    from: (dailyWeather.hourly?[indexPath.item].dt!)!) <= dateFormater.string(
                        from: (weather?.sunset)!) && dateFormater.string(
                            from: (dailyWeather.hourly?[indexPath.item+1].dt!)!) > dateFormater.string(
                                from: (weather?.sunset)!) {
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
                if let imageUrl: URL = URL(string: urlIcon) {
                    cell.iconWeather.load(url: imageUrl)
                    cell.tempretureLabel.text = "\(Int(temp))˚"
                    return cell
                }
            }
        }
        return cell
    }
    func collectionView (
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: self.weaherByHoursCollectionView.frame.size.height)
    }
    // MARK: - TableViewDelegate
    func setTableView() {
        weatherByDayTableView.delegate = self
        weatherByDayTableView.dataSource = self
        weatherByDayTableView.register(UINib(
            nibName: Constant.cellTableReuseIdentifier,
            bundle: Bundle.main), forCellReuseIdentifier: Constant.cellTableReuseIdentifier)
        weatherByDayTableView.rowHeight = CGFloat(Constant.rowHeight)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfDays
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constant.cellTableReuseIdentifier,
            for: indexPath) as? WeatherByDayTableViewCell else {return UITableViewCell()}
        if let dayleWeather = dailyWeather.daily {
            if let max = dayleWeather[indexPath.row].temp?.max, let min = dayleWeather[indexPath.row].temp?.min {
                if let dayleImage = dayleWeather[indexPath.item].weather {
                    let urlIcon = "https://openweathermap.org/img/wn/\(dayleImage[0].icon)@2x.png"
                    cell.dayLabel.text = dayName[indexPath.row]
                    cell.weatherIcon.load(url: URL(string: urlIcon)!)
                    cell.maxTemprtureLabel.text = "\(String(describing: Int(max)))˚"
                    cell.minTempretureLabel.text = "\(String(describing: Int(min)))˚"
                }
            }
        }
        return cell
    }
    // MARK: - ScrollViewDelegate
    func setScrollView() {
        scrollView.delegate = self
    }
    // MARK: - WeatherManagerDelegate
    func getWeather(weather: WeatherData) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        self.weather = weather
        DispatchQueue.main.async {
            self.nibMainWeatherView.set(
                weather.cityName ?? "",
                weather.mainDiscr ?? "",
                "\(Int?(weather.tempreture!) ?? 0)˚",
                "\(weather.minTempreture ?? 0)˚",
                "\(weather.maxTempreture ?? 0)˚")
            self.nibFullDescriptionWeatherView.set(
                weather.fullDescription ?? "")
            self.nibPropertyisWeatherView.set(
                dateFormater.string(from: weather.sunrise),
                rainProbability: "0%",
                "\(weather.clouds ?? 0)",
                "\(weather.pressure ?? 0)",
                distanceValue: "\(weather.visibility ?? 0)")
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
