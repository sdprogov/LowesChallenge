//
//  DetailedForecastViewController.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import UIKit

class DetailedForecastViewController: UIViewController {

	@IBOutlet var weatherIcon: UIImageView!
	@IBOutlet var temperature: UILabel!
	@IBOutlet var feelsLike: UILabel!
	@IBOutlet var clouds: UILabel!

	var forecast: Forecast?

	override func viewWillAppear(_ animated: Bool) {
		guard let forecast = forecast else { return }

		weatherIcon.image = forecast.weatherIcon
		temperature.text = String(forecast.overview.temperature.getFahrenheitToNearestDegree)
		feelsLike.text = "Feels like: \(String(forecast.overview.feelsLike.getFahrenheitToNearestDegree))"
		if let weather = forecast.weather.first {
			clouds.text = weather.briefDescription
		}
	}
}
