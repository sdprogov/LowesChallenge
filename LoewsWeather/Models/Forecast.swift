//
//  Forecast.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation
import UIKit

struct Forecast: Codable {
	let overview: MainForecast
	let weather: [Weather]
	let clouds: Clouds
	let wind: Wind

	enum CodingKeys: String, CodingKey {
		case overview = "main"
		case weather, clouds, wind
	}
}

extension Forecast {
	var weatherIcon: UIImage {
		let weatherDescription = self.weather.first?.briefDescription ?? ""
		if weatherDescription.contains("rain") {
			return #imageLiteral(resourceName: "rainy")
		}
		if self.clouds.coverage < 50 {
			return #imageLiteral(resourceName: "sunny")
		} else {
			return #imageLiteral(resourceName: "cloudy")
		}
	}
}
