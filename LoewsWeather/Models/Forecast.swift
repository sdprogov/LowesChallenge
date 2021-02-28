//
//  Forecast.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

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
