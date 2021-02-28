//
//  ApiEnvironment.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

enum ApiEnvironment: String {
	case production = "https://api.openweathermap.org/data/2.5"

	var url: String {
		return rawValue
	}
}
