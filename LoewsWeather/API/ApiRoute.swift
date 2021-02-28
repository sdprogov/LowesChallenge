//
//  ApiRoute.swift
//  LoewsWeather
//
//  Created by Stefan Progovac on 2/27/21.
//

import Foundation

fileprivate let apiKey = "65d00499677e59496ca2f318eb68c049"

enum ApiRoute {

	case getWeather(city: String)

	var path: String {
		switch self {
		case .getWeather(let city): return "forecast?q=\(city)&appid=\(apiKey)"
		}
	}

	func url(for environment: ApiEnvironment) -> String {
		return "\(environment.url)/\(path)"
	}
}
