//
//  MainForecast.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

struct MainForecast: Codable {
	let temperature: Double
	let feelsLike: Double
	let minimumTemperature: Double
	let maximumTemperature: Double
	let pressure: Double
	let seaLevel: Double
	let groundLevel: Double
	let humidity: Double

	enum CodingKeys: String, CodingKey {
		case pressure, humidity
		case temperature = "temp"
		case feelsLike = "feels_like"
		case minimumTemperature = "temp_min"
		case maximumTemperature = "temp_max"
		case seaLevel = "sea_level"
		case groundLevel = "grnd_level"
	}
}
