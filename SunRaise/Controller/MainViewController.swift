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
                            UIScrollViewDelegate {
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
    var weather = WeatherData()
    var dailyWeather = DailyWeatherData()
    var dayName: [String] = []
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
        //weatherManager.delegate = self
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
            let lat: String = "\(location.coordinate.latitude)"
            let lon: String = "\(location.coordinate.longitude)"
            WeatherService.sharedInstance.getDailyJSON(lat: lat, lon: lon) { (data) in
                self.setWeatherData(data)
            }
            WeatherService.sharedInstance.getHourlyJSON(lat: lat, lon: lon) { (data) in
                self.setDailyWeather(data)
            }
        }
    }
    func setWeatherData(_ data: WeatherModel) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        self.weather.cityName = data.name
        self.weather.dt = data.dt
        self.weather.tempreture = Int(data.main.temp)
        self.weather.maxTempreture = Int(data.main.temp_max)
        self.weather.sunrise = data.sys.sunrise
        self.weather.sunset = data.sys.sunset
        self.weather.minTempreture = Int(data.main.temp_min)
        self.weather.pressure = data.main.pressure
        self.weather.humidity = data.main.humidity
        self.weather.mainDiscr = data.weather[0].main
        self.weather.fullDescription = data.weather[0].description
        self.weather.visibility = data.visibility
        DispatchQueue.main.async {
            self.nibMainWeatherView.set(
                self.weather.cityName ?? "",
                self.weather.mainDiscr ?? "",
                "\(Int?(self.weather.tempreture!) ?? 0)˚",
                "\(self.weather.minTempreture ?? 0)˚",
                "\(self.weather.maxTempreture ?? 0)˚")
            self.nibFullDescriptionWeatherView.set(
                self.weather.fullDescription ?? "")
            self.nibPropertyisWeatherView.set(
                dateFormater.string(from: self.weather.sunrise ?? Date()),
                rainProbability: "0%",
                "\(self.weather.clouds ?? 0)",
                "\(self.weather.pressure ?? 0)",
                distanceValue: "\(self.weather.visibility ?? 0)")
        }
    }
    func setDailyWeather( _ data: HourlyAndDailyModel) {
        dailyWeather.hourly = data.hourly
        dailyWeather.daily = data.daily
        DispatchQueue.main.async {
            self.weatherByDayTableView.reloadData()
            self.weaherByHoursCollectionView.reloadData()
            self.loadingView.animate(isHidden: true)
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
    //swiftlint:disable all
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
                        from: (weather.sunrise)!) && dateFormater.string(
                            from: (dailyWeather.hourly?[indexPath.item+1].dt!)!) > dateFormater.string(
                                from: (weather.sunrise)!) {
                    sunCell.timeLabel.text = dateFormaterWithMinutes.string(from: (weather.sunrise)!)
                    sunCell.iconImageView.image = UIImage(named: "sunraise")
                    return sunCell
                } else if dateFormater.string(
                    from: (dailyWeather.hourly?[indexPath.item].dt!)!) <= dateFormater.string(
                        from: (weather.sunset)!) && dateFormater.string(
                            from: (dailyWeather.hourly?[indexPath.item+1].dt!)!) > dateFormater.string(
                                from: (weather.sunset)!) {
                    sunCell.timeLabel.text = dateFormaterWithMinutes.string(from: (weather.sunset)!)
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
    //swiftlint:enable all
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
}
